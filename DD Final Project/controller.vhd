library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity controller is
    port (
        clk : in std_logic;
        rst : in std_logic;
        OPSel: in std_logic_vector(5 downto 0);
        IRIn: in std_logic_vector(5 downto 0);
        PCWriteCond: out std_logic;
        PCWrite: out std_logic;
        IorD: out std_logic;
        MemRead: out std_logic;
        MemWrite: out std_logic;
        MemToReg: out std_logic;
        IRWrite: out std_logic;
        JumpAndLink: out std_logic;
        IsSigned: out std_logic;
        PCSource: out std_logic_vector(1 downto 0);
        ALUOp: out std_logic_vector(5 downto 0);
        ALUSrcB: out std_logic_vector(1 downto 0);
        ALUSrcA: out std_logic;
        RegWrite: out std_logic;
        RegDst: out std_logic
    );   
end controller;

architecture BHV of controller is

	type state_t is (fetch1, fetch2, decode1, load1, load2, load3, load4, store1, store2, rtype1, rtype2,IType1, IType2, ja1, jl1, jl2, branch1, branch2);
	signal state, next_state: state_t;

begin
  
	process(clk, rst)
	begin
		if (rst = '1') then
			state <= fetch1;
		elsif(rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;


	process(state, OPSel)
	begin
        next_state <= state;

        PCWriteCond <= '0';
        PCWrite <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        MemToReg <= '0';
        IRWrite <= '0';
        JumpAndLink <= '0';
        IsSigned <= '0';
        ALUSrcA <= '0';
        RegWrite <= '0';
        RegDst <= '0';
        PCSource <= "00";
        ALUSrcB <= "00";
        ALUOp <= "011110";


        case (state) is

            when fetch1 =>
                -- Instruction Fetch 1
                --mem[Pc]
                IorD <= '0';
                --pc = pc +4
                ALUSrcA <= '0';
                ALUSrcB <= "01";
                AluOp <= "111111"; 

                PCSource <= "00";
                PCWrite <= '1';


                next_state <= fetch2;
              
            when fetch2 =>
                -- Instruction Fetch 2

                IRWrite <= '1';

                next_state <= decode1;
                          
            -- Instruction Decode / register fetch

            when decode1 =>
            ALUSrcA <= '0';
            ALUSrcB <= "01";

                case(OPSel) is

                    when "000000" =>-- rtype

                        next_state <= rtype1;

                    when "000010" =>-- jump to address


                        next_state <= ja1;

                    when "000011" =>-- jump and link
                        -- RegWrite <= '1';
                        -- JumpAndLink <='1';
                        

                        next_state <= jl1;

                    when "000100" | "000101" | "000110" | "000111" | "000001"   => -- branch

                       next_state <= branch1;

                    when "001001" | "001100" | "001101" | "001110" | "001010" | "001011" | "010000" | "010010"  => -- Itype

                        next_state <= IType1;

                    when "100011"   =>

                        next_state <= load1;
                    
                    when "101011"   =>

                        next_state <= store1;

                    when others => null;
                end case;
                -- R Type Execution

            when rtype1 =>
                ALUSrcA <= '1';
                ALUSrcB <= "00";

                AluOp  <= "000000"; 

                if (IRIn = "011001") then
                    next_state <= fetch1;
                elsif (IRIn = "011000") then
                    AluOp  <= "111000"; 
                    next_state <= fetch1;
                else
                    next_state <= rtype2;

                end if;

            when rtype2 =>
             --R Type Completion
                AluOp  <= "000000"; 

                if (IRIn = "001000") then
                    PCSource <= "00";
                    PCWrite <= '1';
                
                else
                    RegDst <= '1';
                    RegWrite <= '1';
                    MemtoReg <= '0';
                end if;
                --alu mux sel 00
                next_state <= fetch1;

            when IType1 =>
                --IType1 Execution
                ALUSrcA <= '1';
                ALUSrcB <= "10";
                --addui
                if (OPSel = "001001") then
                    IsSigned <= '1';
                    AluOp  <= "001001";
                    --subiu
                elsif (OPSel = "010000") then
                    IsSigned <= '1';
                    AluOp  <= "010000";
                    --andi maybe right
                elsif (OPSel = "001100") then
                    IsSigned <= '0';
                    AluOp  <= "001100";
                    --ori
                elsif (OPSel = "001101") then
                    IsSigned <= '0';
                    AluOp  <= "001001";
                   -- xori
                elsif (OPSel = "001110") then
                    IsSigned <= '0';
                    AluOp  <= "001011";
                    --slti                
                elsif (OPSel = "001010") then
                    IsSigned <= '1';
                    AluOp  <= "010000";
                    --sltiu
                elsif (OPSel = "001011") then
                    IsSigned <= '1';
                    AluOp  <= "010001";                      
                end if;

                next_state <= IType2;         

            when IType2 =>
                --IType2 Completion
                RegDst <= '0';
                RegWrite <= '1';
                MemtoReg <= '0';
                --alu mux sel 00
                next_state <= fetch1;
    

            when ja1 =>
            if (OPSel = "000011") then
               RegWrite <= '1';
               JumpAndLink <='1';
               PCSource <= "10";
            else   
                PCSource <= "10";
             end if;
                PCWrite <= '1';


                next_state <= fetch1;

            -- when jr1 =>
            --     PCSource <= "10";
            --     PCWrite <'1';


            --     next_state <= fetch1;


            when jl1 =>
                ALUSrcA <= '0';
                ALUSrcB <= "01";
                AluOp  <= "000000";



                next_state <= jl2;

            when jl2 =>


            RegWrite <= '1';
            JumpAndLink <='1';
            PCSource <= "10";
            PCWrite <= '1';

                next_state <= fetch1;

            when branch1 =>
                -- calc location

                IsSigned <= '1';
                ALUSrcB <= "11";
                ALUSrcA <= '0';
                ALUOp <= "100111";

                next_state <= branch2;

            when branch2 =>
                -- condition 
               PCSource <= "01"; 
               PCWriteCond <= '1';
               ALUSrcB <= "00";
               ALUSrcA <= '1';
               ALUOp <= OPSel;
                next_state <= fetch1;

            when load1 =>
              -- addr = base + offset
                ALUSrcA <= '1';
                IsSigned <= '0';
                ALUSrcB <= "10";
                ALUOp <= "100011";


                next_state <= load2;

            when load2 =>

                IorD <= '1'; 
                MemRead <= '1';
                next_state <= load3;
                
            when load3 =>

             
                next_state <= load4;
            
            when load4 =>
                MemToReg <= '1';
                RegDst <= '0';
                RegWrite <= '1';
                

                next_state <= fetch1; 
            
            when store1 =>
                ALUSrcA <= '1';
                ALUOp <= "000000";
                IsSigned <= '0';
                ALUSrcB <= "10";

                next_state <= store2;

            when store2 =>
                 IorD <= '1';
                 MemWrite <= '1';
                next_state <= fetch1;
                


            when others => null;
        end case;


    end process;

end BHV;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity alu_control is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
        AluOp : in std_logic_vector(5 downto 0);
        IR5 : in std_logic_vector(5 downto 0);
        IR20 : in std_logic_vector(4 downto 0);
		OPSelect : out std_logic_vector(5 downto 0);
        hien : out std_logic;
        loen : out std_logic;
        hiloen : out std_logic_vector(1 downto 0)

	);
end alu_control;

architecture BHV of alu_control is

begin

    process(AluOp, IR5)
    begin

        hien <= '0';
        loen <= '0';
        hiloen <= "00";
        OPSelect <= "000000";

        if (AluOp = "000000") then
            if(IR5 = "100001") then --add
                OPSelect <= "000000";

            elsif(IR5 = "100011") then --sub
                OPSelect <= "000010";

            elsif(IR5 = "011000") then -- mult
                OPSelect <= "000100";

            elsif(IR5 = "011001") then -- multu
                OPSelect <= "000101";
                hien <= '1';
                loen <= '1';

            -- elsif(IR5 = "011000") then -- mult
            --     OPSelect <= "000100";
            --     hien <= '1';
            --     loen <= '1';

            elsif(IR5 = "100100") then --and
                OPSelect <= "000110";

            elsif(IR5 = "100101") then --or
                OPSelect <= "001000";

            elsif(IR5 = "100110") then --xor
                OPSelect <= "001010";

            elsif(IR5 = "000010") then --srl
                OPSelect <= "001100";

            elsif(IR5 = "000000") then --sll NOT RIGHT
                OPSelect <= "001101";

            elsif(IR5 = "000011") then --sra
                OPSelect <= "001110";

            elsif(IR5 = "101010") then --slt
                OPSelect <= "001111";

            elsif(IR5 = "101011") then --sltu
                OPSelect <= "010010";

            elsif(IR5 = "010000") then --mfhi
                OPSelect <= "000000";
                hiloen <= "10";

            elsif(IR5 = "010010") then --mflo
                OPSelect <= "000000";
                hiloen <= "01";

            elsif(IR5 = "001000") then --j   
                OPSelect <= "011111";
            else
                OPSelect <= "000000";
            end if;
        elsif (AluOp = "100011") then -- load 
            OPSelect <= "000000";
            hiloen <= "00";

        elsif (AluOp = "001100") then  --andi maybe right? 
            OPSelect <= "000111";

        elsif (AluOp = "001001") then  --addiu 
            OPSelect <= "000001";

        elsif (AluOp = "111000") then  --mult signed
            OPSelect <= "000100";
            hien <= '1';
            loen <= '1';

        elsif (AluOp = "010000") then  --subiu
            OPSelect <= "000011";

        elsif (AluOp = "101011") then  --store
            OPSelect <= "010110";

        elsif (AluOp = "111111") then  --pc fetch
            OPSelect <= "000000";

        elsif (AluOp = "011001") then  --multu
            OPSelect <= "000101";

        elsif (AluOp = "010000") then  --mfhi
            OPSelect <= "010011";
            hiloen <= "10";

        elsif (AluOp = "010010") then  --mflo
            OPSelect <= "010100";
            hiloen <= "01";


        elsif (AluOp = "100111") then  --branch1
            OPSelect <= "000000";

        elsif (AluOp = "000100") then  --branch eq
            OPSelect <= "010111";

        elsif (AluOp = "000101") then  --branch  not eq
            OPSelect <= "011000";


        elsif (AluOp = "000110") then  --branch lt eq
            OPSelect <= "011001";

        elsif (AluOp = "000111") then  --branch gtr than 
            OPSelect <= "011010";

        

        elsif (AluOp = "000001") then  --branch 

            if (IR20 = "00001") then --branch gtr than or eq
                OPSelect <= "011100";
            else  -- less than
                OPSelect <= "011011";
            end if;


        else
            OPSelect <= AluOp;

        end if;

    end process;

end BHV;
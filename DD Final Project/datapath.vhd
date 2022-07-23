library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library altera_mf;
use altera_mf.altera_mf_components.all;


entity datapath is
    port (
        clk : in std_logic;
        rst : in std_logic;
        PCWriteCond: in std_logic;
        PCWrite: in std_logic;
        IorD: in std_logic;
        MemRead: in std_logic;
        MemWrite: in std_logic;
        MemToReg: in std_logic;
        IRWrite: in std_logic;
        JumpAndLink: in std_logic;
        IsSigned: in std_logic;
        PCSource: in std_logic_vector(1 downto 0);
        ALUOp: in std_logic_vector(5 downto 0);
        ALUSrcB: in std_logic_vector(1 downto 0);
        ALUSrcA: in std_logic;
        RegWrite: in std_logic;
        RegDst: in std_logic;   
        --Button: in std_logic_vector(1 downto 0);
        Button1: in std_logic;
        switches: in std_logic_vector(9 downto 0);
        LEDs: out std_logic_vector(31 downto 0);
        IRToCONTROL: out std_logic_vector(5 downto 0);
        IRLowToCONTROL: out std_logic_vector(5 downto 0)
	);

    
end datapath;


architecture BHV of datapath is

    signal ALUToPC : std_logic_vector(31 downto 0);
    signal PCToMux : std_logic_vector(31 downto 0);
    signal ALUOutToMUX1 : std_logic_vector(31 downto 0);
    signal MUX1ToMEMORY : std_logic_vector(31 downto 0);
    signal EXTENDToMEMORY : std_logic_vector(31 downto 0);
   -- signal RegBToMEMORY : std_logic_vector(31 downto 0);
    signal MEMOut : std_logic_vector(31 downto 0); 
    signal MDROut : std_logic_vector(31 downto 0);
    signal IROut : std_logic_vector(31 downto 0);
    signal Mux22Out : std_logic_vector(4 downto 0);
    signal Mux23Out : std_logic_vector(31 downto 0);
    signal ALUMuxToMUX3 : std_logic_vector(31 downto 0);
    signal regAIn : std_logic_vector(31 downto 0);
    signal regBIn : std_logic_vector(31 downto 0); 
    signal regAOut : std_logic_vector(31 downto 0);
    signal regBOut : std_logic_vector(31 downto 0); 
    signal Mux24Out : std_logic_vector(31 downto 0);
    signal SEOut : std_logic_vector(31 downto 0);
    signal sl2_1OUT : std_logic_vector(31 downto 0);
    signal Mux31Out : std_logic_vector(31 downto 0);
    signal OPSel : std_logic_vector(5 downto 0);
    signal branchTaken : std_logic;
    signal andOut : std_logic;
    signal PCWriteIn : std_logic;
    signal aluResult : std_logic_vector(31 downto 0);
    signal aluResultHi : std_logic_vector(31 downto 0);
    signal aluOutReg : std_logic_vector(31 downto 0);
    signal aluLoReg : std_logic_vector(31 downto 0);
    signal aluHiReg : std_logic_vector(31 downto 0);
    signal sl2_2OUT : std_logic_vector(27 downto 0);
    signal catOut : std_logic_vector(31 downto 0);
    signal ALU_LO_HI : std_logic_vector(1 downto 0);
    signal HI_en : std_logic;
    signal LO_en : std_logic;
    


begin

    U_PC: entity work.reg1
     generic map( 
        n => 32
     )
	port map (
		-- PCWriteIn => PCWriteIn,
        -- MuxIn => ALUToPC,
		-- PCOut => PCToMux


        I => ALUToPC,
	    clock => clk,
	    load  => PCWriteIn,
	    clear => rst,
	    Q => PCToMux
	);

    U_mux2x1_1: entity work.mux_2x1
    generic map( 
        width => 32
    )
	port map (
        in1    => PCToMUX,
        in2    => aluOutReg,
        sel    => IorD,
        output => MUX1ToMEMORY
	);

    u_memory : entity work.memory port map(
        clk => clk,
        rst => rst, --???
        addr => MUX1ToMEMORY,
        MemWrite => MemWrite,
        MemRead => MemRead,
        Inporten => Button1,
        s0or1 => switches(9),
        --Buttons => Buttons;
        switch => EXTENDToMEMORY,
        WrData => RegBOut,       
        RdData => MEMOut,
        outPort => LEDs
    );

    U_zeroExtend: entity work.zero_extend
    -- generic map( 
    --     width => 32
    -- )
	port map (
        switches => switches,
		extendOut => EXTENDToMEMORY
	);

    U_MSRreg: entity work.reg2
    generic map( 
        n => 32
    )
	port map (
        input => MEMOut,
        clk => clk,
        rst => rst,
        output => MDROut
	);


    U_IReg: entity work.reg1
    generic map( 
        n => 32
    )
	port map (
        I => MEMOut,
        clock => clk,
        load => IRWrite,
        clear => rst,
        Q => IROut
	);

    U_mux2x1_2: entity work.mux_2x1
    generic map( 
        width => 5
    )
	port map (
        in1    => IROut(20 downto 16),
        in2    => IROut(15 downto 11),
        sel    => RegDst,
        output => Mux22Out
	);

    U_mux2x1_3: entity work.mux_2x1
    generic map( 
        width => 32
    )
	port map (
        in1    => ALUMuxToMUX3,
        in2    => MDROut,
        sel    => MemToReg,
        output => Mux23Out
	);

    U_REGFILE: entity work.register1
    -- generic map( 
    --     width => 32
    -- )
	port map (
        clk => clk,
        rst => rst,
        rd_addr0 => IROut(25 downto 21),
        rd_addr1 => IROut(20 downto 16),
        wr_addr => Mux22Out,
        wr_en => RegWrite,
        jump => JumpAndLink,
        wr_data => Mux23Out,
        regA => RegAIn,
        regB => RegBIn
	);

    U_RegA: entity work.reg2
    generic map( 
        n => 32
    )
	port map (
        input => RegAIn,
        clk => clk,
        rst => rst,
        output => RegAOut
	);


    U_RegB: entity work.reg2
    generic map( 
        n => 32
    )
	port map (
        input => RegBIn,
        clk => clk,
        rst => rst,
        output => RegBOut
	);

    U_mux2x1_4: entity work.mux_2x1
    generic map( 
        width => 32
    )
	port map (
        in1    => PCToMux,
        in2    => RegAOut,
        sel    => ALUSrcA,
        output => Mux24Out
	);

    U_MUX3x1_1: entity work.mux_4x1 
    generic map( 
        width => 32
    )
	port map (
        in1    => RegBOut,
        in3    => SEOut,
        in4    => sl2_1OUT,
        sel    => ALUSrcB,
        output => Mux31Out
	);

    U_SL2_1: entity work.sl2 
	port map (
        input => SEOut,
		SLOut => sl2_1OUT
	);

    U_SExtend: entity work.sign_extend 
	port map (
       input => IROut(15 downto 0),
       sign => IsSigned,
       SEOut => SEOut
	);


    U_mainALU : entity work.mainalu 
    generic map(
        WIDTH => 32
    )
    port map(
        input1 => Mux24Out,
        input2 => Mux31Out,
        sel => OPSel,
        shift => IROut(10 downto 6),
        result => aluResult,
        resultHi => aluResultHi,
        branchTaken => branchTaken
    );

    U_aluOut: entity work.reg2
    generic map( 
        n => 32
    )
	port map (
        input => aluResult,
        clk => clk,
        rst => rst,
        output => aluOutReg
	);

    U_aluLo: entity work.reg1
    generic map( 
        n => 32
    )
	port map (
        I => aluResult,
        clock => clk,
        load => LO_en,
        clear => rst,
        Q => aluLoReg
	);

    U_aluHi: entity work.reg1
    generic map( 
        n => 32
    )
	port map (
        I => aluResultHi,
        clock => clk,
        load => HI_en,
        clear => rst,
        Q => aluHiReg
	);

    U_SL2_2: entity work.sl2_2 
	port map (
        input => IROut(25 downto 0),
		SLOut => sl2_2OUT
	);

    U_cat: entity work.concat 
	port map (
        pcinput => PCToMux(31 downto 28),
        input => sl2_2OUT,
		catOut => catOut
	);

    U_MUX3x1_2: entity work.mux_3x1 
	port map (
        in1    => aluResult,
        in2    => aluOutReg,
        in3    => catOut,
        sel    => PCSource,
        output => ALUToPC
	);

    U_MUX3x1_3: entity work.mux_3x1 
	port map (
        in1    => aluOutReg,
        in2    => aluLoReg,
        in3    => aluHiReg,
        sel    => ALU_LO_HI,
        output => ALUMuxToMUX3
	);

    U_ALUctrl: entity work.alu_control
	port map (
        AluOp => ALUOp,
        IR5 => IROut(5 downto 0),
        IR20 => IROut(20 downto 16),
		OPSelect => OPSel,
        hien => HI_en,
        loen => LO_en,
        hiloen => ALU_LO_HI
	);

    U_ANDent: entity work.AND_ent
	port map (
        x => PCWriteCond,
        y =>branchTaken,
        F => andOut
	);

    U_ORent: entity work.OR_ent
	port map (
        x =>  PCWrite,
        y =>  andOut, 
        F => PCWriteIn
	);

    process(IROut)
    begin
        IRToCONTROL <= IROut(31 downto 26);
        IRLowToCONTROL <= IROut(5 downto 0);
    end process;
end BHV;
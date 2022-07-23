library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_final is
    port (
      clk : in std_logic;
      switch : in std_logic_vector(9 downto 0);
      button : in std_logic_vector(1 downto 0);
      --rst              : in  std_logic;
      --LEDs: out std_logic_vector(31 downto 0)
      -- Inport0en       : in  std_logic;
      -- Inport1en       : in  std_logic;
      led0    : out std_logic_vector(6 downto 0);
      led0_dp : out std_logic;
      led1    : out std_logic_vector(6 downto 0);
      led1_dp : out std_logic;
      led2    : out std_logic_vector(6 downto 0);
      led2_dp : out std_logic;
      led3    : out std_logic_vector(6 downto 0);
      led3_dp : out std_logic;
      led4    : out std_logic_vector(6 downto 0);
      led4_dp : out std_logic;
      led5    : out std_logic_vector(6 downto 0);
      led5_dp : out std_logic

	);
end top_level_final;

architecture BHV of top_level_final is


    component decoder7seg
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(6 downto 0));
    end component;


  --signal OPSel:  std_logic_vector(5 downto 0);
  signal PCWriteCond:  std_logic;
  signal PCWrite:  std_logic;
  signal IorD:  std_logic;
  signal MemRead:  std_logic;
  signal MemWrite:  std_logic;
  signal MemToReg:  std_logic;
  signal IRWrite:  std_logic;
  signal JumpAndLink:  std_logic;
  signal IsSigned:  std_logic;
  signal PCSource:  std_logic_vector(1 downto 0);
  signal ALUOp:  std_logic_vector(5 downto 0);
  signal ALUSrcB:  std_logic_vector(1 downto 0);
  signal ALUSrcA:  std_logic;
  signal RegWrite:  std_logic;
  signal RegDst:  std_logic;
  signal IRToCONTROL: std_logic_vector(5 downto 0);
  signal IRLowToCONTROL: std_logic_vector(5 downto 0); 
  signal LEDsOUT: std_logic_vector(31 downto 0);
  signal notbutton : std_logic_vector(1 downto 0);

begin


  U_controller: entity work.controller
  -- generic map( 
  --     n => 32
  -- )
    port map (
      clk => clk, 
      rst => notbutton(0),
      OPSel => IRToCONTROL,
      PCWriteCond=> PCWriteCond,
      PCWrite=> PCWrite,
      IorD=> IorD,
      MemRead=> MemRead,
      MemWrite=> MemWrite,
      MemToReg=> MemToReg,
      IRWrite=> IRWrite,
      JumpAndLink=> JumpAndLink,
      IsSigned=> IsSigned,
      PCSource=> PCSource,
      ALUOp=> ALUOp,
      ALUSrcB=> ALUSrcB,
      ALUSrcA=> ALUSrcA,
      RegWrite=> RegWrite,
      RegDst=> RegDst,
      IRIn => IRLowToCONTROL
    );

    U_datapath: entity work.datapath
    -- generic map( 
    --     n => 32
    -- )
      port map (
        clk => clk,
        rst => notbutton(0),
        PCWriteCond => PCWriteCond,
        PCWrite => PCWrite,
        IorD => IorD,
        MemRead => MemRead,
        MemWrite => MemWrite,
        MemToReg => MemToReg,
        IRWrite => IRWrite,
        JumpAndLink => JumpAndLink,
        IsSigned => IsSigned,
        PCSource => PCSource,
        ALUOp => ALUOp,
        ALUSrcB => ALUSrcB,
        ALUSrcA => ALUSrcA,
        RegWrite => RegWrite,
        RegDst => RegDst, 
        Button1 => notbutton(1),
        switches => switch,
        LEDs =>  LEDsOUT,
        IRToCONTROL => IRToCONTROL,
        IRLowToCONTROL => IRLowToCONTROL
      );

    U_LED5 : decoder7seg port map (
        input  => LEDsOUT(23 downto 20),
        output => led5);

    U_LED4 : decoder7seg port map (
        input  => LEDsOUT(19 downto 16),
        output => led4);

    U_LED3 : decoder7seg port map (
        input  => LEDsOUT(15 downto 12),
        output => led3);

    U_LED2 : decoder7seg port map (
        input  => LEDsOUT(11 downto 8),
        output => led2);
    
    U_LED1 : decoder7seg port map (
        input  => LEDsOUT(7 downto 4),
        output => led1);

    U_LED0 : decoder7seg port map (
        input  => LEDsOUT(3 downto 0),
        output => led0);

    led5_dp <= '1';
    led4_dp <= '1';
    led3_dp <= '1';
    led2_dp <= '1';
    led1_dp <= '1';
    led0_dp <= '1';


    process(button)
    begin
    notbutton <= not button;
    end process;

end BHV;
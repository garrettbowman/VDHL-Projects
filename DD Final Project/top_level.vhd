library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
      clk : in std_logic;
      switch : in std_logic_vector(9 downto 0);
      button : in std_logic_vector(1 downto 0);
      --rst              : in  std_logic;
      LEDs: out std_logic_vector(31 downto 0)
      -- Inport0en       : in  std_logic;
      -- Inport1en       : in  std_logic;

	);
end top_level;

architecture BHV of top_level is


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

begin
  U_controller: entity work.controller
  -- generic map( 
  --     n => 32
  -- )
    port map (
      clk => clk, 
      rst => button(0),
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
        rst => button(0),
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
        Button1 => button(1),
        switches => switch,
        LEDs =>  LEDs,
        IRToCONTROL => IRToCONTROL,
        IRLowToCONTROL => IRLowToCONTROL
      );





end BHV;
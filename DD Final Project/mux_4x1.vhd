library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mux_4x1 is
    generic (
        width : positive := 32);
  port(
    in1    : in  std_logic_vector(width-1 downto 0);
    --in2    : in  std_logic_vector(width-1 downto 0);
    in3    : in  std_logic_vector(width-1 downto 0);
    in4    : in  std_logic_vector(width-1 downto 0);
    sel    : in  std_logic_vector(1 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end mux_4x1;



architecture BHV of mux_4x1 is
begin

  -- *********************************************************************
  -- Synthesis guideline for combinational logic: All inputs to the entity
  -- must be included in the sensitivity list.
  -- *********************************************************************
  --
  -- DON'T FORGET "SEL". Leaving an input out of the sensitivity list is a
  -- very common source of bugs. To see what happens, remove "sel" and run the
  -- provided testbench.

  process(in1, in3, in4, sel)
  begin
    -- if statement is pretty straightforward.     
    if (sel = "00") then
        output <= in1;
    elsif (sel = "01") then
        output <= conv_std_logic_vector(4, output'length); 
    elsif (sel = "10") then
        output <= in3;  
    else
        output <= in4;
    end if;
    end process;
end BHV;

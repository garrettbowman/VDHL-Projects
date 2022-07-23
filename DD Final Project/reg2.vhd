-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

entity reg2 is
  generic (
    n : positive := 8);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    input  : in  std_logic_vector(n-1 downto 0);
    output : out std_logic_vector(n-1 downto 0));
end reg2;

architecture ASYNC_RST of reg2 is
begin  -- ASYNC_RST

  -- SYNTHESIS GUIDELINE 1 FOR SEQUENTIAL LOGIC: The sensitivity list should
  -- only have clock and reset (if there is a reset).
  --
  -- It will likely not hurt if you include other signals, but don't do it.
  -- Some synthesis tools are picky.
  
  process(clk,rst)
  begin

    -- SYNTHESIS GUIDELINE 2 FOR SEQUENTIAL LOGIC: All sequential logic with
    -- async reset should be described using the following basic structure:
    --
    -- if reset
    --   handle reset appropriately
    -- elsif rising clock edge
    --   specify all non-reset functionality
    -- end if
    --
    -- Do not try to come up with another way of specifying equivalent
    -- behavior. Synthesis tools often require this template. 
    
    if (rst = '1') then
      -- assign a default output value on reset
      -- The others statement is a convenient way of assigning all bits a
      -- particular value.
      output <= (others => '0');      
    elsif (clk'event and clk='1') then

      -- IMPORTANT: Any time a signal/output is assigned on a rising clock
      -- edge, the synthesis tool will allocate a register. Therefore, output
      -- is synthesized into a register. 
      
      output <= input;      
    end if;    
  end process;

end ASYNC_RST;
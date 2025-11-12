library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity zero_extend is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
        switches: in std_logic_vector(9 downto 0);
		extendOut : out std_logic_vector(31 downto 0)
	);
end zero_extend;

architecture BHV of zero_extend is

begin
	process(switches)
	begin
    	extendOut <= std_logic_vector("00000000000000000000000" & switches(8 downto 0));
	end process;
end BHV;
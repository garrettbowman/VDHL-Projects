library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity concat is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
        pcinput : in std_logic_vector(3 downto 0);
        input : in std_logic_vector(27 downto 0);
		catOut : out std_logic_vector(31 downto 0)
	);
end concat;

architecture BHV of concat is

begin

    -- catOut <= (others => '1');
	catOut <= std_logic_vector(unsigned(pcinput) & unsigned(input));

end BHV;
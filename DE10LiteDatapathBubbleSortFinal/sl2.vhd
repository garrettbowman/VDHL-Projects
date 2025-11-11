library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity sl2 is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
        input : in std_logic_vector(31 downto 0);
		SLOut : out std_logic_vector(31 downto 0)
	);
end sl2;

architecture BHV of sl2 is

begin

    SLOut <= std_logic_vector(input(31) & input(28 downto 0) & "00");

end BHV;
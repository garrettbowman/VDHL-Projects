library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity sl2_2 is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
        input : in std_logic_vector(25 downto 0);
		SLOut : out std_logic_vector(27 downto 0)
	);
end sl2_2;

architecture BHV of sl2_2 is

begin

    SLOut <= std_logic_vector(input & "00");

end BHV;
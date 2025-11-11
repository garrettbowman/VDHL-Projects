library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity sign_extend is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
        input : in std_logic_vector(15 downto 0);
		sign : in std_logic;
		SEOut : out std_logic_vector(31 downto 0)
	);
end sign_extend;

architecture BHV of sign_extend is

begin
	process(sign, input)
	begin
		if (sign = '1') then
			SEOut <= input(15) & x"0000" & input(14 downto 0);
		else
			SEOut <= x"0000" & input;
		end if;
	end process;
end BHV;
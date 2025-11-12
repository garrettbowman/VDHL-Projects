library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity PC is
	-- generic (
	-- 	WIDTH : positive := 32
	-- );
	port (
		PCWriteIn : in std_logic;
        MuxIn : in std_logic_vector(31 downto 0);
		PCOut : out std_logic_vector(31 downto 0)
	);
end PC;

architecture BHV of PC is

begin
	
	process(PCWriteIn) 
	begin	
		if( PCWriteIn = '1') then
    		PCOut <= MuxIn;
		end if;
	end process;
end BHV;
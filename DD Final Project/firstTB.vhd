library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library altera_mf;
use altera_mf.altera_mf_components.all;


entity firstTB is
end firstTB;


architecture TB of firstTB is

    constant WIDTH   : positive := 32;


    component mainalu is
        generic( WIDTH : positive := 32);
        port (
            input1 : in std_logic_vector(WIDTH-1 downto 0);
            input2 : in std_logic_vector(WIDTH-1 downto 0);
            sel : in std_logic_vector(5 downto 0);
            shift : in std_logic_vector(4 downto 0);
            result : out std_logic_vector(WIDTH-1 downto 0);
            resultHi : out std_logic_vector(WIDTH-1 downto 0);
            branchTaken : out std_logic
        );
    end component;


    signal clkEn     : std_logic := '1';
    signal clk      : std_logic := '0';

    --inputs
    signal input1 : std_logic_vector(WIDTH-1 downto 0);
    signal input2 :  std_logic_vector(WIDTH-1 downto 0);
    signal sel :  std_logic_vector(5 downto 0);
    signal shift : std_logic_vector(4 downto 0);

    --outputs
    signal result :  std_logic_vector(WIDTH-1 downto 0);
    signal resultHi :  std_logic_vector(WIDTH-1 downto 0);
    signal branchTaken :  std_logic;

begin -- TB


    U_mainALU : mainalu 
        generic map(
            WIDTH => WIDTH
        )
        port map(
            input1 => input1,
            input2 => input2,
            sel => sel,
            shift => shift,
            result => result,
            resultHi => resultHi,
            branchTaken => branchTaken
        );

    clkEn <= '1';
    clk         <= not clk and clkEn after 10 ns;


    process
    begin

        input1 <= (others => '0');
        input2 <= (others => '0');
        sel <= (others => '0');
        shift <= (others => '0');
        
        --addition of 10 + 15

        -- input1 <= x"0000000A";
        -- input2 <= x"0000000F";
        input1 <= conv_std_logic_vector(10, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        sel <= "000000";


        wait for 20 ns;

        --subtraction of 25 - 10
        sel <= "000010";
        input1 <= conv_std_logic_vector(25, input1'length);
        input2 <= conv_std_logic_vector(10, input2'length);


        wait for 20 ns;
        -- mult (signed) of 10 * -4. Make sure to show both the Result and Result Hi outputs shown in the datapath.
        sel <= "000100";
        input1 <= conv_std_logic_vector(10, input1'length);
        input2 <= conv_std_logic_vector(-4, input2'length);


        wait for 20 ns;

        -- mult (unsigned) of 65536 * 131072. Make sure to show both the Result and Result Hi outputs shown in the datapath.
        sel <= "000101";
        input1 <= conv_std_logic_vector(65536, input1'length);
        input2 <= conv_std_logic_vector(131072, input2'length);


        wait for 20 ns;

        -- and of 0x0000FFFF and 0xFFFF1234
        sel <= "000110";
        input1 <= x"0000FFFF";
        input2 <= x"FFFF1234";

        wait for 20 ns;
        -- shift right logical of 0x0000000F by 4
        sel <= "001100";
        shift <= conv_std_logic_vector(4, shift'length);
        input1 <= x"0000000F";

        wait for 20 ns;
        -- shift right arithmetic of 0xF0000008 by 1
        sel <= "001110";
        shift <= conv_std_logic_vector(1, shift'length);
        input1 <= x"F0000008";

        wait for 20 ns;

        -- shift right arithmetic of 0x00000008 by 1
        sel <= "001110";
        input1 <= x"00000008";

        wait for 20 ns;
        -- set on less than using 10 and 15
        sel <= "010010";
        input1 <= conv_std_logic_vector(10, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);

        wait for 20 ns;

        -- set on less than using 15 and 10
        sel <= "010010";
        input1 <= conv_std_logic_vector(15, input1'length);
        input2 <= conv_std_logic_vector(10, input2'length);

        wait for 20 ns;

        -- Branch Taken output = ‘0’ for for 5 <= 0
        sel <= "011001";
        input1 <= conv_std_logic_vector(5, input1'length);
        wait for 20 ns;

        -- Branch Taken output = ‘1’ for for 5 > 0
        sel <= "011010";
        input1 <= conv_std_logic_vector(5, input1'length);

        wait for 20 ns;



        clkEn <= '0';
        report "Simulation Finished" severity note;
        wait;

    end process;


end TB;
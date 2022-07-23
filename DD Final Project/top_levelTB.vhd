library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library altera_mf;
use altera_mf.altera_mf_components.all;


entity top_levelTB is
end top_levelTB;


architecture TB of top_levelTB is

    constant WIDTH   : positive := 32;


    component top_level is
        port (
            clk : in std_logic;
            switch : in std_logic_vector(9 downto 0);
            button : in std_logic_vector(1 downto 0);
            --rst              : in  std_logic;
            LEDs: out std_logic_vector(31 downto 0)
        );
    end component;


    signal clkEn     : std_logic := '1';
    signal clk      : std_logic := '0';

    --inputs
    signal switch : std_logic_vector(9 downto 0);
    signal button :  std_logic_vector(1 downto 0);
    --signal rst :  std_logic;

    --outputs
    signal LEDs :  std_logic_vector(WIDTH-1 downto 0);


begin -- TB


    U_toplvl : top_level 
            -- generic map(
            --     WIDTH => WIDTH
            -- )
        port map(
            clk => clk,
            switch => switch,
            button => button,
            --rst  => rst,
            LEDs => LEDs
        );

    clkEn <= '1';
    clk         <= not clk and clkEn after 10 ns;


    process
    begin


        switch <= "0111111111";
        button <= "11";
        --rst <= '1';
        wait for 100 ns;
        
        --test 1


        switch <= "0111111111";
        button <= "10";
        --rst <= '0';

        wait for 500 ns;

        switch <= "0111111111";
        button <= "10";
        --rst <= '0';

        wait for 500 ns;

        
        switch <= "0111111111";
        button <= "10";
        --rst <= '0';

        wait for 500 ns;



        switch <= "0111111111";
        button <= "10";
        --rst <= '0';

        wait for 8000 ns;

        clkEn <= '0';
        report "Simulation Finished" severity note;
        wait;

    end process;


end TB;
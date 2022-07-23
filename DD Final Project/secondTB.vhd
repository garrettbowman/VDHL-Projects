library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library altera_mf;
use altera_mf.altera_mf_components.all;


entity secondTB is
end secondTB;


architecture TB of secondTB is


    component memory is
        port (
            clk : in std_logic;
            rst : in std_logic;
            addr : in std_logic_vector (31 downto 0);
            MemWrite : in std_logic;
            MemRead : in std_logic;
            Inport0en : in std_logic;
            Inport1en : in std_logic;
            switch : in std_logic_vector(31 downto 0);
            WrData : in std_logic_vector(31 downto 0);       
            RdData : out std_logic_vector(31 downto 0);
            outPort : out std_logic_vector(31 downto 0)
        );
    end component;


    signal clkEn            : std_logic := '1';
    signal clk              : std_logic := '0';
    signal rst :  std_logic := '0';


    --inputs
    signal addr :  std_logic_vector (31 downto 0);
    signal MemWrite : std_logic;
    signal MemRead : std_logic;
    signal Inport0en :  std_logic;
    signal Inport1en :  std_logic;
    signal switch :  std_logic_vector(31 downto 0);
    signal WrData :  std_logic_vector(31 downto 0);       

    --outputs
    signal RdData :  std_logic_vector(31 downto 0);
    signal outPort : std_logic_vector(31 downto 0);


begin


    u_memory : memory port map(
        clk => clk,
        rst => rst,
        addr => addr,
        MemWrite => MemWrite,
        MemRead => MemRead,
        Inport0en => Inport0en,
        Inport1en => Inport1en,
        switch => switch,
        WrData => WrData,       
        RdData => RdData,
        outPort => outPort
    );

    clkEn <= '1';
    clk         <= not clk and clkEn after 10 ns;

    process
    begin

        addr <= (others => '0');
        MemWrite <= '0';
        MemRead <= '0';
        Inport0en <= '0';
        Inport1en <= '0';
        switch <= (others => '0');
        WrData <= (others => '0'); 
        rst <= '1';



    -- Write 0x0A0A0A0A to byte address 0x00000000
        MemWrite <= '1';
        MemRead <= '0';
        addr <= x"00000000";
        WrData <= x"0A0A0A0A"; 
        wait for 100 ns;       

    --  Write 0xF0F0F0F0 to byte address 0x00000004
        MemWrite <= '1';
        MemRead <= '0';
        addr <= x"00000004";
        WrData <= x"F0F0F0F0"; 
        wait for 100 ns;      

    --  Read from byte address 0x00000000 (should show 0x0A0A0A0A on read data output)
        MemWrite <= '0';
        MemRead <= '1';
        addr <= x"00000000";

        wait for 100 ns;    

    --  Read from byte address 0x00000001 (should show 0x0A0A0A0A on read data output)
        MemWrite <= '0';
        MemRead <= '1';
        addr <= x"00000001";

        wait for 100 ns;    

    --  Read from byte address 0x00000004 (should show 0xF0F0F0F0 on read data output)
        MemWrite <= '0';
        MemRead <= '1';
        addr <= x"00000004";

        wait for 100 ns;    

    --  Read from byte address 0x00000005 (should show 0xF0F0F0F0 on read data output)
        MemWrite <= '0';
        MemRead <= '1';
        addr <= x"00000005";

        wait for 100 ns;    

    --  Write 0x00001111 to the outport (should see value appear on outport)
        MemWrite <= '1';
        MemRead <= '0';
        WrData <= x"00001111"; 
        addr <= x"0000FFFC";

        wait for 100 ns;    

    --  Load 0x00010000 into inport 0
        MemWrite <= '0';
        switch <=  x"00010000";
        Inport0en <= '1';

        wait for 100 ns;
        Inport0en <= '0';

    --  Load 0x00000001 into inport 1
        switch <=  x"00000001";
        Inport1en <= '1';

        wait for 100 ns;
        Inport1en <= '0';

    --  Read from inport 0 (should show 0x00010000 on read data output)
        MemWrite <= '0';
        MemRead <= '1';
        addr <= x"0000FFF8";

        wait for 100 ns;

    --  Read from inport 1 (should show 0x00000001 on read data output)
        MemWrite <= '0';
        MemRead <= '1';
        addr <= x"0000FFFC";
        wait for 100 ns;

        clkEn <= '0';
        report "Simulation Finished" severity note;
        wait;

    end process;


end TB;
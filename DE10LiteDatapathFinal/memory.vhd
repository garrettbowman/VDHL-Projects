library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

--register mux ram
entity memory is
    port (
        clk : in std_logic;
        rst : in std_logic;
        addr : in std_logic_vector (31 downto 0);
        MemWrite : in std_logic;
        MemRead : in std_logic;
        Inporten : in std_logic;
        -- Inport1en : in std_logic;
        s0or1 : in std_logic;
        --Buttons : in std_logic_vector(1 downto 0);
        switch : in std_logic_vector(31 downto 0);
        WrData : in std_logic_vector(31 downto 0);       
        RdData : out std_logic_vector(31 downto 0);
        outPort : out std_logic_vector(31 downto 0)

	);
end memory;

architecture BHV of memory is


    component ram1 IS
        PORT
        (
            address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            wren		: IN STD_LOGIC ;
            q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;

    component mux3x1 IS
        generic( WIDTH : positive := 32);
        PORT
        (
            in1    : in  std_logic_vector(width-1 downto 0);
            in2    : in  std_logic_vector(width-1 downto 0);
            sel    : in  std_logic_vector(1 downto 0);
            output : out std_logic_vector(width-1 downto 0)
        );
    end component;


    signal OutportWrEn : std_logic;
    signal wren : std_logic;
    signal sel : std_logic_vector(1 downto 0);
    signal selout : std_logic_vector(1 downto 0);
    signal in1mux, in2mux, in3mux : std_logic_vector(31 downto 0);
    --signal inport1, inport2 : std_logic_vector(31 downto 0);
    --signal WrData : std_logic_vector (31 downto 0);
    signal Inport0en :  std_logic;
    signal Inport1en :  std_logic;


begin

    U_RAM: entity work.ram1 
	port map (
		address		=> addr(9 downto 2),
		clock		=> clk,
		data		=> WrData,
		wren		=> wren,
		q		=> in3mux 
	);

    U_MUX3x1: entity work.mux_3x1 
	port map (
        in1    => in1mux,
        in2    => in2mux,
        in3    => in3mux,
        sel    => selout,
        output => RdData
	);

    U_outport: entity work.reg1
    generic map( 
            n => 32
        )
	port map (
        I => WrData,
        clock => clk,
        load => OutportWrEn,
        clear => rst,
        Q => outPort
	);

    U_Inport0: entity work.reg1
    generic map( 
        n => 32
    )
	port map (
        I => switch,
        clock => clk,
        load => Inport0en,
        clear => '0',
        Q => in1mux
	);

    U_Inport1: entity work.reg1
    generic map( 
        n => 32
    )
	port map (
        I => switch,
        clock => clk,
        load => Inport1en,
        clear => '0',
        Q => in2mux
	);

    U_delay: entity work.reg1
    generic map( 
        n => 2
    )
	port map (
        I => sel,
        clock => clk,
        load => '1',
        clear => rst,
        Q => selout
	);


    process(addr, MemWrite, MemRead)
    begin 
        sel <= "10";
        wren <= '0';
        OutportWrEn <= '0';
        if (MemWrite = '1') then
            if (addr = x"0000FFFC") then
                OutportWrEn <= '1';
            elsif(addr < x"00002000") then
                wren <= '1';
            end if;
        elsif (MemRead = '1') then
            if (addr < x"00002000") then
                sel <= "10";
                
            elsif (addr = x"0000FFFC") then
                sel <= "01";
            else
                sel <= "00";
            end if;
        end if;
    end process;

    process(Inporten, s0or1)
    begin 
        Inport0en <= '0';
        Inport1en <= '0';
        if(s0or1 = '1') then
            if (Inporten = '1') then
                Inport0en <= '0';
                Inport1en <= '1';
            else
                Inport0en <= '0';
                Inport1en <= '0';
            end if;

        else
            if (Inporten = '1') then
                Inport0en <= '1';
                Inport1en <= '0';
            else
                Inport0en <= '0';
                Inport1en <= '0';
            end if;

            
        end if;
        

    end process;



end BHV;
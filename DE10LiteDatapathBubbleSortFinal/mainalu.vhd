library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity mainalu is
	generic (
		WIDTH : positive := 32
	);
	port (
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		sel : in std_logic_vector(5 downto 0);
		shift : in std_logic_vector(4 downto 0);
		result : out std_logic_vector(WIDTH-1 downto 0);
		resultHi : out std_logic_vector(WIDTH-1 downto 0);
		branchTaken : out std_logic
	);
end mainalu;

architecture BHV of mainalu is


begin
	--overflow <= '0';
	--output <= (others => '0');
	

	process(input1, input2, sel)

		constant zero1 : signed (31 downto 0) := "00000000000000000000000000000000";
		variable temp_add : unsigned(2*WIDTH-1 downto 0);
		variable temp_mult_unsigned : unsigned(2*WIDTH-1 downto 0);
		variable temp_mult_signed : signed(2*WIDTH-1 downto 0);
		variable zeros : std_logic_vector(WIDTH-1 downto 0);
		variable input1signed : signed(WIDTH-1 downto 0);
		variable input2signed : signed(WIDTH-1 downto 0);
		variable H : natural;

	begin

		result <= (others => '0');
		resultHi <= (others => '0');
		branchTaken <= '0';
		H := to_integer(unsigned(shift(4 downto 0)));

		case sel is

			when "000000" => -- add - unsigned
			temp_add := resize(unsigned(input1), 2*WIDTH) + resize(unsigned(input2), 2*WIDTH);
			result <= std_logic_vector(temp_add(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_add(2*WIDTH-1 downto WIDTH));

			when "000001" => -- add immediate unsigned
			temp_add := resize(unsigned(input1), 2*WIDTH) + resize(unsigned(input2), 2*WIDTH);
			result <= std_logic_vector(temp_add(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_add(2*WIDTH-1 downto WIDTH));

			when "000010" => --sub unsigned
			temp_add := resize(unsigned(input1), 2*WIDTH) - resize(unsigned(input2), 2*WIDTH);
			result <= std_logic_vector(temp_add(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_add(2*WIDTH-1 downto WIDTH));


			when "000011" => --sub immediate unsigned
			temp_add := resize(unsigned(input1), 2*WIDTH) - resize(unsigned(input2), 2*WIDTH);
			result <= std_logic_vector(temp_add(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_add(2*WIDTH-1 downto WIDTH));


			when "000100" => --mult 
			temp_mult_signed := resize(signed(input1) * signed(input2), 2*WIDTH);
			result <= std_logic_vector(temp_mult_signed(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_mult_signed(2*WIDTH-1 downto WIDTH));

			when "000101" => --mult unsigned
			temp_mult_unsigned := resize(unsigned(input1) * unsigned(input2), 2*WIDTH);
			result <= std_logic_vector(temp_mult_unsigned(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_mult_unsigned(2*WIDTH-1 downto WIDTH));


			when "000110" => --and
			result <= input1 and input2;
			resultHi <= (others => '0');

			when "000111" => --andi
			result <= input1 and input2;
			resultHi <= (others => '0');

			when "001000" => --or
			result <= input1 or input2;
			resultHi <= (others => '0');

			when "001001" => --ori
			result <= input1 or input2;
			resultHi <= (others => '0');

			when "001010" => --xor
			result <= input1 xor input2;
			resultHi <= (others => '0');

			when "001011" => --xori
			result <= input1 xor input2;
			resultHi <= (others => '0');

			when "001100" => --srl -shift right logical
			result <= std_logic_vector(shift_right(unsigned(input2), H));
			resultHi <= (others => '0');

			when "001101" => --sll -shift left logical 
			result <= std_logic_vector(shift_left(unsigned(input2), H));
			resultHi <= (others => '0');

			when "001110" => --sra -shift right arithmetic
			result <= std_logic_vector(shift_right(signed(input2), H));
			resultHi <= (others => '0');

			when "001111" => --slt -set on less than signed
			input1signed := signed(input1);
			input2signed := signed(input2);
			if(input1signed < input2signed) then
				result <= x"00000001";
			else
				result <= (others => '0');
			end if;


			when "010000" => --slti -set on less than immediate signed
			input1signed := signed(input1);
			input2signed := signed(input2);
			if(input1signed < input2signed) then
				result <= x"00000001";
			else
				result <= (others => '0');
			end if;

			when "010001" => --sltiu- set on less than immediate unsigned
			if(input1 < input2) then
				result <= x"00000001";
			else
				result <= (others => '0');
			end if;

			when "010010" => --sltu - set on less than unsigned
			if(input1 < input2) then
				result <= x"00000001";
			else
				result <= (others => '0');
			end if;

			when "010011" => --mfhi -move from Hi
				result <= input1;

			
			when "010100" => --mflo -move from LO
				result <= input1;

			when "010101" => --load word
			temp_add := resize(unsigned(input1(25 downto 21)), 2*WIDTH) + resize(unsigned(input1(15 downto 0)), 2*WIDTH);
			result <= std_logic_vector(temp_add(WIDTH-1 downto 0));
			resultHi <= std_logic_vector(temp_add(2*WIDTH-1 downto WIDTH));


			when "010110" => --store word
				result <= input2;


			when "010111" => --branch on equal
			if(input1 = input2) then
				branchTaken <=  '1';
			else
				branchTaken <= '0';
			end if;

			
			when "011000" => --branch not equal
			if(input1 = input2) then
				branchTaken <=  '0';
			else
				branchTaken <= '1';
			end if;

			
			when "011001" => --Branch on Less Than or Equal to Zero
			input1signed := signed(input1);
			input2signed := signed(input2);
			if(input1signed <= input2signed) then
				branchTaken <=  '1';
			else
				branchTaken <= '0';
			end if;


			
			when "011010" => --Branch on Greater Than Zero
			input1signed := signed(input1);
			input2signed := signed(input2);
			if(input1signed > input2signed) then
				branchTaken <=  '1';
			else
				branchTaken <= '0';
			end if;

			
			when "011011" => --Branch on Less Than Zero
			input1signed := signed(input1);
			if(input1signed < 0) then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;

			
			when "011100" => --Branch on Greater Than or Equal to Zero
			input1signed := signed(input1);
			if(input1signed > 0) then
				branchTaken <= '1';
			elsif (input1signed = zero1) then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
			
			--when "011101" => --jump to address


			
			--when "011110" => --jump and link

			
			when "011111" => --jump register
				result <= input1;


			when others =>
				result <= (others => '0');
				resultHi <= (others => '0');
				branchTaken <= '0';
				
		end case;
		
	end process;


end BHV;
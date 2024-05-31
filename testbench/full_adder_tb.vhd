LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY full_adder_tb IS
END full_adder_tb;

ARCHITECTURE beh OF full_adder_tb IS

	CONSTANT clk_period : TIME := 100 ns;

	COMPONENT full_adder
		PORT (
			a : IN STD_LOGIC;
			b : IN STD_LOGIC;
			cin : IN STD_LOGIC;
			s : OUT STD_LOGIC;
			cout : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL a_ext : STD_LOGIC := '0';
	SIGNAL b_ext : STD_LOGIC := '0';
	SIGNAL c_in_ext : STD_LOGIC := '0';
	SIGNAL s_ext : STD_LOGIC;
	SIGNAL c_out_ext : STD_LOGIC;
	SIGNAL testing : BOOLEAN := true;

BEGIN
	clk <= NOT clk AFTER clk_period/2 WHEN testing ELSE
		'0';

	dut : full_adder
	PORT MAP(
		a => a_ext,
		b => b_ext,
		cin => c_in_ext,
		s => s_ext,
		cout => c_out_ext
	);

	stimulus : PROCESS
	BEGIN
		a_ext <= '0';
		b_ext <= '0';
		c_in_ext <= '0';
		WAIT FOR 200 ns;
		a_ext <= '1';
		b_ext <= '0';
		c_in_ext <= '0';
		WAIT UNTIL rising_edge(clk);
		a_ext <= '0';
		b_ext <= '1';
		c_in_ext <= '0';
		WAIT UNTIL rising_edge(clk);
		a_ext <= '0';
		b_ext <= '0';
		c_in_ext <= '0';
		WAIT FOR 1008 ns;
		a_ext <= '1';
		b_ext <= '1';
		c_in_ext <= '1';
		WAIT FOR 500 ns;
		testing <= false;
	END PROCESS;
END beh;
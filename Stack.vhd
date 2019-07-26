library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 
-------------------------------------------------------------------------------

Entity Stack is
	port(
		clk: in std_logic;
		rst: in std_logic;
		push: in std_logic;
		pop: in std_logic;
		data: INOUT std_logic_vector(7 DOWNTO 0);
		Full: out std_logic;
		Empty: out std_logic
	);
End Stack;
----------------------------------------------------------------------------

Architecture behave of Stack is
	Type Stack_type is (S0, S1);
	Signal State : Stack_type := S0;
	Type MemType is Array (0 to 255) of std_logic_vector(7 downto 0);
	Signal Memory : MemType;
	Signal SP : std_logic_vector(7 downto 0);
	
	Begin
		Process (clk)
			Begin
				if clk'event and clk='1' Then
					if rst = '1' Then
						State <= S0;
						SP <= "00000000";
					elsif push='1' Then
						Case State is
							When S0 =>
								SP <= SP - 1;
								State <= S1;
							When S1 => 
								data <= (others => 'Z');
								Memory (Conv_integer (SP)) <= data;
								State <= S0;
								if SP="11111111" Then
									Full <= '1';
								End if;
								Empty <= '0';
						End Case;
					elsif pop='1' Then
						Case State is
							When S0 =>
								data <= Memory(Conv_integer (SP));
								State <= S1;
							When S1 =>
								SP <= SP + 1;
								State <= S0;
								if SP="00000000" Then
									Empty <= '1';
								End if;
								Full <= '0';
						End Case;
					End if;
				End if;
		End Process;
	End behave;

----------------------------------------------------------------------------


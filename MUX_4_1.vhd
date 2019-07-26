library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
---------------------------------------------
ENTITY MUX_4_1 is
PORT(
	I0,I1,I2,I3: in std_logic_vector(7 downto 0);
	sel: in std_logic_vector(1 downto 0);
	Z: out std_logic_vector(7 downto 0)
);
End ENTITY MUX_4_1;
---------------------------------------------
Architecture behv of MUX_4_1 is
Begin
	PROCESS(I0,I1,I2,I3,sel)
	Begin
		case sel is
			when "00" =>
				Z <= I0;
			when "01" =>
				Z <= I1;
			when "10" =>
				Z <= I2;
			when "11" =>
				Z <= I3;
			when others =>
				Z <= "ZZZZZZZZ";
		End Case;
	End Process;
End Architecture;

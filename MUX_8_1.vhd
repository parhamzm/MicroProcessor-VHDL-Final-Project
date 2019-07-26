Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
--------------------------------------------------------------------------------------------------
ENTITY MUX_8_1 is
port(   I0,I1,I2,I3,I4,I5,I6,I7: in std_logic_vector(7 downto 0);
	sel: in std_logic_vector(2 downto 0);
	Z: out std_logic_vector(7 downto 0));
end ENTITY MUX_8_1;
--------------------------------------------------------------------------------------------------
ARCHITECTURE behv of MUX_8_1 is
BEGIN
	Process(I0,I1,I2,I3,I4,I5,I6,I7,sel)
	BEGIN
		case sel is
			when "000" =>
				Z <= I0;
			when "001" =>
				Z <= I1;
			when "010" =>
				Z <= I2;
			when "011" =>
				Z <= I3;
			when "100" =>
				Z <= I4;
			when "101" =>
				Z <= I5;
			when "110" =>
				Z <= I6;
			when "111" =>
				Z <= I7;
			when others =>
				null;
		End case;
	End Process;
End ARCHITECTURE;
	

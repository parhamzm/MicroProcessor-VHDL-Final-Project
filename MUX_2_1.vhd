library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
-------------------------------------------------------------------------------------------------------
Entity MUX_2_1 is
Port(
        I0,I1: in std_logic_vector(7 downto 0);
	sel: in std_logic;
	Z: out std_logic_vector(7 downto 0)
);
End ENTITY;
---------------------------------------------------------------------------------------------------------
ARCHITECTURE behv of MUX_2_1 is
Begin
	PROCESS(I0,I1,sel)
	Begin
		case sel is
			when '0' =>
				Z <= I0;
			when '1' =>
				Z <= I1;
			when others =>
				Z <= (others =>'Z');
		End CASE;
	End Process;
End ARCHITECTURE;
------------------------------------------------------------------------------------------------------------
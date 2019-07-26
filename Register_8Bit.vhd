LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all; 
---------------------------------------------------------------------------------------------------
ENTITY Register_8Bit is 
port (
	clk: in std_logic;
	Din: in std_logic_vector(7 downto 0);
	Dout: out std_logic_vector(7 downto 0);
	ld, rst: in std_logic
);
End ENTITY Register_8Bit;
-----------------------------------------------------------------------------------------------------
ARCHITECTURE behv of Register_8Bit is
Signal temp : std_logic_vector(7 downto 0) := "00000000";
Begin
	Process(clk,rst, ld)
	Begin 
		IF (rst = '1' ) then 	
			temp <= "00000000";
		ELSIF (clk='1' and clk'event) then
			if(ld = '1') then
				temp <= Din;
			end if;
		End IF;
	End Process;
	Dout <= temp;
End ARCHITECTURE;
			
---------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;  
-------------------------------------------------------------------------------------------------------------
Entity Register_CU is 
GENERIC (
	bits: integer 
);
PORT(
	REGld:	in std_logic;
	REGinc:	in std_logic;
	REGclr:	in std_logic;
	REGin:	in std_logic_vector(bits-1 downto 0);
	REGout:	out std_logic_vector(bits-1 downto 0)
);
End Register_CU;
-----------------------------------------------------------------------------------------------------------
ARCHITECTURE behv of Register_CU is

signal tmp_reg: std_logic_vector(bits-1 downto 0);

Begin
	PROCESS(REGclr, REGinc, REGld, REGin)
	begin
		if (REGclr='1' and REGclr'event) then
			tmp_reg <= (others=>'0');
		elsif (REGld'event and REGld = '1') then
			tmp_reg <= REGin;
		elsif (REGinc'event and REGinc = '1') then
			tmp_reg <= tmp_reg + 1;
		end if;
	end PROCESS;
	REGout <= tmp_reg;
End behv;
--------------------------------------------------------------------------------------------------------------------
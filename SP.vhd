LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;  
---------------------------------------------
ENTITY SP is 
port(	
	REGld: in std_logic;
	REGinc:	in std_logic;
	REGdec:	in std_logic;
	REGclr:	in std_logic;
	REGin: in std_logic_vector(7 downto 0);
	REGout:	out std_logic_vector(7 downto 0)
);
END Entity SP;
---------------------------------------------
ARCHITECTURE behv of SP is

signal tmp_reg: std_logic_vector(7 downto 0);

Begin
	Process(REGld, REGclr, REGinc, REGdec, REGin)
	Begin
		if REGclr='1' then
			tmp_reg <= (others=>'0');
		elsif (REGld'event and REGld = '1') then
			tmp_reg <= REGin;
		elsif (REGinc'event and REGinc = '1') then
			tmp_reg <= tmp_reg + 1;
		elsif (REGdec'event and REGdec = '1') then
			tmp_reg <= tmp_reg - 1;
		end if;
	End PROCESS;
	REGout <= tmp_reg;
End behv;

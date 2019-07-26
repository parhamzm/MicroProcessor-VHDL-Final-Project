Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
----------------------------------------------------------------------------------------
entity ir is 
port(	IRclr: in std_logic;
	IRld:	in std_logic;
	IRin:	in std_logic_vector(15 downto 0);
	IRout:	out std_logic_vector(15 downto 0));
end ir;
----------------------------------------------------------------------------------
Architecture behv of ir is
signal temp: std_logic_vector(15 downto 0);
Begin 
	Process(IRld,IRin)
	begin 
		if(IRclr = '1') then
			temp <= "0000000000000000";
		elsif (IRld = '1' )then 
			temp <= IRin;
		end if;
	end process;
	IRout <= temp;
end behv;
-----------------------------------------------------------------------------------------
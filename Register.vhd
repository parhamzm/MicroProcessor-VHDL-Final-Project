Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
---------------------------------------------
entity Register_CU is 
generic (bits: integer );
port(	REGld:	in std_logic;
	REGinc:	in std_logic;
	REGclr:	in std_logic;
	REGin:	in std_logic_vector(bits-1 downto 0);
	REGout:	out std_logic_vector(bits-1 downto 0));
end Register_CU;
---------------------------------------------
architecture behv of reg is
signal tmp_reg: std_logic_vector(bits-1 downto 0);
begin
	process(REGclr, REGinc, REGld, REGin)
	begin
		if (REGclr='1' and REGclr'event) then
			tmp_reg <= (others=>'0');
		elsif (REGld'event and REGld = '1') then
			tmp_reg <= REGin;
		elsif (REGinc'event and REGinc = '1') then
			tmp_reg <= tmp_reg + 1;
		end if;
	end process;
	REGout <= tmp_reg;
end behv;
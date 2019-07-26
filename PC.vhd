Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;  
---------------------------------------------
entity pc is 
port(	PCld:	in std_logic;
	PCinc:	in std_logic;
	PCclr:	in std_logic;
	PCin:	in std_logic_vector(11 downto 0);
	PCout:	out std_logic_vector(11 downto 0));
end pc;
---------------------------------------------
architecture behv of pc is
signal tmp_pc: std_logic_vector(11 downto 0);
begin
	process(PCclr, PCinc, PCld, PCin)
	begin
		if PCclr='1' then
			tmp_pc <= (others=>'0');
		elsif (PCld'event and PCld = '1') then
			tmp_pc <= PCin;
		elsif (PCinc'event and PCinc = '1') then
			tmp_pc <= tmp_pc + 1;
		end if;
	end process;
	PCout <= tmp_pc;
end behv;
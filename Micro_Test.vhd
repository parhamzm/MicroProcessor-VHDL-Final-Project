library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
---------------------------------------------
entity Micro_Test is
end entity;
---------------------------------------------
architecture behv of Micro_Test is

signal clk: std_logic := '0';
signal rst: std_logic := '1';
Signal ram_rst : std_logic := '0';
signal input, output: std_logic_vector(7 downto 0);

begin
	Ui: entity work.MicroProcessor port map(rst, clk, input, output, ram_rst);
	clk <= not clk after 10 ns when now<=10000 ns else '0';
	rst <= '0' after 5 ns , '0' after 20 ns;
	--ram_rst <= '0' after 10 ns;
	input <= "00001100";
end architecture;

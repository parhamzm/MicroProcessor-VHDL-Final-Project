library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
---------------------------------------------
Entity MicroProcessor is
PORT (	rst: in std_logic;
	clk: in std_logic;
	input: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(7 downto 0);
	Ram_Reset : in std_logic
);
End Entity MicroProcessor;
---------------------------------------------
ARCHITECTURE behv of MicroProcessor is

signal out_mux_rin, 
	stack_out, 
	ram_out, 
	alu_out, 
	out_mux_stack, 
	out_mux_ram, 
	ra_out, 
	rb_out : std_logic_vector(7 downto 0);

signal sel_mux_ram : std_logic;
signal sel_mux_stack: std_logic_vector(1 downto 0);
signal sel_mux_ra, sel_mux_rb, alu_sel : std_logic_vector(2 downto 0);
signal sel_mux_rin: std_logic_vector(1 downto 0);

signal R0_out, 
	R1_out, 
	R2_out, 
	R3_out, 
	R4_out, 
	R5_out, 
	R6_out, 
	R7_out : std_logic_vector(7 downto 0);

signal ld0, ld1, ld2, ld3, ld4, ld5, ld6, ld7: std_logic;
signal addr_ram, addr_stack: std_logic_vector(7 downto 0);
signal wr_ram, wr_stack: std_logic;

signal addr_rom: std_logic_vector(11 downto 0);
signal rom_data: std_logic_vector(15 downto 0);
signal read_en: std_logic;

signal Z, C, S, V, F, E: std_logic;

--Signal Ram_Reset : std_logic;
Signal Stack_Reset : std_logic := '0';
Signal Stack_push : std_logic;
Signal Stack_pop : std_logic;
Signal Stack_full, Stack_empty : std_logic := '0';
Signal stack_data : std_logic_vector(7 downto 0);

BEGIN 
	ROM: Entity work.ROM GENERIC MAP(16,12) port map(read_en,addr_rom, rom_data);
	ALU_U:   Entity work.ALU PORT MAP(ra_out, rb_out, alu_sel, alu_out, Z, C, S, V);
	RAM:   Entity work.RAM GENERIC MAP(8,8) port map (wr_ram, clk, addr_ram, out_mux_ram, ram_out, Ram_Reset);
	--STACK: Entity work.RAM GENERIC MAP(8,8) port map (wr_stack, clk, addr_stack, out_mux_stack, stack_out, stack_reset);
	--Stack_main : Entity work.Stack PORT MAP (clk, rst, Stack_push, stack_pop, stack_data, stack_full, stack_empty);
	MUX_RAM:   Entity work.MUX_2_1 port map(ra_out, stack_out, sel_mux_ram, out_mux_ram);
	MUX_STACK: Entity work.MUX_4_1 port map(ra_out, ram_out, addr_rom(7 downto 0), "00000000", sel_mux_stack, out_mux_stack);
	MUX_RA: Entity work.MUX_8_1 port map(R0_out, 
						R1_out, 
						R2_out, 
						R3_out, 
						R4_out, 
						R5_out, 
						R6_out, 
						R7_out, sel_mux_ra, ra_out);
	MUX_RB: entity work.MUX_8_1 port map(R0_out, 
						R1_out, 
						R2_out, 
						R3_out, 
						R4_out, 
						R5_out, 
						R6_out, 
						R7_out, sel_mux_rb, rb_out);
	MUX_RIN: entity work.MUX_4_1 PORT MAP(alu_out, ram_out, stack_out, input, sel_mux_rin, out_mux_rin);
	REG0: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R0_out, ld0, rst); 
	REG1: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R1_out, ld1, rst);
	REG2: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R2_out, ld2, rst);
	REG3: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R3_out, ld3, rst);
	REG4: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R4_out, ld4, rst);
	REG5: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R5_out, ld5, rst);
	REG6: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R6_out, ld6, rst);
	REG7: entity work.Register_8Bit PORT MAP(clk, out_mux_rin, R7_out, ld7, rst);
	CU: entity work.ControlUnit PORT MAP (
				rst,
				clk,
				rom_data,
				R0_out,
				R1_out,
				R2_out,
				R3_out,
				R4_out,
				R5_out,
				R6_out,
				R7_out,
				Z, C, S, V, F, E,
				ld0,
				ld1,
				ld2,
				ld3,
				ld4,
				ld5,
				ld6,
				ld7,
				wr_ram,
				read_en,
				wr_stack,
				sel_mux_stack,
				sel_mux_ram,
				sel_mux_rin,
				alu_sel,
				sel_mux_ra,
				sel_mux_rb,
				addr_ram,
				addr_stack,
				addr_rom
	);
	
			output <= R0_out;
		
		

END Architecture;

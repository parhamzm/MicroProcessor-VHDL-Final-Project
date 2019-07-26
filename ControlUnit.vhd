Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;  
---------------------------------------------
ENTITY ControlUnit IS
PORT(	
	rst: in std_logic;
	clk: in std_logic;
	rom_data: in std_logic_vector(15 downto 0);
	R0_out,
	R1_out,
	R2_out,
	R3_out,
	R4_out,
	R5_out,
	R6_out,
	R7_out : in std_logic_vector (7 downto 0);
	Z, C, S, V, F, E: in std_logic;
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
	wr_stack: out std_logic;
	sel_mux_stack: out std_logic_vector(1 downto 0);
	sel_mux_ram : out std_logic;
	sel_mux_rin: out std_logic_vector(1 downto 0);
	sel_alu,
	sel_mux_ra,
	sel_mux_rb : out std_logic_vector(2 downto 0);
	addr_ram,
	addr_stack : out std_logic_vector(7 downto 0);
	addr_rom : out std_logic_vector(11 downto 0) 
);
End ENTITY ControlUnit;
---------------------------------------------
architecture behv of ControlUnit is

type state_type is( 	RESET,
			FETCH, 
			DEC, 
			ADD_op,
			AND_op,
			MOVE_op,
			NOT_op,
			INC_op,
			IN_input,
			OUT_output,
			DEC_op,
			LOAD,
			STORE,
			PUSH_a,
			PUSH_b,
			POP_a,
			POP_b,
			PUSH_R_a,
			PUSH_R_b,
			POP_R_a,
			POP_R_b,
			JR,
			NOP,
			CALL_a,
			CALL_b,
			JMP,
			RET_a,
			RET_b,
			HALT);
signal current_state: state_type := RESET;
signal next_state: state_type := RESET;

signal pc_ld, pc_inc, pc_clr: std_logic;
signal pc_in, pc_out: std_logic_vector(11 downto 0);
signal sp_ld, sp_inc, sp_clr, sp_dec: std_logic;
signal sp_in, sp_out: std_logic_vector(7 downto 0);
signal ir_ld: std_logic := '0';
signal ir_out: std_logic_vector(15 downto 0);

signal ra, rb, rd, Register_select, CD: std_logic_vector(2 downto 0);
signal CodeAdr8, DataAdr: std_logic_vector(7 downto 0);
signal CodeAdr12: std_logic_vector(11 downto 0);
signal opcode: std_logic_vector(1 downto 0);
signal format1, format2: std_logic_vector(2 downto 0);
signal format4: std_logic_vector(1 downto 0);

begin 
	addr_rom <= pc_out;
	addr_stack <= sp_out;
	addr_ram <= DataAdr;
	PC: entity WORK.Register_CU(behv) generic map(12) PORT MAP(pc_ld, pc_inc, pc_clr, pc_in, pc_out);
	SP: entity work.SP port map(sp_ld,sp_inc, sp_dec, sp_clr, sp_in, sp_out);
	IR: entity work.IR port map(rst,ir_ld, rom_data, ir_out);
	
	process(clk)
	begin
		
		if(clk'event and clk='1') then
			current_state <= next_state;
			
		end if;
	end process;

	process(current_state)

	begin
		case current_state is
			when RESET =>
				sp_clr <= '1';
				sp_inc <= '0';
				pc_clr <= '1';
				ir_ld <= '0';
				ld0 <= '0';
				ld1 <= '0';
				ld2 <= '0';
				ld3 <= '0';
				ld4 <= '0';
				ld5 <= '0';
				ld6 <= '0';
				ld7 <= '0';
				wr_stack <= '0';
				wr_ram <= '0';
				next_state <= FETCH;
				sel_mux_ra <= "000";
				sel_mux_rb <= "000";
			when FETCH =>
				sp_clr <= '0';
				pc_clr <= '0';
				pc_ld <= '0';
				ir_ld <= '1';  
				pc_inc <= '0'; -- reav
				sp_inc <= '0';
				next_state <= DEC;
				ld0 <= '0';
				ld1 <= '0';
				ld2 <= '0';
				ld3 <= '0';
				ld4 <= '0';
				ld5 <= '0';
				ld6 <= '0';
				ld7 <= '0';
				read_en <= '0';
				wr_stack <= '0';
				wr_ram <= '0';
			when DEC =>
				ir_ld <= '0'; 
				pc_inc <= '1';  -- djfdsjf
				read_en <= '1';
				--opcode <= rom_data(15 downto 14); 
				if (ir_out(15 downto 14) = "00") then --opcode
						--format1 <= rom_data(13 downto 11);
						rd <= ir_out(8 downto 6);
						ra <= ir_out(5 downto 3);
						rb <= ir_out(2 downto 0);
						if   (ir_out(13 downto 11) = "000") then
							next_state <= ADD_op;
						elsif(ir_out(13 downto 11) = "001") then
							next_state <= AND_op;
						elsif(ir_out(13 downto 11) = "010") then
							next_state <= MOVE_op;
						elsif(ir_out(13 downto 11) = "011") then
							next_state <= NOT_op;
						elsif(ir_out(13 downto 11) = "100") then
							next_state <= INC_op;
						elsif(ir_out(13 downto 11) = "101") then
							next_state <= IN_input;
						elsif(ir_out(13 downto 11) = "110") then
							next_state <= OUT_output;
						elsif(ir_out(13 downto 11) = "111") then
							next_state <= DEC_op;
						else 
							next_state <= RESET; -- fake code
						end if;
				elsif(ir_out(15 downto 14) = "01") then
						Register_select <= ir_out(10 downto 8);
						DataAdr <= ir_out(7 downto 0);
						if(ir_out(13 downto 11) = "000" ) then
							next_state <= LOAD;
						elsif(ir_out(13 downto 11) = "001" ) then
							next_state <= STORE;
						elsif(ir_out(13 downto 11) = "010" ) then
							next_state <= PUSH_a;
						elsif(ir_out(13 downto 11) = "011" ) then
							next_state <= POP_a;
						elsif(ir_out(13 downto 11) = "100" ) then
							next_state <= PUSH_R_a;
						elsif(ir_out(13 downto 11) = "101" ) then
							next_state <= POP_R_a;
						elsif(ir_out(13 downto 11) = "110" ) then  -- different
							case ir_out(7 downto 5) is
								when "000" => DataAdr <= R0_out;
								when "001" => DataAdr <= R1_out;
								when "010" => DataAdr <= R2_out;
								when "011" => DataAdr <= R3_out;
								when "100" => DataAdr <= R4_out;
								when "101" => DataAdr <= R5_out;
								when "110" => DataAdr <= R6_out;
								when "111" => DataAdr <= R7_out;
								when others => null;
							end case;
							next_state <= LOAD;
						elsif(ir_out(13 downto 11) = "111" ) then  -- -- different
							case ir_out(7 downto 5) is
								when "000" => DataAdr <= R0_out;
								when "001" => DataAdr <= R1_out;
								when "010" => DataAdr <= R2_out;
								when "011" => DataAdr <= R3_out;
								when "100" => DataAdr <= R4_out;
								when "101" => DataAdr <= R5_out;
								when "110" => DataAdr <= R6_out;
								when "111" => DataAdr <= R7_out;
								when others => null;
							end case;
							next_state <= STORE;
						end if;
				elsif(ir_out(15 downto 14) = "10") then
						CodeAdr8 <= ir_out(7 downto 0);
						CD <= ir_out(10 downto 8);
						next_state <= JR;
						if(ir_out(13 downto 11) = "111")then
							next_state <= NOP;
						end if;
				elsif(ir_out(15 downto 14) = "11") then
					CodeAdr12 <= ir_out(11 downto 0);
					if(ir_out(13 downto 12) = "00") then
						next_state <= CALL_a;
					elsif(ir_out(13 downto 12) = "01") then
						next_state <= JMP;
					elsif(ir_out(13 downto 12) = "10") then
						next_state <= RET_a;
					elsif(ir_out(13 downto 12) = "11") then
						next_state <= HALT;
					else 
						next_state <= RESET;
					end if;		
				else 
					next_state <= RESET;
				end if;
				
				
			when ADD_op =>
				case rd is 
					when "000" => ld0 <='1' ;
					when "001" => ld1 <='1' ;
					when "010" => ld2 <='1' ;
					when "011" => ld3 <='1' ;
					when "100" => ld4 <='1' ;
					when "101" => ld5 <='1' ;
					when "110" => ld6 <='1' ;
					when "111" => ld7 <='1' ;
					when others =>
				end case;
				sel_mux_ra <= ra;
				sel_mux_rb <= rb;
				sel_mux_rin <= "00";
				sel_alu <= "000";
				next_state <= FETCH;

			when AND_op =>
				case rd is 
					when "000" => ld0 <='1' ;
					when "001" => ld1 <='1' ;
					when "010" => ld2 <='1' ;
					when "011" => ld3 <='1' ;
					when "100" => ld4 <='1' ;
					when "101" => ld5 <='1' ;
					when "110" => ld6 <='1' ;
					when "111" => ld7 <='1' ;
					when others =>
				end case;
				sel_mux_ra <= ra;
				sel_mux_rb <= rb;
				sel_mux_rin <= "00";
				sel_alu <= "001";
				next_state <= FETCH;
				
			when MOVE_op =>
				if(rd = "000") then
					ld0 <='1';
				elsif(rd = "001") then 
					ld1 <='1';
				elsif(rd = "010") then 
					ld2 <='1';
				elsif(rd = "011") then 
					ld3 <='1';
				elsif(rd = "100") then 
					ld4 <='1';
				elsif(rd = "101") then 
					ld5 <='1';
				elsif(rd = "110") then 
					ld6 <='1';
				elsif(rd = "111") then 
					ld7 <='1';
				end if;
				sel_mux_ra <= ra;
				--sel_mux_rb <= rb;
				sel_mux_rin <= "00";
				sel_alu <= "010";
				next_state <= FETCH;
				
			when NOT_op =>
				case rd is 
					when "000" => ld0 <='1' ;
					when "001" => ld1 <='1' ;
					when "010" => ld2 <='1' ;
					when "011" => ld3 <='1' ;
					when "100" => ld4 <='1' ;
					when "101" => ld5 <='1' ;
					when "110" => ld6 <='1' ;
					when "111" => ld7 <='1' ;
					when others =>
				end case;
				sel_mux_ra <= ra;
				--sel_mux_rb <= rb;
				sel_mux_rin <= "00";
				sel_alu <= "011";
				next_state <= FETCH;
				
			when INC_op =>
				if(rd = "000") then
					ld0 <='1';
				elsif(rd = "001") then 
					ld1 <='1';
				elsif(rd = "010") then 
					ld2 <='1';
				elsif(rd = "011") then 
					ld3 <='1';
				elsif(rd = "100") then 
					ld4 <='1';
				elsif(rd = "101") then 
					ld5 <='1';
				elsif(rd = "110") then 
					ld6 <='1';
				elsif(rd = "111") then 
					ld7 <='1';
				end if;
				sel_mux_ra <= ra;
				sel_mux_rb <= rb;
				sel_mux_rin <= "00";
				sel_alu <= "100";
				next_state <= FETCH;

			when IN_input =>
				ld0 <= '1';
				sel_mux_rin <= "11";
				sel_alu <= "010";
				next_state <= FETCH;

			when OUT_output =>
				sel_mux_ra <= rd;
				ld0 <= '1';
				sel_mux_rin <= "00";
				sel_alu <= "010";
				next_state <= FETCH;

			when DEC_op =>
				if(rd = "000") then
					ld0 <='1';
				elsif(rd = "001") then 
					ld1 <='1';
				elsif(rd = "010") then 
					ld2 <='1';
				elsif(rd = "011") then 
					ld3 <='1';
				elsif(rd = "100") then 
					ld4 <='1';
				elsif(rd = "101") then 
					ld5 <='1';
				elsif(rd = "110") then 
					ld6 <='1';
				elsif(rd = "111") then 
					ld7 <='1';
				end if;
				sel_mux_ra <= ra;
				sel_mux_rb <= rb;
				sel_mux_rin <= "00";
				sel_alu <= "101";
				next_state <= FETCH;

				
			when LOAD =>
				case Register_select is 
					when "000" => ld0 <='1' ;
					when "001" => ld1 <='1' ;
					when "010" => ld2 <='1' ;
					when "011" => ld3 <='1' ;
					when "100" => ld4 <='1' ;
					when "101" => ld5 <='1' ;
					when "110" => ld6 <='1' ;
					when "111" => ld7 <='1' ;
					when others =>
				end case;
				sel_mux_rin <= "01";
				next_state <= FETCH;
				
			when STORE =>
				wr_ram <= '1';
				sel_mux_ram <= '0';
				sel_mux_ra <= Register_select;
				next_state <= FETCH;
				
			when PUSH_a =>
				wr_stack <= '1';
				sel_mux_stack <= "01";
				sel_mux_ra <= Register_select;
				next_state <= PUSH_b;

			when PUSH_b =>
				wr_stack <= '0';
				sp_inc <= '1';
				next_state <= FETCH;
				
			when POP_a =>
				sp_dec <= '1';
				next_state <= POP_b;

			when POP_b =>
				sp_dec <= '0';
				wr_ram <= '1';
				sel_mux_ram <= '1';
				next_state <= FETCH;

			when PUSH_R_a =>
				wr_stack <= '1';
				sel_mux_stack <= "00";
				sel_mux_ra <= Register_select;
				next_state <= PUSH_R_b;

			when PUSH_R_b =>
				wr_stack <= '0';
				sp_inc <= '1';
				next_state <= FETCH;
				
			when POP_R_a =>
				sp_dec <= '1';
				next_state <= POP_R_b;
			when POP_R_b =>
				sp_dec <= '0';
				case Register_select is 
					when "000" => ld0 <='1' ;
					when "001" => ld1 <='1' ;
					when "010" => ld2 <='1' ;
					when "011" => ld3 <='1' ;
					when "100" => ld4 <='1' ;
					when "101" => ld5 <='1' ;
					when "110" => ld6 <='1' ;
					when "111" => ld7 <='1' ;
					when others =>
				end case;
				sel_mux_rin <= "10";
				next_state <= FETCH;
				
			when JR =>
				case CD is
					when "000" =>
						if(Z='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "001" =>
						if(C='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "010" =>
						if(S='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "011" =>
						if(V='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "100" =>
						if(F='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "101" =>
						if(E='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "110" =>
						if(Z='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when "111" =>
						if(Z='1') then 
							pc_ld <= '1';
							pc_in <= pc_out + CodeAdr8;
						end if;
					when others =>
				end case;
				next_state <= FETCH;
			when NOP => 
				next_state <= FETCH;
			when CALL_a =>
				sel_mux_stack <= "10";
				wr_stack <= '1';
				next_state <= CALL_b;
			when CALL_b =>
				wr_stack <= '0';
				sp_inc <= '1';
				next_state <= FETCH;
				pc_ld <= '1';
				pc_in <= CodeAdr12;
				
			when JMP =>
				pc_ld <= '1';
				pc_in <= CodeAdr12;
				next_state <= FETCH;
				
			when RET_a =>
				sp_dec <= '1';
				next_state <= RET_b;

			when RET_b =>
				sp_dec <= '0';
				pc_ld <= '1';
				pc_in <= sp_out;
				next_state <= FETCH;

			when HALT =>
				sp_inc <= '0';
				ir_ld <= '0';
				ld0 <= '1';
				ld1 <= '0';
				ld2 <= '0';
				ld3 <= '0';
				ld4 <= '0';
				ld5 <= '0';
				ld6 <= '0';
				ld7 <= '0';
				sel_mux_rin <= "11";
				sel_alu <= "010";
				wr_stack <= '0';
				wr_ram <= '0';
				next_state <= HALT;

			when others => next_state <= MOVE_op;
			
		end case;
	end process;
end architecture;
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;  
----------------------------------------------------------------------------------------------------------------
Entity ALU is
PORT ( 
	A, B: IN std_logic_vector(7 DOWNTO 0);
	sel: IN std_logic_vector(2 DOWNTO 0);
	Q: OUT std_logic_vector(7 DOWNTO 0);
	Z, C, S, V : OUT std_logic
);
END Entity;
-------------------------------------------------------------------------------------------------------------------
Architecture behv of ALU is

Signal temp: std_logic_vector(8 DOWNTO 0) := "000000000";
Signal overflow: std_logic_vector( 7 DOWNTO 0);
Begin
	Q <= temp(7 DOWNTO 0);
	Z <= '1' when temp = "00000000" else '0';
	S <= '0' when temp(7) = '0' else '1';
	C <= temp(8);
	V <= overflow(7) xor temp(8);

	Process(A, B, sel)
	Begin
		case sel is
			when "000" => --ADD
				overflow <= ('0' & A(6 DOWNTO 0)) + ('0' & B(6 DOWNTO 0));
				temp <= ('0' & A) + ('0' & B);
			when "001" =>	-- AND		
				overflow(7) <= '0';
				temp(8) <= '0';
				temp(7 DOWNTO 0) <= A AND B;

			when "010" => -- MOV
				overflow(7) <= '0';
				temp(8) <= '0';
				temp (7 DOWNTO 0) <= A;

			when "011" =>  -- NOT
				overflow(7) <= '0';
				temp(8) <= '0';
				temp (7 DOWNTO 0) <= NOT A;

			when "100" =>  --INC
				overflow <= ('0' & A(6 DOWNTO 0)) + 1;
				temp <= ('0' & A) + 1;

			when "101" => -- DEC
				overflow <= ('0' & A(6 DOWNTO 0)) - 1;
				temp <= ('0' & A) - 1;

			when others =>
				temp(7 DOWNTO 0) <= (others=>'Z');
		end case;
	end process;
end architecture;
-----------------------------------------------------------------------------------------------------------------
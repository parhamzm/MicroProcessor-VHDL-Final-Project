Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all; 
---------------------------------------------------------------------------------------------------------
ENTITY RAM IS
   GENERIC ( 
	bits: INTEGER := 8;	 
        words: INTEGER := 8
);
     PORT ( 
	wr_ena, clk: IN STD_LOGIC;
        addr    : IN std_logic_vector(words-1 downto 0);
        data_in : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
	data_out: OUT STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
	ram_rst : IN std_logic
);
END RAM;
----------------------------------------------------------------------------------------------------------
ARCHITECTURE RAM OF RAM IS

	TYPE vector_array IS ARRAY (0 TO 2**words-1) OF
		STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
	signal memory: vector_array;

Signal Num : Integer := 10;
Type fib_mem is Array (0 To Num-1) OF std_logic_vector(7 Downto 0);
Type array_type is Array (0 To Num-1) OF INTEGER;
Signal Counter : Integer := 0;
Signal mem_fibo : fib_mem;

Function RAM_Fibo(N : Integer) Return fib_mem IS
	VARIABLE array_mem : array_type;
	VARIABLE Memory_fibbo : fib_mem;
Begin
	array_mem(0) := 1;
	Memory_fibbo(0) := Conv_Std_Logic_Vector(array_mem(0), 8);
	array_mem(1) := 1;
	Memory_fibbo(1) := Conv_Std_Logic_Vector(array_mem(1), 8);
	For i IN 2 To N-1 Loop
		array_mem(i) := array_mem(i-1) + array_mem(i-2);
		Memory_fibbo(i) := Conv_Std_Logic_Vector(array_mem(i), 8);
	End Loop;
	Return Memory_fibbo;
	
End Function RAM_Fibo;

BEGIN
	PROCESS (clk, wr_ena, ram_rst)
	BEGIN
		IF (ram_rst = '1') Then
			mem_fibo <= RAM_Fibo(Num);
			for i in memory'Range loop
				if i < Num Then
					memory(i) <= mem_fibo(i);
				else
					memory(i) <= "00000000";
				end if;
			end loop;
		elsiF (wr_ena='1') then
                	IF (clk'EVENT AND clk='1') THEN
				memory(conv_integer(addr)) <= data_in;
                	END IF;
		END IF;
	END PROCESS;
	data_out <= memory(conv_integer(addr));
END RAM;

-------------------------------------------------------------------------------------------------------------
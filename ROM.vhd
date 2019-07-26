library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
-----------------------------------------------------------------------------------------------------------------
ENTITY ROM IS
    GENERIC ( 
		bits : INTEGER := 16;  
		words: INTEGER := 12); 
    PORT (
	read_en : in std_logic;
	Addr : in std_logic_vector(words-1 downto 0);
	Data : OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0)
);
END ROM;
------------------------------------------------------------------------------------------------------------------
ARCHITECTURE behv OF ROM IS
    TYPE vector_array IS ARRAY (0 TO 4095) OF --2*words-1
         STD_LOGIC_VECTOR (15 DOWNTO 0);
    CONSTANT memory: vector_array :=(
				0 => "0010100000000000" , -- IN
				1 => "0001000001000000" ,-- MOV 1,0
				2 => "0010000010011000" ,-- INC 2,3
				3 => "0001000011010000" ,-- MOV 3,2
				4 => "0001000100010000" ,-- MOV 4,2
				5 => "0111101110100000" ,-- STORE_R 3,5
				6 => "0010000110101000" ,-- INC 6,5
				7 => "0001000101110000" ,-- MOV 5,6
				8 => "0111110010100000" ,-- STORE_R 4,5
				9 => "0010000110101000" ,-- INC 6,5
				10 => "0001000101110000" ,-- MOV 5,6
				11 => "0011100010001000" ,-- DEC 2,1
				12 => "0001000001010000" ,-- MOV 1,2
				13 => "0011100010001000" ,-- DEC 2,1
				14 => "0001000001010000" ,-- MOV 1,2
				15 => "0000000010100011" ,-- ADD 2,4,3
				16 => "0001000011100000" ,-- MOV 3,4
				17 => "0001000100010000" ,-- MOV 4,2
				18 => "0111101010101000" ,-- STORE_R 2,5
				19 => "1011100000000001" ,-- NOP
				20 => "0010000110101000" ,-- INC 6,5
				21 => "0001000101110000" ,-- MOV 5,6
				22 => "0011100010001000" ,-- DEC 2,1
				23 => "0001000001010000" ,-- MOV 1,2
				24 => "1000000000000001" ,-- JR z=0
				25 => "1101000000001111" ,-- JMP 15
				26 => "0111001011110000" ,-- LOAD_R 2,7
				27 => "0010000110111000" ,-- INC 6,7
				28 => "0001000111110000" ,-- MOV 7,6
				29 => "0011000010000000" ,-- OUT 2
				30 => "1000000000000001" ,-- JR z=0
				31 => "1101000000011010" ,-- JMP 26
				32 => "1111000000000000" ,-- HALT
				others => "1111100000000000"
);

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
	PROCESS(read_en, Addr)
	Begin
		if(read_en = '1') then
			Data <= memory(conv_integer(Addr));
		end if;
	End Process;
END behv;
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- First couple of question in Assignment 2
-- These questions demonstrate the use of 
--     a) formal GENERICS
--     b) ENTITYs with multiple ARCHITECTURES and
--     c) GENERATING simple and recursive structures.
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity ParityCheck is
     generic( width : integer := 8 );
     port( input : in std_logic_vector( width-1 downto 0 );
           output: out std_logic );
end entity ParityCheck;




architecture Tree1 of ParityCheck is
	signal temp_out : std_logic_vector(6 downto 0); 
begin
	output <= temp_out(6);
	O1: entity work.xor2 port map (input(0), input(1), temp_out(0));
	O2: entity work.xor2 port map (input(2), input(3), temp_out(1));
	O3: entity work.xor2 port map (input(4), input(5), temp_out(2));
	O4: entity work.xor2 port map (input(6), input(7), temp_out(3));

	O5: entity work.xor2 port map (temp_out(0), temp_out(1), temp_out(4));
	O6: entity work.xor2 port map (temp_out(2), temp_out(3), temp_out(5)); 	

	O7: entity work.xor2 port map (temp_out(4), temp_out(5), temp_out(6));
end architecture tree1;




architecture Chain1 of ParityCheck is
signal temp_out : std_logic_vector (7 downto 0);
begin
	temp_out(0) <= input(0);
	output <= temp_out(6);
	O1: entity work.xor2 port map (temp_out(0), input(1), temp_out(1));
	O2: entity work.xor2 port map (temp_out(1), input(2), temp_out(2));
	O3: entity work.xor2 port map (temp_out(2), input(3), temp_out(3));
	O4: entity work.xor2 port map (temp_out(3), input(4), temp_out(4));
	O5: entity work.xor2 port map (temp_out(4), input(5), temp_out(5));
	O6: entity work.xor2 port map (temp_out(5), input(6), temp_out(6));
	O7: entity work.xor2 port map (temp_out(6), input(7), temp_out(7));
	 
end architecture chain1;




architecture Chain2 of ParityCheck is
signal temp_out : std_logic_vector (7 downto 0);
begin
	temp_out(0) <= input(0);
	output <= temp_out(6);
Loopchain: for z in 0 to 6 generate
Az: entity work.xor2 port map (temp_out(z), input(z+1), temp_out(z+1));
end generate Loopchain;
	
end architecture chain2;



-----------------------------------------------------------------------------
-- This version of the architecture performs a recursive instantiation of
-- the ENTITY/ARCHITECTURE. The GENERIC parameter width controls the recursion
-- The recursion stops when the parameter is either 2 or 3. We do not allow
-- the width to become 1 as this may cause problems in specifying the range
-- for the indices of the input array.
-- The division by 2 truncates so you must be very careful when dividing the
-- circuit into two sub-circuits and indexing their input arrays.
-----------------------------------------------------------------------------
architecture Tree2 of ParityCheck is
	signal out_low, out_up : std_logic; 
	signal zero : std_logic := '0';
begin
	Recurr: if (width > 1) generate
			upper: entity work.ParityCheck(Tree2) generic map ((width+1)/2) 
					port map (input(width-1 downto width/2 ), out_up);
			lower: entity work.ParityCheck(Tree2) generic map ((width)/2) 
					port map (input(width/2-1 downto 0 ), out_low);
			xorr: entity work.xor2 port map (out_up, out_low, output);
		End generate Recurr;

	StopRecurr: if width = 1 generate
			output <= input(0); --we need to research this
		End generate StopRecurr; 
end architecture Tree2;

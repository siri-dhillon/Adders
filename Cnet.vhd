-----------------------------------------------------------------------------
-- Declare the Carry network for the adder.
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Cnet is
     generic ( width : integer := 16 );
     port (
          G, P     :     in     std_logic_vector(width-1 downto 0);
          Cin      :     in     std_logic;
          C        :     out    std_logic_vector(width downto 0) );
end entity Cnet;


-----------------------------------------------------------------------------
-- Students must Create the following Carry Network Architectures.
-----------------------------------------------------------------------------
architecture Ripple of Cnet is
	signal c_net : std_logic_vector( width downto 0 );
begin
c_net(0) <= Cin; 
C(0) <= Cin;
columns: for i in 0 to width-1 generate
	cpropmap: entity work.Cprop(Element) port map (G(i),P(i) ,c_net(i), c_net(i+1));
	C(i+1) <= c_net(i+1);
end generate columns;

end architecture Ripple;



architecture BookSkip of Cnet is
	signal c_temp : std_logic_vector( 4 downto 0 );
begin
c_temp(0) <= Cin; 
columns: for j in 0 to 3 generate
	cpropmap: entity work.blockSkip(imp) port map (G(4*j+3 downto 4*j), P(4*j+3 downto 4*j), c_temp(j), c_temp(j+1), C(4*j+4 downto 4*j));
end generate columns;

end architecture BookSkip;



architecture GoodSkip of Cnet is
	signal c_temp : std_logic_vector( 4 downto 0 );
	signal c_net : std_logic_vector (width downto 0);
begin
c_temp(0) <= Cin; 
columns: for j in 0 to 3 generate
	cpropmap: entity work.goodSkipb(imp) port map (G(4*j+3 downto 4*j), P(4*j+3 downto 4*j), c_temp(j), c_temp(j+1), C(4*j+4 downto 4*j));
	
end generate columns;


end architecture GoodSkip;



--G, P     :     in     std_logic_vector(width-1 downto 0);
--          Cin      :     in     std_logic;
--          C        :     out    std_logic_vector(width downto 0) );


--     generic ( width : integer := 16 );
--     port (
--          Gleft, Pleft, Gright, Pright     :     in     std_logic;
--          Gmerged, Pmerged      :     out     std_logic);

architecture BrentKung of Cnet is
	signal tempG : std_logic_vector( (width/2)-1 downto 0 );
	signal tempP : std_logic_vector( (width/2)-1 downto 0 );
	signal initG : std_logic_vector( width-1 downto 0);
	signal initP : std_logic_vector( width-1 downto 0);
	signal leftIndex : integer :=1; 
	signal rightIndex: integer :=0; 
	signal stageCount: integer :=0;
	signal mergeResult: std_logic_vector( 16 downto 0);
begin

	Recur: if (N>1) generate
		top: entity work.Cnet(BrentKung) generic map(N/2) port map (G(N/2 downto 0),P(N/2 downto 0), mergeResult( )); -- create each block eg. 8,4,2,1. output should be halfed
								     --stage 0,1,2,3,4,5,6,7
			columns: for j in 0 to (N/2)/2 generate --create what's inside of each block eg. [7,7] [6,6]
				cpropmap: entity work.GPCircle(imp) port map (Gleft(leftIndex + j*2), Pleft(leftIndex + j*2), Gright(rightIndex + j*2), Pright(rightIndex + j*2), mergeResult(j));
			end generate columns
			
	End Generate Recur;

	StopRecur: if N =1 generate

	End Generate StopRecur;

	--initG <= G;
	--initP <= P;
	--resur: if width > 1 generate
	--stages: for i in 0 to width-1 generate
			--leftt <= leftt + 2;
			--StageUpper: entity work.GPCirlce port map (initG())
			-- StageLower: entity work.GPCirlce port map
	--end generate stages;

	--Stoprecur: if width = 1 generate
				
	--end generate Stoprecur;
	

end architecture BrentKung;






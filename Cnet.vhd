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
columns: for i in  0 to width-1 generate
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


--BLAN
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity BLAN is
     generic ( width : integer := 2 );
     port (
          G, P : in   std_logic_vector(width-1 downto 0);
      	  Gout, Pout : out  std_logic_vector(width-1 downto 0);
end entity BLAN;

architecture structure of BLAN is
	signal GoutputMerged: std_logic_vector((width/2)-1 downto 0);
	signal PoutputMerged: std_logic_vector((width/2)-1 downto 0);
	signal GreducedOutput:std_logic_vector((width/2)-1 downto 0);
	signal PreducedOutput: std_logic_vector((width/2)-1 downto 0);

	--saving 
	signal lastOInputsG : std_logic_vector(width-2 downto 0);
	signal lastOInputsP : std_logic_vector(width-2 downto 0);
	
begin
	--we need to get output for 16bit
	--this is like the nextStageRecursion
	baseCase: if width =2 generate
		Gout(0) <= G(0); --save 7,0 ?? draw out tree
      		Pout(0) <= P(0); 
		outputs: entity work.GPCircle(imp) port map(
				Gleft => G(1),Pleft=>(G(1) ),
				Gright=> G(0),Pright=>P(0) ,
         		 	Gmerged=>Gout(1), Pmerged=>Pout(1) --save 15,0 ??? draw out tree
		);
		
	end baseCase



	recursion: if width > 2 generate
		--generate all the circles in each stage 
		iterateThroughCircles: for i in (width)/ 2 -1 downto 0 generate --1st(7,0) 2nd(3,0) 3rd (1,0) 4th(base case)
			--merge every 2 signals 
			topLayerSignals: entity work.GPCircle(imp) port map(
				Gleft => G(i*2+1),Pleft=> P(i*2+1),
				Gright=>  G(i*2),Pright=> P(i*2) ,
         		 	Gmerged=>GoutputMerged(i), Pmerged=> PoutputMerged(i)
			);
		end iterateThroughCircles;

		--do the next stage with a reduced input size, and output size
		nextStageRecursion: enetity work.BLAN
			generic map( width => width/2)
			port map(
			 	G =>GoutputMerged, P=>PoutputMerged, 
			 	Gout=>GreducedOutput, Pout=>PreducedOutput
			);
		end nextStageRecursion;

		lowerTree: for i in width / 2 - 1 downto 1 generate  --16: 7 down to 1 --8: 3 down to 1 --4:1 down to 1
			lastOInputsG(i*2-1 downto i*2-2) <= GreducedOutput(i-1) & G(2*i); --5 downto 4 3downto 2 1 downto 0  2,1,0 ,g6 g4 g2 ///--1 downto 0, 0 g(2)
			lastOInputsP(i*2-1 downto i*2-2) <= PreducedOutput(i-1) & P(2*i); --5 downto 4 --1 downto 0 0 g(2)
          	  pairEnd1: entity.GPCircle(imp) port map(
                 	   G => lastOInputsG(i*2-1 downto i*2-2),
			   P => lastOInputsP(i*2-1 downto i*2-2), --1 down to 0, 1 down to 0
                 	   Gout => Gout(2*i), 
			   Pout => Pout(2*i) --2,2
                	);
       		 end generate pairEnd;

		 -- assign output signals
       		Gout(0) <= G(0); 
      		Pout(0) <= P(0); 
       		 finalAssignment: for i in width / 2 - 1 downto 0 generate
       		     Gout(2*i+1) <= GreducedOutput(i);
       		     Pout(2*i+1) <= PreducedOutput(i);
       		 end generate finalAssignment;



	end recursion;
end architecture structure;



--BRENTKUNG

architecture BrentKung of Cnet is
	signal outputG : std_logic_vector( (width)-1 downto 0 );
	signal outputP : std_logic_vector( (width)-1 downto 0 );
	signal PandCin: std_logic_vector(width-1 downto 0);

begin
	blan:entity work.BLAN
		generic map(width) --16
		port map(
		G=>G,
		P=>P,
		Gout=>outputG,
		Pout=>outputP,
		);		

	C(0) <= Cin;
    carries: for i in width-1 downto 0 generate
        pcin: entity work.and2 port map(Cin, outputP(i), PandCin(i));
	output: entity work.or2 port map(PandCin(i), outputG(i), out1 => C(i+1));
end architecture BrentKung;






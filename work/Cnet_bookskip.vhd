-----------------------------------------------------------------------------
-- Cprop
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cprop is	
	port (
		g, p : in std_logic;
		Cin : in std_logic;
		Cout : out std_logic
	);
end entity Cprop;

architecture Element of Cprop is
	signal c_temp : std_logic;
begin
	ctemp: entity work.and2 port map (Cin, p, c_temp);
	ripplecnet: entity work.or2 port map (c_temp, g, Cout);

end architecture Element;

-----------------------------------------------------------------------------
-- Cbookskip
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cbookskip is	
	generic ( width : integer := 4 );
	port (
		g, p : in std_logic_vector(width-1 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		CoutI : out std_logic_vector(width -1 downto 0)
	);
end entity Cbookskip;

architecture bloock of Cbookskip is
	signal c_temp : std_logic_vector(width-1 downto 0);
	signal and_temp: std_logic_vector(width-2 downto 0);
begin

c_temp(0) <= Cin;
and_temp(0) <=p(0);

CpropsLoop: for i in 0 to width-1 generate
	Cprops: entity work.Cprop port map (g(i), p(i), c_temp(i),c_temp(i+1));
	CoutI(i) <= c_temp(i+1); --stuff
end generate CpropsLoop;

andLoop: for i in 0 to width-2 generate
	andGates: entity work.And2 port map(and_temp(i),p(i+1),and_temp(i+1));
end generate andLoop;

Cprops: entity work.Cprop port map (c_temp(4), and_temp(3),Cin,Cout);

	-- add the code for block on page 

end architecture bloock;

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
	signal c_temp : std_logic_vector( width-1 downto 0 );
	signal c_net : std_logic_vector( width downto 0 );
begin
c_net(0) <= Cin; 
C(0) <= Cin;
columns: for i in 0 to width-1 generate
	ctemp: entity work.and2 port map (c_net(i), P(i), c_temp(i));
	ripplecnet: entity work.or2 port map (c_temp(i), G(i), c_net(i+1));
	C(i+1) <= c_net(i+1);
end generate columns;

end architecture Ripple;


architecture BookSkip of Cnet is
	signal c_temp : std_logic_vector( 4 downto 0 ); --input of block
	signal c_stuff : std_logic_vector( 4 downto 0 );
begin

c_temp(0) <= Cin;

gg: for x in 0 to 3 generate
	Cbookskipx: entity work.Cbookskip port map(G( 4*x+3 downto 4*x) ,P( 4*x+3 downto 4*x) ,c_temp(x),c_temp(x+1),c_stuff);
	C( 4*x+3 downto 4*x)  <= c_stuff;
	end generate gg;
end architecture BookSkip;




architecture GoodSkip of Cnet is
begin
end architecture GoodSkip;




architecture BrentKung of Cnet is
begin
end architecture BrentKung;






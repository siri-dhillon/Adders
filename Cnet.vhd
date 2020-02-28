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



-- Brent-Kung style BLAN
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BKBlan is
    generic (
        width : integer := 2
    );
    port (
        G, P : in std_logic_vector(width-1 downto 0);
        GxToBase, PxToBase : out std_logic_vector(width-1 downto 0)
    );
end entity BKBlan;

architecture Structural of BKBlan is
    signal pairedG : std_logic_vector((width) / 2 - 1 downto 0);
    signal pairedP : std_logic_vector((width) / 2 - 1 downto 0);
    signal G2xToBase : std_logic_vector((width) / 2 - 1 downto 0);
    signal P2xToBase : std_logic_vector((width) / 2 - 1 downto 0);
	signal lastOInputsG : std_logic_vector(width-2 downto 0);
	signal lastOInputsP : std_logic_vector(width-2 downto 0);
begin
    baseCase: if width = 2 generate
        GxToBase(0) <= G(0);
        PxToBase(0) <= P(0);
        aggregate: entity work.GPCircle(imp) port map(
                Gleft => G(1),Pleft => P(1),
		Gright => G(0),Pright => P(0),
                Gmerged => GxToBase(1), Pmerged => PxToBase(1)
            );
    end generate baseCase;
    recursion: if width > 2 generate
        -- get paired up signals
        pairGPSignals: for i in (width) / 2 - 1 downto 0 generate
            pairGP1: entity work.GPCircle(imp) port map(
                    Gleft => G(i*2+1),Pleft=> P(i*2+1),
		    Gright=>  G(i*2),Pright=> P(i*2) ,
                    Gmerged => pairedG(i), Pmerged => pairedP(i)
                );
        end generate pairGPSignals;
        -- recur
        recur: entity work.BKBlan 
            generic map(
                width => width / 2
            )
            port map(
                G => pairedG, P => pairedP,
                GxToBase => G2xToBase, PxToBase => P2xToBase
            );
        -- pair end
        pairEnd: for i in width / 2 - 1 downto 1 generate  --16: 7 down to 1 --8: 3 down to 1 --4:1 down to 1
			lastOInputsG(i*2-1 downto i*2-2) <= G2xToBase(i-1) & G(2*i); --5 downto 4 3downto 2 1 downto 0  2,1,0 ,g6 g4 g2 ///--1 downto 0, 0 g(2)
			lastOInputsP(i*2-1 downto i*2-2) <= P2xToBase(i-1) & P(2*i); --5 downto 4 --1 downto 0 0 g(2)
            pairEnd1: entity work.GPCircle(imp) port map(
                    Gleft => lastOInputsG(i*2-1),
		    Pleft => lastOInputsP(i*2-1 ),
		    Gright => lastOInputsG( i*2-2),
		    Pright => lastOInputsP(i*2-2),
 --1 down to 0, 1 down to 0
                    Gmerged => GxToBase(2*i), Pmerged => PxToBase(2*i) --2,2
                );
        end generate pairEnd;

        -- assign output signals
        GxToBase(0) <= G(0);
        PxToBase(0) <= P(0);
        finalAssignment: for i in width / 2 - 1 downto 0 generate
            GxToBase(2*i+1) <= G2xToBase(i);
            PxToBase(2*i+1) <= P2xToBase(i);
        end generate finalAssignment;

    end generate recursion;
end architecture Structural;


architecture BrentKung of Cnet is
    -- G   : width-1 downto 0
    -- P   : width-1 downto 0
    -- C   : std_logic
    -- Cin : width downto 0
    signal aggregateG: std_logic_vector(width-1 downto 0);
    signal aggregateP: std_logic_vector(width-1 downto 0);
    signal PandCin: std_logic_vector(width-1 downto 0);
begin
    bkblan: entity work.BKBlan 
        generic map(width => width)
        port map(
            G => G, P => P,
            GxToBase => aggregateG,
            PxToBase => aggregateP
        );
	-- get carries
	C(0) <= Cin;
    carries: for i in width-1 downto 0 generate

	cpropmap: entity work.Cprop(Element) port map (
	G => aggregateG(i),
	P =>	aggregateP(i),
	Cin=>	Cin,
	Cout=>	C(i+1)
	);

    end generate carries;
end architecture BrentKung;




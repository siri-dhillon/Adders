-----------------------------------------------------------------------------
-- 4-bit block skip
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity blockSkip is	
	port (
		G, P : in std_logic_vector(3 downto 0);
		Cin : in std_logic;
		out_sig: out std_logic;
		Cout : out std_logic_vector(4 downto 0)
	);
end entity blockSkip;

architecture imp of blockSkip is
	signal c_net : std_logic_vector(5 downto 0);
	signal andsig: std_logic;
begin
c_net(0) <= Cin; 
Cout(0) <= Cin;
propskip: entity work.and4 port map (P(0), P(1), P(2), P(3), andsig);
columns: for i in 0 to 3 generate
	normal: if i < 3 generate
			cpropmap0: entity work.Cprop(Element) port map (G(i),P(i) ,c_net(i), c_net(i+1));
			Cout(i+1) <= c_net(i+1);
	end generate normal;
	notnormal: if i = 3 generate 
			cpropmap: entity work.Cprop(Element) port map (G(i),P(i) ,c_net(i), c_net(i+1));
			cpropmap1: entity work.Cprop(Element) port map (c_net(i+1),andsig , Cin, c_net(i+2));
			Cout(i+1) <= c_net(i+2);
			out_sig <= c_net(i+2);
	end generate notnormal;



end generate columns;

end architecture imp;

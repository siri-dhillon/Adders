-----------------------------------------------------------------------------
-- 4-bit block skip
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity goodSkipb is	
	port (
		G, P : in std_logic_vector(3 downto 0);
		Cin : in std_logic;
		out_sig: out std_logic;
		Cout : out std_logic_vector(4 downto 0)
	);
end entity goodSkipb;

architecture imp of goodSkipb is
	signal c_net : std_logic_vector(4 downto 0);
	signal andsig: std_logic;
	signal temp_out: std_logic;
begin
c_net(0) <= Cin; 
Cout(0) <= Cin;
propskip: entity work.and4 port map (P(0), P(1), P(2), P(3), andsig);

--propskip2: entity work.and2 port map (andsig(0), Cin, andsig(1));
out_sig <= Cin when andsig = '1' else c_net(4); -- this is a mux
--Cout <= '00000' when andsig(1) = '1';
columns: for i in 0 to 3 generate
		cpropmap0: entity work.Cprop(Element) port map (G(i),P(i) ,c_net(i), c_net(i+1));
		Cout(i+1) <= c_net(i+1);
end generate columns;

end architecture imp;

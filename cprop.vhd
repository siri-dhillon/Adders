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
-- GPmerge
-----------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

--entity GPmerge is	
--	port (
--		gUpper, pLower : in std_logic;
--		gLower, pLower : in std_logic;
--		gResult, pResult: out std_logic;
--	);
--end entity GPMerge;
--
--	
--architecture Element of GPmerge is
--	signal andOutput : std_logic;
--begin
--	gAnd: entity work.and2 port map (pUpper,gLower,andOutput);
--	gOr: entity work.or2 port map (gUpper,andOutput,gResult);
--	pAnd: entity work.and2 port map (pUpper,pLower,pResult);
--end architecture Element;
-----------------------------------------------------------------------------
-- entity 
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity GPCircle is
     generic ( width : integer := 16 );
     port (
          Gleft, Pleft, Gright, Pright     :     in     std_logic;
          Gmerged, Pmerged      :     out     std_logic);
end entity GPCircle;


-----------------------------------------------------------------------------
-- GPCircle
-----------------------------------------------------------------------------
architecture imp of GPCircle is

begin
	Cpropimp: entity work.Cprop(Element) port map (Gleft,Pleft ,Gright, Gmerged);
	And2imp:  entity work.and2 port map (Pleft, Pright, Pmerged);

end architecture imp;

-----------------------------------------------------------------------------
-- Declare the Input network that produces the Generate and Propagate signals
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GPnet is
     generic ( width : integer := 16 );
     port (
          X, Y     :     in     std_logic_vector(width-1 downto 0);
          G, P     :     out    std_logic_vector(width-1 downto 0) );
end entity GPnet;



architecture Structural of GPnet is
begin
     bitcell: for i in width-1 downto 0
     generate
     begin
          cellGi: entity Work.and2 port map ( X(i), Y(i), G(i) );
          cellPi: entity Work.xor2 port map ( X(i), Y(i), P(i) );
     end generate bitcell;
end architecture Structural;




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-----------------------------------------------------------------------------
-- Declare the Output network that produces the Sum bits. The output carry is
-- Labeled as an additional Sum Bit.
-----------------------------------------------------------------------------
entity Snet is
     generic ( width : integer := 16 );
     port (
          P        :     in     std_logic_vector(width-1 downto 0);
          C        :     in     std_logic_vector(width downto 0);
          S        :     out    std_logic_vector(width downto 0) );
end entity Snet;


architecture Structural of Snet is
begin
     
     bitcell: for i in width-1 downto 0
     generate
     begin
          cellSi: entity Work.xor2 port map ( P(i), C(i), S(i) );
     end generate bitcell;
     
     S(width) <= C(width);
     
end architecture Structural;

-----------------------------------------------------------------------------
-- Declaration of an adder. The adder contains 3 entities. Different
-- architectures differ only in their Carry network. The adder can be used to
-- instantiate circuits of varying width. The default is 16-bits.
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity adder is
     generic ( width : integer := 16 );
     port (
          X, Y     :     in     std_logic_vector(width-1 downto 0);
          Cin      :     in     std_logic;
          S        :     out    std_logic_vector(width downto 0) );
end entity adder;





-----------------------------------------------------------------------------
-- Ripple Adder Architecture.
-----------------------------------------------------------------------------

architecture Ripple of adder is
     signal     G, P     : std_logic_vector(width-1 downto 0);
     signal     C        : std_logic_vector(width downto 0);
begin
input:  entity Work.GPnet generic map (width) port map ( X, Y, G, P );
middle: entity Work.Cnet(Ripple)
                          generic map (width) port map ( G, P, Cin, C );
output: entity Work.Snet  generic map (width) port map ( P, C, S );
end architecture Ripple;





-----------------------------------------------------------------------------
-- Skip Carry Adder - As in Textbook.
-----------------------------------------------------------------------------

architecture BookSkip of adder is
     signal     G, P     : std_logic_vector(width-1 downto 0);
     signal     C        : std_logic_vector(width downto 0);
begin
input:  entity Work.GPnet generic map (width) port map ( X, Y, G, P );
middle: entity Work.Cnet(BookSkip)
                          generic map (width) port map ( G, P, Cin, C );
output: entity Work.Snet  generic map (width) port map ( P, C, S );
end architecture BookSkip;






-----------------------------------------------------------------------------
-- Skip Carry Adder - with correction.
-----------------------------------------------------------------------------

architecture GoodSkip of adder is
     signal     G, P     : std_logic_vector(width-1 downto 0);
     signal     C        : std_logic_vector(width downto 0);
begin
input:  entity Work.GPnet generic map (width) port map ( X, Y, G, P );
middle: entity Work.Cnet(GoodSkip)
                          generic map (width) port map ( G, P, Cin, C );
output: entity Work.Snet  generic map (width) port map ( P, C, S );
end architecture GoodSkip;



-----------------------------------------------------------------------------
-- Brent Kung Adder.
-----------------------------------------------------------------------------

architecture BrentKung of adder is
     signal     G, P     : std_logic_vector(width-1 downto 0);
     signal     C        : std_logic_vector(width downto 0);
begin
input:  entity Work.GPnet generic map (width) port map ( X, Y, G, P );
middle: entity Work.Cnet(BrentKung)
                          generic map (width) port map ( G, P, Cin, C );
output: entity Work.Snet  generic map (width) port map ( P, C, S );
end architecture BrentKung;

-----------------------------------------------------------------------------
-- AND gates
-----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity and2 is
    port(
        in1, in2 :     in      std_logic;
        out1     :     out     std_logic );
end entity and2;

architecture primitive of and2 is
begin
       out1 <= in1 and in2 after 2 ns;
end architecture primitive;

library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity and3 is
    port(
        in1, in2, in3 :     in      std_logic;
        out1          :     out     std_logic );
end entity and3;

architecture primitive of and3 is
begin
     out1 <= in1 and in2 and in3 after 2 ns;
end architecture primitive;






library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity and4 is
    port(
        in1, in2      :     in      std_logic;
        in3, in4      :     in      std_logic;
        out1          :     out     std_logic );
end entity and4;

architecture primitive of and4 is
begin
     out1 <= in1 and in2 and in3 and in4 after 3 ns;
end architecture primitive;





-----------------------------------------------------------------------------
-- OR gates
-----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity or2 is
    port(
        in1, in2 :     in      std_logic;
        out1     :     out     std_logic );
end entity or2;

architecture primitive of or2 is
begin
     out1 <= in1 or in2 after 2 ns;
end architecture primitive;

library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity or3 is
    port(
        in1, in2, in3 :     in      std_logic;
        out1          :     out     std_logic );
end entity or3;

architecture primitive of or3 is
begin
     out1 <= in1 or in2 or in3 after 2 ns;
end architecture primitive;







library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity or4 is
    port(
        in1, in2      :     in      std_logic;
        in3, in4      :     in      std_logic;
        out1          :     out     std_logic );
end entity or4;

architecture primitive of or4 is
begin
     out1 <= in1 or in2 or in3 or in4 after 3 ns;
end architecture primitive;




-----------------------------------------------------------------------------
-- XOR gates
-----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity xor2 is
    port(
        in1, in2 :     in      std_logic;
        out1     :     out     std_logic );
end entity xor2;

architecture primitive of xor2 is
begin
       out1 <= in1 xor in2 after 3 ns;
end architecture primitive;


-----------------------------------------------------------------------------
-- Inverter
-----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity inverter is
     port ( in1     : in     std_logic;
            out1    : out    std_logic );
end entity inverter;

architecture primitive of inverter is
begin
     out1 <= not in1 after 1 ns;
end architecture primitive;


-----------------------------------------------------------------------------
-- The basic building block for carry propagation
-----------------------------------------------------------------------------
library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cprop is
     port (
          G, P, Cin     : in     std_logic;
          Cout          : out    std_logic );
end entity Cprop;

architecture Structural of Cprop is
     signal     t     :     std_logic;
begin
     c1:     entity     Work.and2 port map ( Cin, P, t );
     c2:     entity     Work.or2  port map ( G, t, Cout );
end architecture Structural;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestPart2 is
end entity TestPart2;

architecture Behavioural of TestPart2 is
     signal  X, Y : std_logic_vector(15 downto 0) := (others => 'U');
     signal  Cin  : std_logic;
     signal  SR, SBS, SGS, SBK: std_logic_vector(16 downto 0);
begin




i1:  entity work.adder(Ripple)   generic map (16) port map ( X, Y, Cin, SR );
i2:  entity work.adder(BookSkip) generic map (16) port map ( X, Y, Cin, SBS );
i3:  entity work.adder(GoodSkip) generic map (16) port map ( X, Y, Cin, SGS );
i4:  entity work.adder(BrentKung)generic map (16) port map ( X, Y, Cin, SBK );




     process
     begin



          X <= (others => 'U');
          Y <= (others => 'U');
          Cin <= 'U';
          wait for 5 ns;
          X <= "0000000000000000";
          Y <= "0000000000000000";
          Cin <= '0';
          wait for 40 ns;



          X <= (others => 'U');
          Y <= (others => 'U');
          Cin <= 'U';
          wait for 5 ns;
          X <= "1111111111111111";
          Y <= "0000000000000000";
          Cin <= '1';
          wait for 70 ns;



          X <= (others => 'U');
          Y <= (others => 'U');
          Cin <= 'U';
          wait for 5 ns;
          X <= "1111111111111111";
          Y <= "0000000100000000";
          Cin <= '1';
          wait for 45 ns;



          X <= (others => 'U');
          Y <= (others => 'U');
          Cin <= 'U';
          wait for 5 ns;
          X <= "1111111111111111";
          Y <= "0000000100000001";
          Cin <= '0';
          wait for 45 ns;



          X <= (others => 'U');
          Y <= (others => 'U');
          Cin <= 'U';
          wait for 5 ns;
          X <= "1111111111111111";
          Y <= "0001000100010001";
          Cin <= '0';
          wait for 45 ns;

     wait;          
     end process;
end architecture Behavioural;


  library IEEE;
  use     IEEE.STD_LOGIC_1164.ALL;
  use     IEEE.STD_LOGIC_ARITH.ALL;
  use     IEEE.STD_LOGIC_UNSIGNED.ALL;

  entity  TestPart1 is
  end entity TestPart1;

  architecture Behavioural of TestPart1 is
        signal     input                 : std_logic_vector(7 downto 0);
        signal     Tree1Out, Chain1Out   : std_logic; 
        signal     Tree2Out, Chain2Out   : std_logic; 
  begin

  i1:     entity work.ParityCheck(Tree1)
               port map ( input, Tree1Out );
  i2:     entity work.ParityCheck(Chain1)
               port map ( input, Chain1Out );
  i3:     entity work.ParityCheck(Chain2)
               port map ( input, Chain2Out );
  i4:     entity work.ParityCheck(Tree2)
               generic map ( 8 )
               port map( input( 7 downto 0), Tree2Out );
                    
     process
     begin
 
          input <= "00000000";
          for i in 1 to 15
          loop
               wait for 40 ns;
               input <= input + 13;
          end loop;
          wait;          
          
     end process;
  end architecture Behavioural;

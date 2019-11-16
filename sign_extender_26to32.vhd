library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extender_26to32 is
  port(i_to_extend : in std_logic_vector(25 downto 0);
  	   o_extended : out std_logic_vector(31 downto 0));
 end sign_extender_26to32;

architecture Behavioral of sign_extender_26to32 is 

begin

with i_to_extend(25) select
	o_extended <= 	("111111" & i_to_extend) when '1',
					("000000" & i_to_extend) when others;

end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/14 15:40:33
-- Design Name: 
-- Module Name: mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

 

entity mux3 is

port(
x,y : in STD_LOGIC_VECTOR(31 DOWNTO 0);

s: in STD_LOGIC;

z: out STD_LOGIC_VECTOR(31 DOWNTO 0)
);

end mux3 ;

 

architecture Behavioral of mux3 is

 

begin

 

process (x,y,s) is

begin

if (s ='0') then

z <= x;

else

z <= y;

end if;

end process;

 

end Behavioral;
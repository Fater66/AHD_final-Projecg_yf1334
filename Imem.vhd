----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/11 15:31:13
-- Design Name: 
-- Module Name: Imem - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Imem is
 Port (
        PCin: in std_logic_vector(31 downto 0);
        rst: in std_logic;
        clk: in std_logic;
        addressout: out std_logic_vector(31 downto 0)
        
  );
end Imem;

architecture Behavioral of Imem is

TYPE rom IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0); 
CONSTANT irom: rom:=rom'( "00010000","00000001","00000000","01111011","00010000","00000010","00000001","11001000");
--signal count:std_logic_vector(2 downto 0);
signal count:std_logic_vector(31 downto 0);

begin
count<=PCin;

process(clk,rst)
begin
    if (rst = '1') then
        addressout <="00000000000000000000000000000000";
        --count<=0;
    elsif(clk 'event and clk='1') then
        addressout<=irom(CONV_INTEGER(count))& irom(CONV_INTEGER(count+'1'))& irom(CONV_INTEGER(count+"10")) & irom(CONV_INTEGER(count+"11"));
    end if;
end process;



end Behavioral;
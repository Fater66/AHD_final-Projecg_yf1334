----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/11 16:16:36
-- Design Name: 
-- Module Name: dmem - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dmem is
    Port (
        wrtenable: in std_logic;--"10" write,"01" read
        clk: in std_logic;
        rst: in std_logic;
        addr: in std_logic_vector(31 downto 0);--32byte data
        wrtdata: in std_logic_vector(31 downto 0);
        readdata: out std_logic_vector(31 downto 0)
        --currentwrtdata: out std_logic_vector(16 downto 0)
     );
end dmem;

architecture Behavioral of dmem is
TYPE rom IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0); 
signal drom: rom:=rom'( "0000000000000000","0000000000000001","0000000000000010","0000000000000011","0000000000000100","0000000000000101","0000000000000110","0000000000000111");
--signal addrenable:std_logic;
--signal count:std_logic_vector(2 downto 0);
--signal count:std_logic_vector(7 downto 0);

begin

process(addr)
begin
    if(unsigned(addr)<8)then
        drom(to_integer(unsigned(addr)))<= wrtdata(31 downto 16);
        drom(to_integer(unsigned(addr)+1))<= wrtdata(15 downto 0);
        --addrenable<='1';
    --else
       -- addrenable<='0';
    end if;
end process;


process(clk,rst)
    begin
        if(rst='1') then
             readdata <="00000000000000000000000000000000";
        elsif(clk 'event and clk='1') then
            if(wrtenable='1') then
               readdata<=drom(to_integer(unsigned(addr)))&drom(to_integer(unsigned(addr)+1));
--            elsif (wrtenable="10") then

--            else
--                 drom<=drom;
             end if;
           end if;
end process;
          
               
            
        
end Behavioral;

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
use ieee.std_logic_unsigned.all;

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
     );
end dmem;

architecture Behavioral of dmem is
TYPE rom IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0); 
signal drom: rom:=rom'( "0000000000000000","0000000000000001","0000000000000010","0000000000000011","0000000000000100","0000000000000101","0000000000000110","0000000000000111");

begin
process(clk,rst) begin
    if(rst = '1') then
    
    else if( rising_edge(clk)) then
            if(addr < 7) then
            
                if(wrtenable ='0') then
                    readdata <= "0000000000000000" & drom(CONV_INTEGER(addr));
				else
				    drom(CONV_INTEGER(addr)) <= wrtdata(15 DOWNTO 0);	
                    readdata <= "0000000000000000" & wrtdata(15 DOWNTO 0); 
                    
                end if;
                
            end if;
        end if;
     end if;         
end process;  
        
end Behavioral;

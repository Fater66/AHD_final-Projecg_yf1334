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
TYPE rom IS ARRAY (0 TO 55) OF STD_LOGIC_VECTOR(15 DOWNTO 0); 
signal drom: rom:=rom'( X"9BBB",X"1A37",X"46F8",X"460C",X"70F8",X"284B",X"513E",X"F621",X"3125",X"11A8",X"D427",X"713A",X"4B79",X"2799",X"A790",X"DEDE",X"36C0",X"A7EF",X"61A7",X"3B0A",X"4DBF",X"AE16",X"30D7",X"4319",X"F6CC",X"6504",X"D8C8",X"F7FB",X"E8C5",X"6085",X"3B8A",X"8303",X"1454",X"ED22",X"065D",X"3A5D",X"686B",X"D82D",X"2F99",X"A4DD",X"1C49",X"871A",X"3196",X"C249",X"8BB8",X"1D2B",X"CA76",X"2167",X"6B0A",X"2304",X"1431",X"6380",X"0000",X"0000",X"0000",X"0000");
signal wrtenable_inside: std_logic_vector(31 downto 0);
begin

process(clk,wrtenable) begin
   --if(rst = '1') then
    
   if( rising_edge(clk)) then
           -- if(CONV_INTEGER(addr) < 55) then
            
--                if(wrtenable ='0') then
--                    readdata <= x"0000" & drom(CONV_INTEGER(addr));
--				else
				 if(wrtenable ='1') then
				    drom(CONV_INTEGER(addr)) <= wrtdata(15 DOWNTO 0);	
                    --wrtenable_inside <= x"0000" & wrtdata(15 DOWNTO 0); 
                    
                end if;
                
            end if;
        --end if;
     --end if;         
end process;  
   readdata <= x"0000" & drom(CONV_INTEGER(addr)) when addr<x"38"
               else x"00000000";        
end Behavioral;

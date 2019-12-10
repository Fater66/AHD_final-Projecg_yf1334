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
        ukey: in std_logic_vector(127 downto 0);
        ukeyready: in std_logic;
        din:in std_logic_vector(63 downto 0);
        dinready: in std_logic;
        wrtdata: in std_logic_vector(31 downto 0);
        readdata: out std_logic_vector(31 downto 0)
        
     );
end dmem;

architecture Behavioral of dmem is
TYPE rom IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(15 DOWNTO 0); 
signal drom: rom:=rom'( X"9BBB",X"1A37",X"46F8",X"460C",X"70F8",X"284B",X"513E",X"F621",X"3125",X"11A8",X"D427",X"713A",X"4B79",X"2799",X"A790",X"DEDE",X"36C0",X"A7EF",X"61A7",X"3B0A",X"4DBF",X"AE16",X"30D7",X"4319",X"F6CC",X"6504",X"D8C8",X"F7FB",X"E8C5",X"6085",X"3B8A",X"8303",X"1454",X"ED22",X"065D",X"3A5D",X"686B",X"D82D",X"2F99",X"A4DD",X"1C49",X"871A",X"3196",X"C249",X"8BB8",X"1D2B",X"CA76",X"2167",X"6B0A",X"2304",X"1431",X"6380",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000");
signal wrtenable_inside: std_logic_vector(31 downto 0);
signal ukeyready_in: std_logic;
begin
--ukeyready_in<=ukeyready;
process(clk,wrtenable) begin
   --if(rst = '1') then
    
   if( rising_edge(clk)) then
        if(ukeyready='1') then--56 to 63 for ukey,from high to low
            drom(56)<=ukey(127 downto 112);
            drom(57)<=ukey(111 downto 96);
            drom(58)<=ukey(95 downto 80);
            drom(59)<=ukey(79 downto 64);
            drom(60)<=ukey(63 downto 48);
            drom(61)<=ukey(47 downto 32);
            drom(62)<=ukey(31 downto 16);
            drom(63)<=ukey(15 downto 0);
         elsif(dinready='1') then
            drom(52)<=din(63 downto 48);
            drom(53)<=din(47 downto 32);
            drom(54)<=din(31 downto 16);
            drom(55)<=din(15 downto 0);
		 elsif(wrtenable ='1') then
				    drom(CONV_INTEGER(addr)) <= wrtdata(15 DOWNTO 0);	
                    --wrtenable_inside <= x"0000" & wrtdata(15 DOWNTO 0); 
                  end if;
                 else 
            end if;
        --end if;
     --end if;         
end process;  
   readdata <= x"0000" & drom(CONV_INTEGER(addr)) when addr<x"38"
               else x"00000000";        
end Behavioral;

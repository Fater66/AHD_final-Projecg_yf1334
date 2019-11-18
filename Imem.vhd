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
        addressout: out std_logic_vector(31 downto 0);
        ishalt: out std_logic
  );
end Imem;

architecture Behavioral of Imem is

TYPE rom IS ARRAY (0 TO 75) OF STD_LOGIC_VECTOR(7 DOWNTO 0); 
--CONSTANT irom: rom:=rom'( "00010000","00000001","00000000","01111011","00010000","00000010","00000001","11001000");
CONSTANT irom: rom:=rom'( "00000000","00000000","00001000","00010100",
                          "00000000","00100001","00010000","00010010",
                          "00001100","01000011","00000000","00000001",
                          "00000000","00000011","00100000","00010011",
                          "00010000","10000101","00000000","00000010",
                          "00101000","01100100","00000000","00000001",
                          "00010000","00000001","00000000","01001101",
                          "00101100","01000001","00000000","00000001",
                          "00100100","10000101","00000000","00001100",
                          "00010000","00000011","00000000","11101010",
                          "00100000","00000001","00000000","00000101",
                          "00011100","00000110","00000000","00000101",
                          "00000000","10000101","00111000","01010000",
                          "00000000","11100111","01000000","10010001",
                          "00000001","00000111","01001000","00010101",
                          "00000001","00101000","01010000","00010110",
                          "00110000","00000000","00000000","00000001",
                          "00000000","00100011","00000000","00010011",
                          "11111100","00000000","00000000","00000000");
--signal count:std_logic_vector(2 downto 0);
signal count:std_logic_vector(31 downto 0):=x"00000000";
signal address_judge:std_logic_vector(31 downto 0);

begin
count<=PCin;
--address_judge<=irom(CONV_INTEGER(count))& irom(CONV_INTEGER(count+'1'))& irom(CONV_INTEGER(count+"10")) & irom(CONV_INTEGER(count+"11"));
ishalt<='1' when address_judge="11111100000000000000000000000000"            else '0';
addressout<=address_judge;
process(clk,rst)
begin
    --address_judge<=irom(CONV_INTEGER(count)/4);
        address_judge<=irom(CONV_INTEGER(count))& irom(CONV_INTEGER(count+'1'))& irom(CONV_INTEGER(count+"10")) & irom(CONV_INTEGER(count+"11"));
end process;
    --addressout<=address_judge;
--    if (rst = '1') then
--        addressout <="00000000000000000000000000000000";
--        ishalt<='0';
--        --count<=0;
--    --elsif(clk 'event and clk='1') then
--        --if(count="11111100000000000000000000000000");
--    elsif (address_judge="11111100000000000000000000000000")then 
--        ishalt<='1';
--    else
--        address_judge<=irom(CONV_INTEGER(count))& irom(CONV_INTEGER(count+'1'))& irom(CONV_INTEGER(count+"10")) & irom(CONV_INTEGER(count+"11"));
--        addressout<=address_judge;
--    end if;
--end process;



end Behavioral;
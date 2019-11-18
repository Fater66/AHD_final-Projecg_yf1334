----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/11 18:14:24
-- Design Name: 
-- Module Name: RF - Behavioral
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

entity RF is
  Port (
        clk: in std_logic;
        rst: in std_logic;
        instr: in std_logic_vector(31 downto 0);--instruction from previous block
        --A1: in std_logic_vector(4 downto 0);
        --A2: in std_logic_vector(4 downto 0);
        A3: in std_logic_vector(4 downto 0);-- comes from the mux
        regwrt: in std_logic;--'1' enable,'0' unable
        wrtdata: in std_logic_vector(31 downto 0);--comes from the mux
        readdata1: out std_logic_vector(31 downto 0);
        readdata2: out std_logic_vector(31 downto 0)       
   );
end RF;

architecture Behavioral of RF is
TYPE rom IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
signal drom: rom:=rom'( x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000");
constant dromclr: rom:=rom'( x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000");
signal A1: std_logic_vector(4 downto 0);
signal A2: std_logic_vector(4 downto 0);

begin
A1<=instr(25 downto 21);
A2<=instr(20 downto 16);
readdata1<=drom(to_integer(unsigned(A1)));
readdata2<=drom(to_integer(unsigned(A2)));
process(clk,rst)
begin
    if(rst='1')then
        drom<=dromclr;
    elsif (clk'event and clk='1') then
     if(regwrt='1') then
        drom(to_integer(unsigned(A3)))<=wrtdata;
     end if;
    end if;
end process;
end Behavioral;

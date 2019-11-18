----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/11 19:09:09
-- Design Name: 
-- Module Name: ALU - Behavioral
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
USE ieee.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
 Port ( 
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           shiftamount:in STD_LOGIC_VECTOR(2 downto 0);
           aluop : in STD_LOGIC_VECTOR (2 downto 0);
           aluresult : out STD_LOGIC_VECTOR (31 downto 0)
           );
 
end ALU;

architecture Behavioral of ALU is
signal xorleftrotate:STD_LOGIC_VECTOR (31 downto 0);
signal RsxorRt:STD_LOGIC_VECTOR (31 downto 0);
signal Rsrightrotate:STD_LOGIC_VECTOR (31 downto 0);
signal Rsleftrotate:STD_LOGIC_VECTOR (31 downto 0);
signal Rs_Rtrightrotate:STD_LOGIC_VECTOR (31 downto 0);
signal Rs_Rt:STD_LOGIC_VECTOR (31 downto 0);
signal alucalculate : STD_LOGIC_VECTOR (31 downto 0):=x"00000000";


begin
RsxorRt<=op1 xor op2;
Rs_Rt<=op1-op2;

with shiftamount select
    xorleftrotate<= RsxorRt(30 downto 0)& RsxorRt(31) when"001",
                    RsxorRt(29 downto 0)& RsxorRt(31 downto 30) when"010",
                    RsxorRt(28 downto 0)& RsxorRt(31 downto 29) when"011",
                    RsxorRt(27 downto 0)& RsxorRt(31 downto 28) when"100",
                    RsxorRt(26 downto 0)& RsxorRt(31 downto 27) when"101",
                    RsxorRt(25 downto 0)& RsxorRt(31 downto 26) when"110",
                    RsxorRt(24 downto 0)& RsxorRt(31 downto 25) when"111",
                    RsxorRt when others;

with shiftamount select
    Rsleftrotate<= op1(30 downto 0)& op1(31) when"001",
                    op1(29 downto 0)& op1(31 downto 30) when"010",
                    op1(28 downto 0)& op1(31 downto 29) when"011",
                    op1(27 downto 0)& op1(31 downto 28) when"100",
                    op1(26 downto 0)& op1(31 downto 27) when"101",
                    op1(25 downto 0)& op1(31 downto 26) when"110",
                    op1(24 downto 0)& op1(31 downto 25) when"111",
                    op1 when others;
                    
with shiftamount select
    Rsrightrotate<= op1(0)& op1(31 downto 1) when"001",
                    op1(1 downto 0)& op1(31 downto 2) when "010",
                    op1(2 downto 0)& op1(31 downto 3) when "011",
                    op1(3 downto 0)& op1(31 downto 4) when "100",
                    op1(4 downto 0)& op1(31 downto 5) when "101",
                    op1(5 downto 0)& op1(31 downto 6) when "110",
                    op1(6 downto 0)& op1(31 downto 7) when "111",
                    op1 when others;
                    
with shiftamount select
    Rs_Rtrightrotate<=Rs_Rt(0)& Rs_Rt(31 downto 1) when"001",
                      Rs_Rt(1 downto 0)& Rs_Rt(31 downto 2) when "010",
                      Rs_Rt(2 downto 0)& Rs_Rt(31 downto 3) when "011",
                      Rs_Rt(3 downto 0)& Rs_Rt(31 downto 4) when "100",
                      Rs_Rt(4 downto 0)& Rs_Rt(31 downto 5) when "101",
                      Rs_Rt(5 downto 0)& Rs_Rt(31 downto 6) when "110",
                      Rs_Rt(6 downto 0)& Rs_Rt(31 downto 7) when "111",
                      Rs_Rt when others;
                      
with aluop(2 downto 0 )select
          alucalculate<= op1 and op2 when"000",
                        op1 or op2 when"001",
                        op1 nor op2 when"010",
                        xorleftrotate when "011",
                        Rsrightrotate xor op2 when "100",
                        Rsleftrotate + op2 when"101",
                       Rs_Rtrightrotate when"110",
                        x"00000000" when others;
aluresult<= alucalculate;
--process(clk,rst,aluop)
--begin
--    if(rst='1') then
--       aluresult<=x"00000000";
--    --elsif(clk'event and clk='1') then
--    else
--        case aluop is
--            when"000" =>aluresult<= op1 and op2;
--            when"001"=>aluresult<= op1 or op2;
--            when"010"=>aluresult<= op1 nor op2;
--            when "011"=>aluresult<=xorleftrotate;
--             when "100"=>aluresult<=Rsrightrotate xor op2;
--             when "101"=>aluresult<=Rsleftrotate + op2;
--             when "110"=>aluresult<= Rs_Rtrightrotate;
--             --when "111"=>aluresult<= Rs_Rtrightrotate;
--             when others=>aluresult<=x"00000000";
--         end case;
--    end if;
--end process;       
                 
end Behavioral;

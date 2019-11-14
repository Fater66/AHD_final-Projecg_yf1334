----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/14 13:38:21
-- Design Name: 
-- Module Name: Top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
  Port ( 
        clk: in std_logic;
        rst: in std_logic       
    );
end Top;

architecture Behavioral of Top is
signal pc_next_top: std_logic_vector(31 downto 0);
signal pc_current_test: std_logic_vector(31 downto 0);
signal addressout_top: std_logic_vector(31 downto 0);
component pc port(
         clk			 : in std_logic;
		 reset			 : in std_logic;
		 pc_current      : in std_logic_vector(31 downto 0);--current should come from the mux
		 pc_next         : out std_logic_vector(31 downto 0)
		 );
end component;
component Imem port(
        PCin: in std_logic_vector(31 downto 0);
        rst: in std_logic;
        clk: in std_logic;
        addressout: out std_logic_vector(31 downto 0)
        );
end component;
begin
u_pc: pc port map(
    clk=>clk,
    reset=>rst,
    pc_current=>pc_current_test,
    pc_next=>pc_next_top
    );
u_Imem: Imem port map(
    clk=>clk,
    rst=>rst,
    PCin=>pc_next_top,
    addressout=>addressout_top
    );
    
process(rst,clk)
begin
    if(rst='1')then
        pc_current_test<=x"00000000";
    end if;
end process;
    --elsif(clk'event and clk='1')then
        
     

end Behavioral;

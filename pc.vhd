library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity pc is
  	 port(
		 clk			 : in std_logic;
		 reset			 : in std_logic;
		 --Isjump          : in std_logic;
		 pc_current      : in std_logic_vector(31 downto 0);
		 pc_next         : out std_logic_vector(31 downto 0)
	 );
end pc;

architecture Behavioral of pc is

begin
process(clk,reset)
begin 
    if(reset='1') then
        pc_next <= x"00000000";
    elsif(clk'event and clk='1') then
--        if(Isjump='1')then 
--            pc_next<= pc_current
        pc_next <= pc_current;--+ x"00000004";
    end if;
end process;
end Behavioral;

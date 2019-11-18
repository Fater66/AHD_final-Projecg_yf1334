library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity pc is
  	 port(
		 clk			 : in std_logic;
		 reset			 : in std_logic;
		 Isjump          : in std_logic;
		 Ishalt          :in std_logic;
		 Isbranch        : in std_logic_vector(1 downto 0);
		 pc_jump         : in std_logic_vector(31 downto 0);
		 pc_branch      : in std_logic_vector(31 downto 0);
		 pc_plus4      : in std_logic_vector(31 downto 0);
		 pc_out         : out std_logic_vector(31 downto 0)
	 );
end pc;

architecture Behavioral of pc is
signal pc_inside: std_logic_vector(31 downto 0);
begin
pc_out<=pc_inside;
process(clk,reset)
begin 
    if(reset='1') then
        pc_inside <= x"00000000";
    elsif(clk'event and clk='1') then
        if(Isjump='1')then 
            pc_inside<= pc_jump; --jump or branch
        elsif (Isbranch="00" or Isbranch="01" or Isbranch="10") then
            pc_inside<= pc_branch;
        elsif (Ishalt='1')then
            pc_inside<=pc_inside;
        else
            pc_inside <= pc_plus4;--+ x"00000004";
        end if;
    end if;
end process;
end Behavioral;

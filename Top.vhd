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
use IEEE.std_logic_unsigned.all;
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
--pc
signal pc_current_top: std_logic_vector(31 downto 0);
signal pc_plus4_top: std_logic_vector(31 downto 0);
signal pc_branch_top: std_logic_vector(31 downto 0):= x"00000000";
signal pc_jump_top: std_logic_vector(31 downto 0):= x"00000000";
signal Isjump_top: std_logic:='0';
signal Isbranch_top:std_logic_vector(1 downto 0):="11";
signal branch_addr: std_logic_vector(31 downto 0):= x"00000000";
signal jump_addr: std_logic_vector(31 downto 0):= x"00000000";
--imem
signal addressout_top: std_logic_vector(31 downto 0);
signal instruction_top: std_logic_vector(31 downto 0);
signal MemtoReg_top: std_logic;
signal MemWrite_top: std_logic;
signal ALUOP_top: STD_LOGIC_VECTOR(2 DOWNTO 0); 
signal ALUSrc_top :  STD_LOGIC;
signal RegDst_top : STD_LOGIC;
signal RegWrite_top: STD_LOGIC;
signal Rot_Amount_top: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal mux2_out:std_logic_vector(4 downto 0);
signal result: std_logic_vector(31 downto 0);
signal readdata1_top: std_logic_vector(31 downto 0);
signal readdata2_top: std_logic_vector(31 downto 0);
signal SignImm: std_logic_vector(31 downto 0);
--signal SrcA: std_logic_vector(31 downto 0);
signal SrcB: std_logic_vector(31 downto 0);
signal aluresult_top: STD_LOGIC_VECTOR (31 downto 0);
signal readdata_top: std_logic_vector(31 downto 0);
signal ishalt_top: std_logic;
--signal isJump_top: std_logic;
signal signAddress: std_logic_vector(31 downto 0);


component pc port(
		 clk			 : in std_logic;
		 reset			 : in std_logic;
		 Isjump          : in std_logic;
		 Ishalt          :in std_logic;
		 Isbranch        : in std_logic_vector(1 downto 0);
		 pc_jump         : in std_logic_vector(31 downto 0);
		 pc_branch      : in std_logic_vector(31 downto 0);
		 pc_plus4      : in std_logic_vector(31 downto 0);
		 pc_out         : out std_logic_vector(31 downto 0);
		 read_data1     : in std_logic_vector(31 downto 0);
		 read_data2     :in std_logic_vector(31 downto 0)
		 );
end component;
component Imem port(
        PCin: in std_logic_vector(31 downto 0);
        rst: in std_logic;
        clk: in std_logic;
        addressout: out std_logic_vector(31 downto 0);
        ishalt: out std_logic
        );
end component;
component CU port(
        Instr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemtoReg    : OUT STD_LOGIC;
        MemWrite    : OUT STD_LOGIC;
        --Branch      : INOUT STD_LOGIC;
        --PCSrc       : OUT STD_LOGIC;
        IsBranch    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);     -- 2-bit Branch Signal for ALU
        ALUOP       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     -- 4-bit ALU Control for ALU
        ALUSrc      : OUT STD_LOGIC;
        RegDst      : OUT STD_LOGIC;
        RegWrite    : OUT STD_LOGIC;
        IsJump      : OUT STD_LOGIC;
        --Rot_Amount_In   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rot_Amount  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        --Jump        : OUT STD_LOGIC;
        );
end component;
component RF port(
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
 end component;     
component mux2 port(
    x,y : in STD_LOGIC_VECTOR(4 DOWNTO 0);
    s: in STD_LOGIC;
    z: out STD_LOGIC_VECTOR(4 DOWNTO 0) 
    );
end component;
 component sign_extender_16to32 port(
    i_to_extend : in std_logic_vector(15 downto 0);
  	o_extended : out std_logic_vector(31 downto 0)
  	);
end component;
component sign_extender_26to32 port(
   i_to_extend : in std_logic_vector(25 downto 0);
   o_extended : out std_logic_vector(31 downto 0)
   );
end component;
component mux3 port(
    x,y : in STD_LOGIC_VECTOR(31 DOWNTO 0);
    s: in STD_LOGIC;
    z: out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;
component ALU port(
           clk: in STD_LOGIC;
           rst: in STD_LOGIC;
           op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           shiftamount:in STD_LOGIC_VECTOR(2 downto 0);
           aluop : in STD_LOGIC_VECTOR (2 downto 0);
           aluresult : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component;
component dmem port(
        wrtenable: in std_logic;--"10" write,"01" read
        clk: in std_logic;
        rst: in std_logic;
        addr: in std_logic_vector(31 downto 0);--32byte data
        wrtdata: in std_logic_vector(31 downto 0);
        readdata: out std_logic_vector(31 downto 0)
        );
end component;
component mux4 port(
    x,y : in STD_LOGIC_VECTOR(31 DOWNTO 0);
    s: in STD_LOGIC;
    z: out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;


begin
u_pc: pc port map(
   clk=>clk,
   reset=>rst,
   Isjump=>Isjump_top,
   Ishalt=>Ishalt_top,
   Isbranch=>Isbranch_top,
   pc_jump=>pc_jump_top,
   pc_branch=>pc_branch_top,
   pc_plus4=>pc_plus4_top,
   pc_out=>pc_current_top,
   read_data1 =>  readdata1_top,
   read_data2 =>  readdata2_top
    );
u_Imem: Imem port map(
    clk=>clk,
    rst=>rst,
    PCin=>pc_current_top,
    addressout=>instruction_top,
    ishalt=>ishalt_top
    );
u_CU: CU port map(
    Instr=>instruction_top,
    MemtoReg=>MemtoReg_top,
    MemWrite=>MemWrite_top,
    ALUOP=>ALUOP_top,
    ALUSrc=>ALUSrc_top,
    RegDst=>RegDst_top,
    RegWrite=>RegWrite_top,
    IsJump=>IsJump_top,
    IsBranch=>Isbranch_top,
    Rot_Amount=>Rot_Amount_top
    );
u_RF: RF port map(
    clk=>clk,
    rst=>rst,
    instr=>instruction_top,
    A3=>MUX2_out,
    regwrt=>RegWrite_top,
    wrtdata=>result,
    readdata1=>readdata1_top,
    readdata2=>readdata2_top
    );
u_mux2: mux2 port map(
    s=>RegDst_top,
    x=> instruction_top(20 downto 16),
    y=> instruction_top(15 downto 11),
    z=>mux2_out
    );  
u_sign_extender_16to32:sign_extender_16to32 port map(
     i_to_extend=>instruction_top(15 downto 0),
     o_extended=>SignImm
     );
u_jump_signextender_address:sign_extender_26to32 port map(
     i_to_extend=>instruction_top(25 downto 0),
     o_extended=>signAddress
     );
u_mux3:mux3 port map(
    x=>readdata2_top,
    y=>SignImm,
    z=>SrcB,
    s=>ALUSRC_top
    );
u_ALU: ALU port map(
    clk=>clk,
    rst=>rst,
    op1=>readdata1_top,
    op2=>SrcB,
    shiftamount=>instruction_top(8 downto 6),
    aluop=>ALUOP_top,
    aluresult=>aluresult_top
    );
u_dmem:dmem port map(
    clk=>clk,
    rst=>rst,
    wrtenable=>MemWrite_top,
    addr=>aluresult_top,
    wrtdata=>readdata2_top,
    readdata=>readdata_top
    );
u_mux4:mux4 port map(
    x=>aluresult_top,
    y=>readdata_top,
    s=>MemtoReg_top,
    z=>result
    );      
--pc+4    
with pc_current_top select
pc_plus4_top<=x"00000004" when x"00000000",
              pc_current_top+"100" when others;
--pc_current_top+"100";
--branch addr
branch_addr<= pc_plus4_top+(SignImm(29 downto 0)&"00");   
--jump addr
jump_addr<= pc_plus4_top+(signAddress(29 downto 0)&"00");

pc_branch_top<=branch_addr;
pc_jump_top<= jump_addr;

--process(rst,clk)
--begin
--    if(rst='1')then
--        pc_out<=x"00000000";
--        pc_next<=x"00000000";
--    elsif(ishalt_top='0') then
--        if(clk'event and clk='1') then
--            if (isJump_top = '0') then
--                pc_out<=pc_next;
--                pc_next<=pc_out+x"00000004";
--                --pc_current_test<=pc_current_test+x"00000004";               
--           else
--                pc_out <=  pc_out + x"00000004"+(signAddress(29 downto 0) & "00");
--                pc_next<=pc_out+x"00000004";
--                --isJump_top <='0';
--           end if;
--        end if;
--    else
--        pc_out<=pc_out;
----        else
----            pc_current_test<=pc_current_test;
--        end if;
--    --end if;
--end process;
    --elsif(clk'event and clk='1')then
--process(rst,clk)
--begin
--    if(rst='1')then
--        pc_current_test<=x"00000000";
--    elsif(rising_edge(clk)) then
--             if (isJump_top = '0') then pc_current_test <= pc_current_test + x"00000004";
--             else 
--                pc_current_test <=  pc_current_test + x"00000004"+(signAddress(29 downto 0) & "00");
--             end if;
--    end if;
--end process;        
     

end Behavioral;

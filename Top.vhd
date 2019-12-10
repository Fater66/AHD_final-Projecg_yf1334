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
        clr: in std_logic;
        sw: in std_logic_vector(15 downto 0);   
        led: out std_logic_vector(15 downto 0);
        BTNU: in std_logic; --ukey input begin/end
        BTNR: in std_logic; --ukey&din input seperate
        BTNL: in std_logic; --din input  begin/end
        --BTNC: in std_logic; --din sepetate
        BTND: in std_logic; -- enc or dec select
        SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
        SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0)    
    );
end Top;

architecture Behavioral of Top is
signal clk50: std_logic;
signal clrinside: std_logic;
--input
       type s_type is(state0, state1, state2, state3, state4, state5, state6, state7, state8);
              signal stateukey : s_type;
       type s_type2 is(state0, state1, state2, state3, state4);
              signal statedin : s_type2;
signal ukey: std_logic_vector(127 downto 0);
signal ukeyready: std_logic;
signal ukeycount: std_logic_vector(1 downto 0);
signal dinready: std_logic;
signal dincount: std_logic_vector(1 downto 0);
signal din: std_logic_vector(63 downto 0);
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
signal ALUOP_top: STD_LOGIC_VECTOR(3 DOWNTO 0); 
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
--RF out
signal dout_top:std_logic_vector(31 downto 0);

--component clk_wiz_0 port(
--    clk_in1: in std_logic;
--    reset: in std_logic;
--    clk_out1: out std_logic
--    );
--end component;
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
         BTND            :in std_logic;
         sw             : in std_logic_vector(15 downto 0);
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
        ALUOP       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);     -- 4-bit ALU Control for ALU
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
        dout: out std_logic_vector(31 downto 0);
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
           aluop : in STD_LOGIC_VECTOR (3 downto 0);
           aluresult : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component;
component dmem port(
        wrtenable: in std_logic;--"10" write,"01" read
        clk: in std_logic;
        rst: in std_logic;
        addr: in std_logic_vector(31 downto 0);--32byte data
        ukey: in std_logic_vector(127 downto 0);
        ukeyready: in std_logic;
        din: in std_logic_vector(63 downto 0);
        dinready: in std_logic;
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
component SevenSeg_Top port(
           CLK 			: in  STD_LOGIC;
           data_in      : in   STD_LOGIC_VECTOR (31 downto 0);
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0)
           );
end component;
begin
clrinside<=not clr;
clk50<=clk;
--u_clock: clk_wiz_0 port map(
--    clk_in1=>clk,
--    reset=>clrinside,
--    clk_out1=>clk50
--    );
u_pc: pc port map(
   clk=>clk50,
   reset=>clrinside,
   Isjump=>Isjump_top,
   Ishalt=>Ishalt_top,
   Isbranch=>Isbranch_top,
   pc_jump=>pc_jump_top,
   pc_branch=>pc_branch_top,
   pc_plus4=>pc_plus4_top,
   pc_out=>pc_current_top,
   BTND=>BTND,
   sw=>sw,
   read_data1 =>  readdata1_top,
   read_data2 =>  readdata2_top
    );
u_Imem: Imem port map(
    clk=>clk50,
    rst=>clrinside,
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
    clk=>clk50,
    rst=>clrinside,
    instr=>instruction_top,
    A3=>MUX2_out,
    regwrt=>RegWrite_top,
    wrtdata=>result,
    dout=>dout_top,
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
    clk=>clk50,
    rst=>clrinside,
    op1=>readdata1_top,
    op2=>SrcB,
    shiftamount=>instruction_top(8 downto 6),
    aluop=>ALUOP_top,
    aluresult=>aluresult_top
    );
u_dmem:dmem port map(
    clk=>clk50,
    rst=>clrinside,
    wrtenable=>MemWrite_top,
    addr=>aluresult_top,
    ukey=>ukey,
    ukeyready=>ukeyready,
    din=>din,
    dinready=>dinready,
    wrtdata=>readdata2_top,
    readdata=>readdata_top
    );
u_mux4:mux4 port map(
    x=>aluresult_top,
    y=>readdata_top,
    s=>MemtoReg_top,
    z=>result
    );
u_sevenSeg: SevenSeg_Top port map(
    clk=>clk50,  
    data_in=>dout_top(31 downto 0),
    SSEG_CA=>SSEG_CA,
    SSEG_AN=>SSEG_AN
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

--ukey input
ukeycounterinitial: process(clr,BTNU,BTNL)
begin
    if(clrinside='1') then 
        ukeycount<="00";
    --elsif(clk50' event and clk50='1') then
     elsif ((BTNL='0')and (BTNU='1')) then
       case ukeycount is
        when"00"=> ukeycount<="01";
        when"01"=> ukeycount<="10";
        when others=>ukeycount<="10";
       end case;
    end if;
   --end if;
end process;

ukeyFSM: process(clr,ukeycount,BTNR,clk50)
    begin
        if(clrinside='1') then
            stateukey<=state0;ukey<=x"00000000000000000000000000000000";LED(0)<='0';ukeyready<='0';LED(15)<='0';
        elsif(clk50' event and clk50='1') then
            if(ukeycount="01")then
            case stateukey is  
                when state0=> if BTNR='1' then stateukey<=state1;ukey(15 downto 0)<=sw; end if;
                when state1=> if BTNR='1' then stateukey<=state2;ukey(31 downto 16)<=sw; end if;
                when state2=> if BTNR='1' then stateukey<=state3;ukey(47 downto 32)<=sw; end if;
                when state3=> if BTNR='1' then stateukey<=state4;ukey(63 downto 48)<=sw; end if;
                when state4=> if BTNR='1' then stateukey<=state5;ukey(79 downto 64)<=sw; end if;
                when state5=> if BTNR='1' then stateukey<=state6;ukey(95 downto 80)<=sw; end if;
                when state6=> if BTNR='1' then stateukey<=state7;ukey(111 downto 96)<=sw; end if;
                when state7=> if BTNR='1' then stateukey<=state8;ukey(127 downto 112)<=sw;LED(0)<='1';LED(15)<='1';ukeyready<='1'; end if;--ukey ready
                when state8=> if BTNR='1' then ukeyready<='0'; LED(0)<='0'; end if;
            end case;
         end if;
       end if;
     end process;
     
dincounterinitial: process(clr,ukeycount,BTNU,BTNL)
    begin
       if(clrinside='1') then 
        dincount<="00";
    --elsif(clk50' event and clk50='1') then
     elsif ((BTNL='1')and (BTNU='0')) then
       case dincount is
        when"00"=> dincount<="01";
        when"01"=> dincount<="10";
        when others=>dincount<="10";
       end case;
     end if;
   -- end if;
end process;

dinFSM: process(clr,dincount,BTNR,clk50)
    begin
        if(clrinside='1') then
            statedin<=state0;din<=x"0000000000000000";LED(0)<='0';dinready<='0';LED(14)<='0';
        elsif(clk50' event and clk50='1') then
            if(dincount="01")then
            case statedin is  
                when state0=> if BTNR='1' then statedin<=state1;din(15 downto 0)<=sw; end if;
                when state1=> if BTNR='1' then statedin<=state2;din(31 downto 16)<=sw; end if;
                when state2=> if BTNR='1' then statedin<=state3;din(47 downto 32)<=sw; end if;
                when state3=> if BTNR='1' then statedin<=state3;din(63 downto 48)<=sw;LED(1)<='1';LED(14)<='1';dinready<='1'; end if;--dinready
                when state4=> if BTNR='1' then LED(1)<='0';dinready<='0'; end if;             
            end case;
         end if;
       end if;
     end process;
end Behavioral;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CU IS
    PORT(
        Instr       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --OPCODE      : IN STD_LOGIC_VECTOR(5 DOWNTO 0); 
        --FUNC        : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        MemtoReg    : OUT STD_LOGIC;
        MemWrite    : OUT STD_LOGIC;
        Branch      : INOUT STD_LOGIC;
        PCSrc       : OUT STD_LOGIC;
        IsBranch    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);     -- 2-bit Branch Signal for ALU
        ALUOP       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     -- 4-bit ALU Control for ALU
        ALUSrc      : OUT STD_LOGIC;
        RegDst      : OUT STD_LOGIC;
        RegWrite    : OUT STD_LOGIC;
        IsJump      : OUT STD_LOGIC;
        --IsBranch    : OUT STD_LOGIC;
        --Rot_Amount_In   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rot_Amount  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        --Jump        : OUT STD_LOGIC;
    );
END CU;

ARCHITECTURE Behavioral OF CU IS

SIGNAL OPCODE   : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL FUNC     : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL IsRType  : STD_LOGIC;
--SIGNAL IsBranch : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL ANDI     : STD_LOGIC;
SIGNAL ORI      : STD_LOGIC;
SIGNAL LW       : STD_LOGIC;
SIGNAL SW       : STD_LOGIC;
SIGNAL BLT      : STD_LOGIC;
SIGNAL BEQ      : STD_LOGIC;
SIGNAL BNE      : STD_LOGIC;
SIGNAL JMP      : STD_LOGIC;
SIGNAL HLT      : STD_LOGIC;
--SIGNAL InFun    : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN
    
OPCODE      <=  Instr(31 DOWNTO 26);
FUNC        <=  Instr(5 DOWNTO 0);
Rot_Amount  <=  Instr(9 DOWNTO 7);
--IsRType <=  '1' WHEN OPCODE = "000000" ELSE '0';
ANDI    <=  '1' WHEN OPCODE = "000011" ELSE '0';
ORI     <=  '1' WHEN OPCODE = "000100" ELSE '0';
LW      <=  '1' WHEN OPCODE = "000111" ELSE '0';
SW      <=  '1' WHEN OPCODE = "001000" ELSE '0';
BLT     <=  '1' WHEN OPCODE = "001001" ELSE '0';
BEQ     <=  '1' WHEN OPCODE = "001010" ELSE '0';
BNE     <=  '1' WHEN OPCODE = "001011" ELSE '0';
JMP     <=  '1' WHEN OPCODE = "001100" ELSE '0';
IsJump  <= JMP;         --jump judge
--Isbranch<= BEQ or BNE;
HLT     <=  '1' WHEN OPCODE = "111111" ELSE '0';
RegDst      <=  IsRType;                        --When R Type, RegDst is 1 else 0
ALUSrc      <=  ANDI OR ORI OR LW OR SW;        --When I Type,  ALUSrc is 1 else 0.
Branch      <=  BLT OR BEQ OR BNE;              --When is Branch, Branch -> 1
PCSrc       <=  Branch AND '0';                 --PCSrc = Branch AND 'Zero'
RegWrite    <=  IsRType OR ANDI OR ORI OR LW;   --Double Check!!!
MemToReg    <=  LW;
MemWrite    <=  SW;

--InFun   <=  FUNC(5 DOWNTO 0);
with opcode select
    Isbranch<="00" when "001001",
               "01"when "001010",
               "10" when "001011",
               "11" when others;
PROCESS(OPCODE, FUNC)  --ALUOP SELECTION
BEGIN    
    IF (OPCODE = "000000") THEN
        IsRType <= '1';
        CASE FUNC IS
            WHEN "010010" =>
                ALUOP   <=  "000"; --AND
            WHEN "010011" =>
                ALUOP   <=  "001"; --OR
            WHEN "010100" =>
                ALUOP   <=  "010"; --NOR
            WHEN "010000" =>
                ALUOP   <=  "011"; --XRLR
            WHEN "010001" =>
                ALUOP   <=  "100"; --RRXR
            WHEN "010101" =>
                ALUOP   <=  "101"; --LRAD
            WHEN "010110" =>
                ALUOP   <=  "110"; --SBRR
            WHEN OTHERS =>
                ALUOP   <=  "111"; --HALT
        END CASE;
    ELSIF (OPCODE = "000011" ) THEN    --ANDI 
        IsRType <=  '0';
        ALUOP   <=  "000";  --ALUOP 000 = ADD
--    ELSIF (OPCODE = "001100") THEN    --JUMP
--        IsRType <=  '0';
--        ALUOP   <=  "000";
--    ELSIF (OPCODE = "001001") THEN  --BLT
--        IsRType     <=  '0';
--        IsBranch    <=  "00";
--        ALUOP       <=  "000";
--    ELSIF (OPCODE = "001010") THEN  --BEQ
--        IsRType     <=  '0';
--        IsBranch    <=  "01";
--        ALUOP       <=  "000";
--    ELSIF (OPCODE = "001011") THEN  --BNE
--        IsRType     <=  '0';
--        IsBranch    <=  "10";
--        ALUOP       <=  "000";
    ELSIF (OPCODE = "000100") THEN  --ORI
        IsRType <=  '0';
        ALUOP   <=  "001";  --ALUOP 001 = OR
    ELSIF (OPCODE = "111111") THEN  --HALT
        IsRType <=  '0';
        ALUOP   <=  "111";  --ALUOP 111 = HALT
    ELSIF (OPCODE = "000111" OR OPCODE = "001000") THEN --LW \\ SW
        IsRType <=  '0';
        ALUOP   <=  "001";  --ALUOP 111 = HALT
    END IF;
END PROCESS;

END Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderFD is
  port ( 
		opcode 	: in std_logic_vector(5 DOWNTO 0);
		tipoR	 	: out std_logic;
		saida		: out std_logic_vector(7 DOWNTO 0)
  ); 
end entity;

architecture arquitetura of decoderFD is

	constant INST_AND : std_logic_vector(5 downto 0) := "000000";
	constant INST_OR  : std_logic_vector(5 downto 0) := "000000";
	constant ADD 		: std_logic_vector(5 downto 0) := "000000";
	constant SUB 		: std_logic_vector(5 downto 0) := "000000";
	constant SLT 		: std_logic_vector(5 downto 0) := "000000";
	constant LW 		: std_logic_vector(5 downto 0) := "100011";
	constant SW 		: std_logic_vector(5 downto 0) := "101011";
	constant BEQ 		: std_logic_vector(5 downto 0) := "000100";
	constant JMP 		: std_logic_vector(5 downto 0) := "000010";

	alias MUX_PC_BEQ 	: std_logic is saida(7);
	alias MUX_RT_RD 	: std_logic is saida(6);
	alias HAB_REG	  	: std_logic is saida(5);
	alias MUX_RT_IM  	: std_logic is saida(4);
	alias MUX_ULA_MEM	: std_logic is saida(3);
	alias BEQ_CTRL		: std_logic is saida(2);
	alias RD_MEM		: std_logic is saida(1);
	alias WR_MEM		: std_logic is saida(0);

begin

	MUX_PC_BEQ 	<= '1' when (opcode = JMP) else '0';
	MUX_RT_RD 	<= '1' when (opcode = INST_AND OR opcode = INST_OR OR opcode = ADD OR opcode = SUB OR opcode = SLT) else '0';
	HAB_REG 		<= '1' when (opcode = INST_AND OR opcode = INST_OR OR opcode = ADD OR opcode = SUB OR opcode = SLT OR opcode = LW ) else '0';
	MUX_RT_IM 	<= '1' when (opcode = LW OR opcode = SW) else '0';
	MUX_ULA_MEM <= '1' when (opcode = LW ) else '0';
	BEQ_CTRL 	<= '1' when (opcode = BEQ) else '0';
	RD_MEM 		<= '1' when (opcode = LW) else '0';
	WR_MEM 		<= '1' when (opcode = SW) else '0';
	tipoR 		<= '1' when (opcode = INST_AND OR opcode = INST_OR OR opcode = ADD OR opcode = SUB OR opcode = SLT) else '0';


end architecture;

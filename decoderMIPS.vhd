library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderMIPS is
  port ( 
		opcode 	: in std_logic_vector(5 DOWNTO 0);
		funct	 	: in std_logic_vector(5 DOWNTO 0);
		ula_ctrl : out std_logic_vector(3 DOWNTO 0);
		palavra	: out std_logic_vector(7 DOWNTO 0)
  );
  
end entity;

architecture arquitetura of decoderMIPS is

	signal TIPO_R				 	: std_logic;
	signal ULA_CTRL_FUNCT  		: std_logic_vector(3 DOWNTO 0);
	signal ULA_CTRL_OPCODE 		: std_logic_vector(3 DOWNTO 0);
	signal SAIDA_MUX_ULA_CTRL 	: std_logic_vector(3 DOWNTO 0);
	signal SAIDA_DECODER_FD		: std_logic_vector(7 DOWNTO 0);
	
begin

-- Decoder funct p/ ULACtrl
ULA_CTRL_FUNCT(3) <= '0';
ULA_CTRL_FUNCT(2) <= '1' when (funct = 6x"22" OR funct = 6x"2A") else '0';
ULA_CTRL_FUNCT(1) <= '1' when (funct = 6x"20" OR funct = 6x"22" OR funct = 6x"2A") else '0';
ULA_CTRL_FUNCT(0) <= '1' when (funct = 6x"25" OR funct = 6x"2A") else '0';

-- Decoder opcode p/ ULACtrl
ULA_CTRL_OPCODE(3) <= '0';
ULA_CTRL_OPCODE(2) <= '1' when (opcode = 6x"04") else '0';
ULA_CTRL_OPCODE(1) <= '1' when (opcode = 6x"04" OR opcode = 6x"2B" OR opcode = 6x"23") else '0';
ULA_CTRL_OPCODE(0) <= '0';

MUX_ULA_CTRL : entity work.muxGenerico2x1 generic map(larguraDados => 4)
	port map(
		entradaA_MUX => ULA_CTRL_OPCODE,
		entradaB_MUX => ULA_CTRL_FUNCT,
		seletor_MUX =>  TIPO_R,
		saida_MUX => SAIDA_MUX_ULA_CTRL
	);
	
CONTROL_UNIT : entity work.decoderFD 
	port map(
		opcode 	=> opcode,
		tipoR	 	=> TIPO_R,
		saida		=> SAIDA_DECODER_FD
	);

ula_ctrl <= SAIDA_MUX_ULA_CTRL;
	
palavra <= SAIDA_DECODER_FD;
end architecture;
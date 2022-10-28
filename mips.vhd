library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
  generic (
		simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE 
  );
  port (  
		CLOCK_50			 	: in std_logic;
		HABILITA_BANREG 	: in std_logic;
		KEY					: in std_logic_vector(3 DOWNTO 0);
		OPERACAO_ULA		: in std_logic
  );
	
end entity;


architecture arquitetura of mips is

	signal SIG_CLK			  	: std_logic;
	signal SIG_RD	 			: std_logic_vector(4 DOWNTO 0);
	signal SIG_RS			 	: std_logic_vector(4 DOWNTO 0);
	signal SIG_RT			 	: std_logic_vector(4 DOWNTO 0);
	signal SIG_INCPC_TO_PC 	: std_logic_vector(31 DOWNTO 0);
	signal SIG_PC_OUT      	: std_logic_vector(31 DOWNTO 0);
	signal SIG_ROM_OUT     	: std_logic_vector(31 DOWNTO 0);
	signal SIG_ULA_OUT	  	: std_logic_vector(31 DOWNTO 0);
	signal SIG_BAN_OUT_REGA	: std_logic_vector(31 DOWNTO 0);
	signal SIG_BAN_OUT_REGB	: std_logic_vector(31 DOWNTO 0);
	

begin

gravar: if simulacao generate
	
	SIG_CLK <= KEY(0);
	
else generate

	SIG_CLK <= CLOCK_50;

end generate;

PC: entity work.registradorGenerico generic map(larguraDados => 32)
		port map(
			DIN => SIG_INCPC_TO_PC,
			DOUT =>	SIG_PC_OUT,
			ENABLE =>'1',
			CLK => SIG_CLK,
			RST => '0'
		);

INCREMENTA_PC : entity work.somaConstante generic map(larguraDados => 32, constante => 32)
		port map(
			entrada => SIG_PC_OUT,
			saida => SIG_INCPC_TO_PC
		);
		
ROM : entity work.ROM generic map(dataWidth => 32, addrWidth => 32, memoryAddrWidth => 6)
		port map (
			Endereco => SIG_PC_OUT,
			Dado => SIG_ROM_OUT
		);
		
BANREG : entity work.bancoReg generic map(larguraDados => 32, larguraEndBancoRegs => 5)
		port map (
			clk => SIG_CLK,
			enderecoA => SIG_RS,  
			enderecoB => SIG_RT, 
			enderecoC => SIG_RD, 
			dadoEscritaC => SIG_ULA_OUT,
			escreveC => HABILITA_BANREG,
			saidaA => SIG_BAN_OUT_REGA,
			saidaB => SIG_BAN_OUT_REGB
		);
		
ULA : entity work.ULASomaSub generic map(larguraDados => 32)
		port map (
			entradaA => SIG_BAN_OUT_REGA,
			entradaB => SIG_BAN_OUT_REGB,
			seletor => OPERACAO_ULA,
			saida => SIG_ULA_OUT
		);
		

SIG_RD <= SIG_ROM_OUT(15 DOWNTO 11);
SIG_RS <= SIG_ROM_OUT(25 DOWNTO 21);
SIG_RT <= SIG_ROM_OUT(20 DOWNTO 16);

end architecture;

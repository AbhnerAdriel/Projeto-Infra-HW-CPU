--------------------------------------------------------------------------------
-- Title		: Registrador de Deslocamento
-- Project		: CPU Multi-ciclo
--------------------------------------------------------------------------------
-- File			: RegDesloc.vhd
-- Author		: Emannuel Gomes Macêdo <egm@cin.ufpe.br>
--				  Fernando Raposo Camara da Silva <frcs@cin.ufpe.br>
--				  Pedro Machado Manhães de Castro <pmmc@cin.ufpe.br>
--				  Rodrigo Alves Costa <rac2@cin.ufpe.br>
-- Organization : Universidade Federal de Pernambuco
-- Created		: 10/07/2002
-- Last update	: 26/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade responsável pelo deslocamento de um vetor de 32 
--                bits para a direita e para a esquerda. 
--				  Entradas:
--				  	* N: vetor de 5 bits que indica a quantidade de 
--					deslocamentos   
--				  	* Shift: vetor de 3 bits que indica a função a ser 
--					realizada pelo registrador   
--				  Abaixo seguem os valores referentes à entrada shift e as 
--                respectivas funções do registrador: 
--				  
--				  Shift					FUNÇÃO DO REGISTRADOR
--				  000					faz nada
--				  001					carrega vetor (sem deslocamentos)
--				  010					deslocamento à esquerda n vezes
--				  011					deslocamento à direita lógico n vezes
--				  100					deslocamento à direita aritmético n vezes
--				  101					rotação à direita n vezes
--				  110					rotação à esquerda n vezes
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 2
-- Revision Number	: 2.0
-- Version			: 1.2
-- Date				: 26/11/2002
-- Modifier			: Marcus Vinicius Lima e Machado <mvlm@cin.ufpe.br>
--				  	  Paulo Roberto Santana Oliveira Filho <prsof@cin.ufpe.br>
--					  Viviane Cristina Oliveira Aureliano <vcoa@cin.ufpe.br>
-- Description		:
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 3
-- Revision Number	: 1.2
-- Version			: 1.3
-- Date				: 08/08/2008
-- Modifier			: João Paulo Fernandes Barbosa (jpfb@cin.ufpe.br)
-- Description		: Os sinais de entrada e saída passam a ser do tipo std_logic.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Short name: desl
ENTITY RegDesloc IS
		PORT(
			Clk		: IN	STD_LOGIC;	-- Clock do sistema
		 	Reset	: IN	STD_LOGIC;	-- Reset
			Shift 	: IN	STD_LOGIC_vector (2 downto 0);	-- Função a ser realizada pelo registrador 
			N		: IN	STD_LOGIC_vector (4 downto 0);	-- Quantidade de deslocamentos
			Entrada : IN	STD_LOGIC_vector (31 downto 0);	-- Vetor a ser deslocado
			Saida	: OUT	STD_LOGIC_vector (31 downto 0)	-- Vetor deslocado
		);
END RegDesloc;

-- Arquitetura que define o comportamento do registrador de deslocamento
-- Simulation
ARCHITECTURE behavioral_arch OF RegDesloc IS
	
	signal temp		: STD_LOGIC_vector (31 downto 0);	-- Vetor temporário
	
	begin

	-- Clocked process
	process (Clk, Reset)
		begin
			if(Reset = '1') then
				temp <= "00000000000000000000000000000000";

			elsif (Clk = '1' and Clk'event) then
				case Shift is
					when "000" => 						-- Faz nada
						temp <= temp;
					when "001" => 						-- Carrega vetor de entrada, não faz deslocamentos
						temp <= Entrada;
					when "010" =>						-- Deslocamento à esquerda N vezes
						case N is
							when "00000" =>				-- Deslocamento à esquerda nenhuma vez
								temp <= temp;
							when "00001" =>				-- Deslocamento à esquerda 1 vez
								temp(0) <= '0';
								temp(31 downto 1) <= temp(30 downto 0);
							when "00010" =>				-- Deslocamento à esquerda 2 vezes
								temp(1 downto 0) <= "00";
								temp(31 downto 2) <= temp(29 downto 0);
							when "00011" =>				-- Deslocamento à esquerda 3 vezes
								temp(2 downto 0) <= "000";
								temp(31 downto 3) <= temp(28 downto 0);
							when "00100" =>				-- Deslocamento à esquerda 4 vezes
								temp(3 downto 0) <= "0000";
								temp(31 downto 4) <= temp(27 downto 0);
							when "00101" =>				-- Deslocamento à esquerda 5 vezes
								temp(4 downto 0) <= "00000";
								temp(31 downto 5) <= temp(26 downto 0);
							when "00110" =>				-- Deslocamento à esquerda 6 vezes
								temp(5 downto 0) <= "000000";
								temp(31 downto 6) <= temp(25 downto 0);
							when "00111" =>				-- Deslocamento à esquerda 7 vezes
								temp(6 downto 0) <= "0000000";
								temp(31 downto 7) <= temp(24 downto 0);
                                                        when "01000" =>                         -- e assim sucessivamente...
								temp(7 downto 0) <= "00000000";
								temp(31 downto 8) <= temp(23 downto 0);
							when "01001" =>
								temp(8 downto 0) <= "000000000";
								temp(31 downto 9) <= temp(22 downto 0);
							when "01010" =>
								temp(9 downto 0) <= "0000000000";
								temp(31 downto 10) <= temp(21 downto 0);
							when "01011" =>
								temp(10 downto 0) <= "00000000000";
								temp(31 downto 11) <= temp(20 downto 0);
							when "01100" =>
								temp(11 downto 0) <= "000000000000";
								temp(31 downto 12) <= temp(19 downto 0);
							when "01101" =>
								temp(12 downto 0) <= "0000000000000";
								temp(31 downto 13) <= temp(18 downto 0);
							when "01110" =>
								temp(13 downto 0) <= "00000000000000";
								temp(31 downto 14) <= temp(17 downto 0);
							when "01111" =>
								temp(14 downto 0) <= "000000000000000";
								temp(31 downto 15) <= temp(16 downto 0);
							when "10000" =>
								temp(15 downto 0) <= "0000000000000000";
								temp(31 downto 16) <= temp(15 downto 0);
							when "10001" =>
								temp(16 downto 0) <= "00000000000000000";
								temp(31 downto 17) <= temp(14 downto 0);
							when "10010" =>
								temp(17 downto 0) <= "000000000000000000";
								temp(31 downto 18) <= temp(13 downto 0);
							when "10011" =>
								temp(18 downto 0) <= "0000000000000000000";
								temp(31 downto 19) <= temp(12 downto 0);
							when "10100" =>
								temp(19 downto 0) <= "00000000000000000000";
								temp(31 downto 20) <= temp(11 downto 0);
							when "10101" =>
								temp(20 downto 0) <= "000000000000000000000";
								temp(31 downto 21) <= temp(10 downto 0);
							when "10110" =>
								temp(21 downto 0) <= "0000000000000000000000";
								temp(31 downto 22) <= temp(9 downto 0);
							when "10111" =>
								temp(22 downto 0) <= "00000000000000000000000";
								temp(31 downto 23) <= temp(8 downto 0);
							when "11000" =>
								temp(23 downto 0) <= "000000000000000000000000";
								temp(31 downto 24) <= temp(7 downto 0);
							when "11001" =>
								temp(24 downto 0) <= "0000000000000000000000000";
								temp(31 downto 25) <= temp(6 downto 0);
							when "11010" =>
								temp(25 downto 0) <= "00000000000000000000000000";
								temp(31 downto 26) <= temp(5 downto 0);
							when "11011" =>
								temp(26 downto 0) <= "000000000000000000000000000";
								temp(31 downto 27) <= temp(4 downto 0);
							when "11100" =>
								temp(27 downto 0) <= "0000000000000000000000000000";
								temp(31 downto 28) <= temp(3 downto 0);
							when "11101" =>
								temp(28 downto 0) <= "00000000000000000000000000000";
								temp(31 downto 29) <= temp(2 downto 0);
							when "11110" =>
								temp(29 downto 0) <= "000000000000000000000000000000";
								temp(31 downto 30) <= temp(1 downto 0);
							when "11111" =>
								temp(30 downto 0) <= "0000000000000000000000000000000";
								temp(31) <= temp(0);
							
							when others =>
								temp <= temp;
							end case;

					-- Deslocamento à direita lógico N vezes
					when "011" =>						
						case n is
							when "00000" =>				-- Deslocamento à direita lógico nenhuma vez
								temp <= temp;
							when "00001" =>				-- Deslocamento à direita lógico 1 vez
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= '0';
							when "00010" =>				-- Deslocamento à direita lógico 2 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(31 downto 30) <= "00";
							when "00011" =>				-- Deslocamento à direita lógico 3 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(31 downto 29) <= "000";
							when "00100" =>				-- Deslocamento à direita lógico 4 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(31 downto 28) <= "0000";
							when "00101" =>				-- Deslocamento à direita lógico 5 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(31 downto 27) <= "00000";
							when "00110" =>				-- Deslocamento à direita lógico 6 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(31 downto 26) <= "000000";
							when "00111" =>				-- Deslocamento à direita lógico 7 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(31 downto 25) <= "0000000";
							when "01000" =>				-- Deslocamento à direita lógico 8 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(31 downto 24) <= "00000000";
							when "01001" =>				-- Deslocamento à direita lógico 9 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(31 downto 23) <= "000000000";
							when "01010" =>				-- Deslocamento à direita lógico 10 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(31 downto 22) <= "0000000000";
							when "01011" =>				-- Deslocamento à direita lógico 11 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(31 downto 21) <= "00000000000";
							when "01100" =>				-- Deslocamento à direita lógico 12 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(31 downto 20) <= "000000000000";
							when "01101" =>				-- Deslocamento à direita lógico 13 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(31 downto 19) <= "0000000000000";
							when "01110" =>				-- Deslocamento à direita lógico 14 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(31 downto 18) <= "00000000000000";
							when "01111" =>				-- Deslocamento à direita lógico 15 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(31 downto 17) <= "000000000000000";
							when "10000" =>				-- Deslocamento à direita lógico 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(31 downto 16) <= "0000000000000000";
							when "10001" =>				-- Deslocamento à direita lógico 17 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(31 downto 15) <= "00000000000000000";
							when "10010" =>				-- Deslocamento à direita lógico 18 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(31 downto 14) <= "000000000000000000";
							when "10011" =>				-- Deslocamento à direita lógico 19 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(31 downto 13) <= "0000000000000000000";
							when "10100" =>				-- Deslocamento à direita lógico 20 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(31 downto 12) <= "00000000000000000000";
							when "10101" =>				-- Deslocamento à direita lógico 21 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(31 downto 11) <= "000000000000000000000";
							when "10110" =>				-- Deslocamento à direita lógico 22 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(31 downto 10) <= "0000000000000000000000";
							when "10111" =>				-- Deslocamento à direita lógico 23 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(31 downto 9) <= "00000000000000000000000";
							when "11000" =>				-- Deslocamento à direita lógico 24 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(31 downto 8) <= "000000000000000000000000";
							when "11001" =>				-- Deslocamento à direita lógico 25 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(31 downto 7) <= "0000000000000000000000000";
							when "11010" =>				-- Deslocamento à direita lógico 26 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(31 downto 6) <= "00000000000000000000000000";
							when "11011" =>				-- Deslocamento à direita lógico 27 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(31 downto 5) <= "000000000000000000000000000";
							when "11100" =>				-- Deslocamento à direita lógico 28 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(31 downto 4) <= "0000000000000000000000000000";
							when "11101" =>				-- Deslocamento à direita lógico 29 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(31 downto 3) <= "00000000000000000000000000000";
							when "11110" =>				-- Deslocamento à direita lógico 30 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(31 downto 2) <= "000000000000000000000000000000";
							when "11111" =>				-- Deslocamento à direita lógico 31 vezes
								temp(0) <= temp(31);
								temp(31 downto 1) <= "0000000000000000000000000000000";
						when others =>
							temp <= temp;
						end case;

					-- Deslocamento à direita aritmético N vezes
					when "100" =>						
						case n is
							when "00000" =>				-- Deslocamento à direita aritmético nenhuma vez
								temp <= temp;
							when "00001" =>				-- Deslocamento à direita aritmético 1 vezes
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= temp(31);
							when "00010" =>				-- Deslocamento à direita aritmético 2 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00011" =>				-- Deslocamento à direita aritmético 3 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00100" =>				-- Deslocamento à direita aritmético 4 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00101" =>				-- Deslocamento à direita aritmético 5 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00110" =>				-- Deslocamento à direita aritmético 6 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00111" =>				-- Deslocamento à direita aritmético 7 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01000" =>				-- Deslocamento à direita aritmético 8 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01001" =>				-- Deslocamento à direita aritmético 9 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01010" =>				-- Deslocamento à direita aritmético 10 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01011" =>				-- Deslocamento à direita aritmético 11 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01100" =>				-- Deslocamento à direita aritmético 12 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01101" =>				-- Deslocamento à direita aritmético 13 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01110" =>				-- Deslocamento à direita aritmético 14 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01111" =>				-- Deslocamento à direita aritmético 15 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);

							when "10000" =>				-- Deslocamento à direita aritmético 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10001" =>				-- Deslocamento à direita aritmético 17 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10010" =>				-- Deslocamento à direita aritmético 18 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10011" =>				-- Deslocamento à direita aritmético 19 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10100" =>				-- Deslocamento à direita aritmético 20 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10101" =>				-- Deslocamento à direita aritmético 21 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10110" =>				-- Deslocamento à direita aritmético 22 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10111" =>				-- Deslocamento à direita aritmético 23 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(9) <= temp(31);
								temp(10) <= temp(31);				
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11000" =>				-- Deslocamento à direita aritmético 24 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11001" =>				-- Deslocamento à direita aritmético 25 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11010" =>				-- Deslocamento à direita aritmético 26 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11011" =>				-- Deslocamento à direita aritmético 27 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11100" =>				-- Deslocamento à direita aritmético 28 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11101" =>				-- Deslocamento à direita aritmético 29 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(3) <= temp(31);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11110" =>				-- Deslocamento à direita aritmético 30 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(2) <= temp(31);
								temp(3) <= temp(31);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11111" =>				-- Deslocamento à direita aritmético 31 vezes
								temp(0) <= temp(31);
								temp(1) <= temp(31);
								temp(2) <= temp(31);
								temp(3) <= temp(31);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
						when others =>
							temp <= temp;
						end case;

					-- Rotação à direita N vezes
					when "101" =>						
						case n is
							when "00000" =>				-- Rotação à direita nenhuma vez
								temp <= temp;
							when "00001" =>				-- Rotação à direita 1 vez
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= temp(0);
							when "00010" =>				-- Rotação à direita 2 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(31 downto 30) <= temp(1 downto 0);
							when "00011" =>				-- Rotação à direita 3 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(31 downto 29) <= temp(2 downto 0);
							when "00100" =>				-- Rotação à direita 4 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(31 downto 28) <= temp(3 downto 0);
							when "00101" =>				-- Rotação à direita 5 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(31 downto 27) <= temp(4 downto 0);
							when "00110" =>				-- Rotação à direita 6 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(31 downto 26) <= temp(5 downto 0);
							when "00111" =>				-- Rotação à direita 7 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(31 downto 25) <= temp(6 downto 0);
							when "01000" =>				-- Rotação à direita 8 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(31 downto 24) <= temp(7 downto 0);
							when "01001" =>				-- Rotação à direita 9 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(31 downto 23) <= temp(8 downto 0);
							when "01010" =>				-- Rotação à direita 10 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(31 downto 22) <= temp(9 downto 0);
							when "01011" =>				-- Rotação à direita 11 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(31 downto 21) <= temp(10 downto 0);
							when "01100" =>				-- Rotação à direita 12 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(31 downto 20) <= temp(11 downto 0);
							when "01101" =>				-- Rotação à direita 13 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(31 downto 19) <= temp(12 downto 0);
							when "01110" =>				-- Rotação à direita 14 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(31 downto 18) <= temp(13 downto 0);
							when "01111" =>				-- Rotação à direita 15 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(31 downto 17) <= temp(14 downto 0);
							when "10000" =>				-- Rotação à direita 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(31 downto 16) <= temp(15 downto 0);
							when "10001" =>				-- Rotação à direita 17 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(31 downto 15) <= temp(16 downto 0);
							when "10010" =>				-- Rotação à direita 18 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(31 downto 14) <= temp(17 downto 0);
							when "10011" =>				-- Rotação à direita 19 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(31 downto 13) <= temp(18 downto 0);
							when "10100" =>				-- Rotação à direita 20 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(31 downto 12) <= temp(19 downto 0);
							when "10101" =>				-- Rotação à direita 21 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(31 downto 11) <= temp(20 downto 0);
							when "10110" =>				-- Rotação à direita 22 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(31 downto 10) <= temp(21 downto 0);
							when "10111" =>				-- Rotação à direita 23 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(31 downto 9) <= temp(22 downto 0);
							when "11000" =>				-- Rotação à direita 24 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(31 downto 8) <= temp(23 downto 0);
							when "11001" =>				-- Rotação à direita 25 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(31 downto 7) <= temp(24 downto 0);
							when "11010" =>				-- Rotação à direita 26 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(31 downto 6) <= temp(25 downto 0);
							when "11011" =>				-- Rotação à direita 27 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(31 downto 5) <= temp(26 downto 0);
							when "11100" =>				-- Rotação à direita 28 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(31 downto 4) <= temp(27 downto 0);
							when "11101" =>				-- Rotação à direita 29 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(31 downto 3) <= temp(28 downto 0);
							when "11110" =>				-- Rotação à direita 30 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(31 downto 2) <= temp(29 downto 0);
							when "11111" =>				-- Rotação à direita 31 vezes
								temp(0) <= temp(31);
								temp(31 downto 1) <= temp(30 downto 0);
						when others =>
							temp <= temp;
						end case;

					-- Rotação à esquerda N vezes
					when "110" =>						
						case n is
							when "00000" =>				-- Rotação à esquerda nenhuma vez
								temp <= temp;
							when "00001" =>				-- Rotação à esquerda 1 vez
								temp(0) <= temp(31);
								temp(31 downto 1) <= temp(30 downto 0);
							when "00010" =>				-- Rotação à esquerda 2 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(31 downto 2) <= temp(29 downto 0);
							when "00011" =>				-- Rotação à esquerda 3 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(31 downto 3) <= temp(28 downto 0);
							when "00100" =>				-- Rotação à esquerda 4 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(31 downto 4) <= temp(27 downto 0);
							when "00101" =>				-- Rotação à esquerda 5 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(31 downto 5) <= temp(26 downto 0);
							when "00110" =>				-- Rotação à esquerda 6 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(31 downto 6) <= temp(25 downto 0);
							when "00111" =>				-- Rotação à esquerda 7 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(31 downto 7) <= temp(24 downto 0);
							when "01000" =>				-- Rotação à esquerda 8 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(31 downto 8) <= temp(23 downto 0);
							when "01001" =>				-- Rotação à esquerda 9 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(31 downto 9) <= temp(22 downto 0);
							when "01010" =>				-- Rotação à esquerda 10 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(31 downto 10) <= temp(21 downto 0);
							when "01011" =>				-- Rotação à esquerda 11 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(31 downto 11) <= temp(20 downto 0);
							when "01100" =>				-- Rotação à esquerda 12 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(31 downto 12) <= temp(19 downto 0);
							when "01101" =>				-- Rotação à esquerda 13 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(31 downto 13) <= temp(18 downto 0);
							when "01110" =>				-- Rotação à esquerda 14 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(31 downto 14) <= temp(17 downto 0);
							when "01111" =>				-- Rotação à esquerda 15 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(31 downto 15) <= temp(16 downto 0);
							when "10000" =>				-- Rotação à esquerda 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(31 downto 16) <= temp(15 downto 0);
							when "10001" =>				-- Rotação à esquerda 17 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(31 downto 17) <= temp(14 downto 0);
							when "10010" =>				-- Rotação à esquerda 18 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(31 downto 18) <= temp(13 downto 0);
							when "10011" =>				-- Rotação à esquerda 19 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(31 downto 19) <= temp(12 downto 0);
							when "10100" =>				-- Rotação à esquerda 20 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(31 downto 20) <= temp(11 downto 0);
							when "10101" =>				-- Rotação à esquerda 21 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(31 downto 21) <= temp(10 downto 0);
							when "10110" =>				-- Rotação à esquerda 22 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(31 downto 22) <= temp(9 downto 0);
							when "10111" =>				-- Rotação à esquerda 23 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(31 downto 23) <= temp(8 downto 0);
							when "11000" =>				-- Rotação à esquerda 24 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(31 downto 24) <= temp(7 downto 0);
							when "11001" =>				-- Rotação à esquerda 25 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(31 downto 25) <= temp(6 downto 0);
							when "11010" =>				-- Rotação à esquerda 26 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(31 downto 26) <= temp(5 downto 0);
							when "11011" =>				-- Rotação à esquerda 27 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(31 downto 27) <= temp(4 downto 0);
							when "11100" =>				-- Rotação à esquerda 28 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(31 downto 28) <= temp(3 downto 0);
							when "11101" =>				-- Rotação à esquerda 29 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(31 downto 29) <= temp(2 downto 0);
							when "11110" =>				-- Rotação à esquerda 30 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(31 downto 30) <= temp(1 downto 0);
							when "11111" =>				-- Rotação à esquerda 31 vezes
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= temp(0);
						when others =>
							temp <= temp;
						end case;

					-- Funcionalidade não definida
					when others =>
					-- Faz nada					
				end case;
			end if;
			Saida <= temp;	
	end process;
END behavioral_arch;


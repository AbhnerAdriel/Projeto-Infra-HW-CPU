module uControl(
		//inputs
		input clk,
		output reg reset,
		input eqf,
		input gtf,
		input ov,
		input div0,
		input [5:0] funct,
		input [5:0] opCode,
		//outputs
		output reg MemCtrl,
		output reg PCCtrl,
		output reg MDCtrl,
		output reg SECtrl,
		output reg ShiftSrc,
		output reg ShiftAmt,
		output reg IRWrite,
		output reg RegWrite,
		output reg ALUOutCtrl,
		output reg EPCCtrl,
		output reg HILOWrite,
		output reg [1:0] IorD,
		output reg [1:0] ALUSrcA,
		output reg [1:0] ALUSrcB,
		output reg [1:0] RegDst,
		output reg [1:0] LSCtrl,
		output reg [1:0] SSCtrl,
		output reg [1:0] ExcptCtrl,
		output reg [2:0] ShiftCtrl,
		output reg [2:0] PCSrc,
		output reg [2:0] ALUCtrl,
		output reg [3:0] DataSrc,
		output reg start
		//output reg [4:0] currentState
);

	initial begin
		MemCtrl = 0;
		PCCtrl = 0;
		MDCtrl = 0;
		SECtrl = 0;
		ShiftSrc = 0;
		ShiftAmt = 0;
		IRWrite = 0;
		RegWrite = 0;
		ALUOutCtrl = 0;
		EPCCtrl = 0;
		HILOWrite = 0;
		IorD = 2'b00;
		ALUSrcA = 2'b00;
		ALUSrcB = 2'b00;
		RegDst = 2'b00;
		LSCtrl = 2'b00;
		SSCtrl = 2'b00;
		ExcptCtrl = 2'b00;
		ShiftCtrl = 3'b000;
		PCSrc = 3'b000;
		reset = 1;
		ALUCtrl = 3'b000;
		DataSrc = 4'b0000;
		currentState = stateSTART;
	end

	//Defines
	//United states
	parameter stateSTART				= 5'b00000;
	parameter stateSHIFT				= 5'b00001;
	parameter stateSSAVE				= 5'b00010;
	parameter stateRESULT			= 5'b00011;
	parameter stateRSAVE				= 5'b00100;
	parameter stateISAVE				= 5'b00101;
	parameter stateJR					= 5'b00110;
	parameter stateBREAK				= 5'b00111;
	parameter stateSLT				= 5'b01000;
	parameter stateJAL				= 5'b01001;
	parameter stateWAIT				= 5'b01010;
	parameter stateLS					= 5'b01011;
	parameter stateMEMWAIT			= 5'b01100;
	parameter stateHILO				= 5'b01101;
	parameter stateMEM				= 5'b01110;
	parameter stateBEQM				= 5'b01111;
	parameter stateBEQM2				= 5'b10000;
	parameter stateBRANCH			= 5'b10001;
	parameter stateEXCP				= 5'b10010;
	parameter stateOF					= 5'b10011;
	parameter stateDIV0				= 5'b10100;			
	parameter stateOPCODE			= 5'b10101;
	parameter stateEXCP2				= 5'b10110;
	parameter stateEXCP3				= 5'b10111;
	parameter stateEXCP4				= 5'b11000;
	parameter stateOP					= 5'b11001;
	parameter stateSTART2			= 5'b11010;
	parameter stateSTART3			= 5'b11011;
	parameter stateSTART4			= 5'b11100;
	parameter stateSTART5			= 5'b11101;
	parameter stateBRANCH2				= 5'b11110;
	parameter stateMEMWAIT2				= 5'b11111;
	//Valores para ALUCtrl
	parameter ulaSA 					= 3'b000;
	parameter ulaADD 					= 3'b001;
	parameter ulaSUB 					= 3'b010;
	parameter ulaAND 					= 3'b011;
	//Valores para as operaçoes
	//FORMATO R
	parameter ADD 						= 	{ 1'b0, 6'b100000 };
	parameter AND 						= 	{ 1'b0, 6'b100100 };
	parameter DIV 						= 	{ 1'b0, 6'b011010 };
	parameter MULT						= 	{ 1'b0, 6'b011000 };
	parameter JR 						= 	{ 1'b0, 6'b001000 };
	parameter MFHI 					= 	{ 1'b0, 6'b010000 };
	parameter MFLO 					= 	{ 1'b0, 6'b010010 };
	parameter SLL						=	{ 1'b0, 6'b000000 };
	parameter SLLV						=	{ 1'b0, 6'b000100 };
	parameter SLT						=	{ 1'b0, 6'b101010 };
	parameter SRA						=	{ 1'b0, 6'b000011 };
	parameter SRAV						=	{ 1'b0, 6'b000111 };
	parameter SRL 						=	{ 1'b0, 6'b000010 };
	parameter SUB 						= 	{ 1'b0, 6'b100010 };
	parameter BREAK 					=	{ 1'b0, 6'b001101 };
	parameter RTE						=	{ 1'b0, 6'b010011 };
	//FORMATO I
	parameter ADDI 					= 	{ 1'b1, 6'b001000 };
	parameter ADDIU 					= 	{ 1'b1, 6'b001001 };
	parameter BEQ 						= 	{ 1'b1, 6'b000100 };
	parameter BNE						= 	{ 1'b1, 6'b000101 };
	parameter BLE 						= 	{ 1'b1, 6'b000110 };
	parameter BGT	 					= 	{ 1'b1, 6'b000111	};
	parameter BEQM 					= 	{ 1'b1, 6'b000001 };
	parameter LB						=	{ 1'b1, 6'b100000 };
	parameter LH						=	{ 1'b1, 6'b100001 };
	parameter LUI						=	{ 1'b1, 6'b001111 };
	parameter LW						=	{ 1'b1, 6'b100011	};
	parameter SB						=	{ 1'b1, 6'b101000 };
	parameter SH 						=	{ 1'b1, 6'b101001 };
	parameter SLTI						= 	{ 1'b1, 6'b001010	};
	parameter SW	 					=	{ 1'b1, 6'b101011 };
	//FORMATO J
	parameter J							=	{ 1'b1, 6'b000010	};
	parameter JAL						=	{ 1'b1, 6'b000011	};

	//Variables
	reg [6:0] op;
	reg [4:0] currentState;
	reg op404;
	reg mwait = 0;
	reg BEQMCtrl = 0;
	reg BEQMCtrl2 = 0;
	reg qwe = 0;
	reg [7:0] counter = 0;
	reg mdrFlag = 0;

	always @ (posedge clk or posedge reset) begin
		if(reset) begin
			reset = 0;
			MemCtrl = 0;
			PCCtrl = 0;
			MDCtrl = 0;
			SECtrl = 0;
			ShiftSrc = 0;
			ShiftAmt = 0;
			IRWrite = 0;
			RegWrite = 0;
			ALUOutCtrl = 0;
			EPCCtrl = 0;
			HILOWrite = 0;
			IorD = 2'b00;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b00;
			RegDst = 2'b00;
			LSCtrl = 2'b00;
			SSCtrl = 2'b00;
			ExcptCtrl = 2'b00;
			ShiftCtrl = 3'b000;
			PCSrc = 3'b000;
			ALUCtrl = 3'b000;
			DataSrc = 4'b0000;
		end
		else begin
			op = !opCode ? {1'b0, funct} : {1'b1, opCode};
			case (currentState)
				stateSTART:
				begin
					PCCtrl = 0;
					MDCtrl = 0;
					SECtrl = 0;
					ShiftSrc = 0;
					ShiftAmt = 0;
					IRWrite = 0;
					RegWrite = 0;
					ALUOutCtrl = 0;
					EPCCtrl = 0;
					HILOWrite = 0;
					RegDst = 2'b00;
					LSCtrl = 2'b00;
					SSCtrl = 2'b00;
					ExcptCtrl = 2'b00;
					ShiftCtrl = 3'b000;
					PCSrc = 3'b000;
					DataSrc = 4'b0000;
					IorD = 2'b00;
					MemCtrl = 1'b0;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b01;
					ALUCtrl = 3'b001;
					currentState = stateSTART2;
				end
				stateSTART2:
				begin
					currentState = stateSTART3;
				end
				stateSTART3:
				begin
					PCSrc = 3'b000;
					PCCtrl = 1'b1;
					IRWrite = 1'b1;
					SECtrl = 1'b0;
					currentState = stateSTART4;
				end
				stateSTART4:
				begin
					PCCtrl = 1'b0;
					IRWrite = 0;
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b11;
					ALUCtrl = 3'b001;
					currentState = stateSTART5;
				end
				stateSTART5:
				begin
					ALUOutCtrl = 1'b1;
					currentState = stateOP;
				end
				stateSHIFT:
				begin
					case (op)
						SLL, SLLV:
						begin
							ShiftCtrl = 3'b010;
						end
						SRA, SRAV:
						begin
							ShiftCtrl = 3'b100;
						end
						SRL:
						begin
							ShiftCtrl = 3'b011;
						end
					endcase
					currentState = stateSSAVE;
				end
				stateSSAVE:
				begin
					ShiftCtrl = 3'b000;
					DataSrc = 4'b1000;
					RegDst = 2'b01;
					RegWrite = 1'b1;
					currentState = stateWAIT;
				end
				stateRESULT:
				begin
					ALUOutCtrl = 1'b1;
					case (op)
						ADD, SUB, AND:
						begin
							if(ov) currentState = stateEXCP;
							else currentState = stateRSAVE;
						end
						ADDI, ADDIU:
						begin
							if(ov) currentState = stateEXCP;
							currentState = stateISAVE;
						end
						JAL:
						begin
							currentState = stateJAL;
						end
						LB, LH, LW, SB, SH, SW:
						begin 
							currentState = stateMEM;
						end
					endcase
				end
				stateRSAVE:
				begin
					DataSrc = 4'b0000;
					RegDst = 2'b01;
					RegWrite = 1'b1;
					currentState = stateWAIT;
				end
				stateISAVE:
				begin
					DataSrc = 4'b0000;
					RegDst = 2'b00;
					RegWrite = 1'b1;
					currentState = stateWAIT;
				end
				stateJR, stateBREAK:
				begin
					PCSrc = 3'b000;
					PCCtrl = 1'b1;
					currentState = stateWAIT;
				end
				stateSLT:
				begin
					DataSrc = 4'b0100;
					RegDst = 2'b01;
					RegWrite = 1'b1;
					currentState = stateWAIT;
				end
				stateJAL:
				begin
					DataSrc = 4'b0000;
					RegWrite = 1'b1;
					RegDst = 2'b11;
					PCSrc = 3'b010;
					PCCtrl = 1'b1;
					currentState = stateWAIT;
				end
				stateWAIT:
				begin
					PCCtrl = 0;
					currentState = stateSTART;
				end
				stateLS:
				begin
					case (op)
						LB:
						begin
							LSCtrl = 2'b00;
							RegDst = 2'b00;
							DataSrc = 4'b0001;
							RegWrite = 1'b1;
						end
						LH:
						begin
							LSCtrl = 2'b01;
							RegDst = 2'b00;
							DataSrc = 4'b0001;
							RegWrite = 1'b1;
						end
						LW:	
						begin
							LSCtrl = 2'b10;
							RegDst = 2'b00;
							DataSrc = 4'b0001;
							RegWrite = 1'b1;
						end
						SB:
						begin
							SSCtrl = 2'b00;
							MemCtrl =  1'b1;
							IorD = 2'b10;
						end
						SH:
						begin
							SSCtrl = 2'b01;
							MemCtrl =  1'b1;
							IorD = 2'b10;
						end
						SW:
						begin
							SSCtrl = 2'b10;
							MemCtrl =  1'b1;
							IorD = 2'b10;
							
						end
					endcase
					if(mwait) begin
						currentState = stateLS;
						mwait = 0;
					end
					else begin 
						currentState = stateWAIT;
						
					end
				end
				stateMEMWAIT2:
				begin
					currentState = stateLS;
					mwait = 1;
				end
				stateMEMWAIT:
				begin
					case (op)
						LB, LH, LW, SB, SH, SW:
						begin
							if(!mwait)
								currentState = stateMEMWAIT2;
							else begin
								currentState = stateMEMWAIT;
								mwait = 0;
							end		
						end
						BEQM:
						begin
							currentState = stateBEQM2;
						end
						DIV, MULT:
						begin
							if(!div0) begin
								start = 0;
								if(counter < 40)
									counter = counter + 1;
								else 
									currentState = stateHILO;
							end
							else currentState = stateEXCP;
						end
					endcase
				end
				stateHILO:
				begin
					HILOWrite = 1'b1;
					currentState = stateWAIT;
				end
				stateMEM:
				begin
					mwait = 1;
					IorD = 2'b10;
					MemCtrl = 1'b0;
					currentState = stateMEMWAIT;
				end
				stateBEQM:
				begin
					ALUOutCtrl = 1'b0;
					IorD = 2'b01;
					MemCtrl = 1'b0;
					currentState = stateMEMWAIT;
				end
				stateBEQM2:
				begin
					if(!BEQMCtrl) begin
						BEQMCtrl = 1;
						LSCtrl = 2'b10;
						ALUSrcA = 2'b10;
						ALUSrcB = 2'b00;
						ALUCtrl = 3'b111;
					end
					else 
					if(BEQMCtrl && !BEQMCtrl2) begin
				BEQMCtrl2 = 1;
				end
					else begin
						if (eqf)
								currentState = stateBRANCH;
						else
								currentState = stateWAIT;
					end
				end
				stateBRANCH:
				begin
					PCSrc = 2'b001;
					PCCtrl = 1'b1;
					currentState = stateWAIT;
				end
				stateEXCP:
				begin
					ALUSrcA = 2'b00;
					ALUSrcB = 2'b01;
					ALUCtrl = 3'b010;
					case (op)
						ADD, SUB, ADDI:
						begin
							currentState = stateOF;
						end
						DIV:
						begin
							currentState = stateDIV0;
						end
						default:
						begin
							currentState = stateOPCODE;
						end
					endcase
				end
				stateOF:
				begin
					EPCCtrl = 1'b1;
					ExcptCtrl = 2'b01;
					MemCtrl = 1'b0; 
					IorD = 2'b11;
					currentState = stateEXCP2;
				end
				stateDIV0:
				begin
					EPCCtrl = 1'b1;
					ExcptCtrl = 2'b10;
					MemCtrl = 1'b0;
					IorD = 2'b11;
					currentState = stateEXCP2;
				end
				stateOPCODE:
				begin
					EPCCtrl = 1'b1;
					ExcptCtrl = 2'b00;
					MemCtrl = 1'b0;
					IorD = 2'b11;
					currentState = stateEXCP2;
				end
				stateEXCP2:
				begin
					if(!mdrFlag) begin
						mdrFlag = 1'b1;
						currentState = stateEXCP2;
					end	
					else begin
						currentState = stateEXCP3;
						mdrFlag = 1'b0;
					end
				end
				stateEXCP3:
				begin
					LSCtrl = 2'b00;
					ALUSrcA = 2'b10;
					ALUCtrl = 3'b000;
					currentState = stateEXCP4;
				end
				stateEXCP4:
				begin
					PCSrc = 3'b000;
					PCCtrl = 1'b1;
					currentState = stateWAIT;
				end
				stateBRANCH2:
				begin
					if (
							(op == BEQ && eqf == 1'b1) || (op == BNE && eqf == 1'b0) ||
							(op == BGT && gtf == 1'b1) || (op == BLE && (eqf == 1'b1 || gtf == 1'b0))
						) currentState = stateBRANCH;
					else
						currentState = stateWAIT;
				end
				//todas as instruções
				stateOP:
				begin
					ALUOutCtrl = 0;
					case (op)
						ADD:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b00;
							ALUCtrl = 3'b001;
							currentState = ov ? stateEXCP : stateRESULT;
						end
						AND:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b00;
							ALUCtrl = ulaAND;
							currentState = stateRESULT;
						end
						DIV:
						begin
							MDCtrl = 1'b1;
							start = 1'b1;
							counter = 0;
							currentState = div0 ? stateEXCP : stateMEMWAIT;
						end
						MULT:
						begin
							MDCtrl = 1'b0;
							start = 1'b1;
							counter = 0;
							currentState = stateMEMWAIT;
						end
						JR:
						begin
							ALUSrcA = 2'b01;
							ALUCtrl = ulaSA;
							currentState = stateJR;
						end
						MFHI:
						begin
							DataSrc = 4'b0010;
							RegDst = 2'b01;
							RegWrite = 1'b1;
							currentState = stateWAIT;
						end
						MFLO:
						begin
							DataSrc = 4'b0011;
							RegDst = 2'b01;
							RegWrite = 1'b1;
							currentState = stateWAIT;
						end
						SLL, SRA, SRL:
						begin
							ShiftSrc = 1'b1;
							ShiftAmt = 1'b1;
							ShiftCtrl = 3'b001;
							currentState = stateSHIFT;
						end
						SLLV, SRAV:
						begin
							ShiftSrc = 1'b0;
							ShiftAmt = 1'b0;
							ShiftCtrl = 3'b001;
							currentState = stateSHIFT;
						end
						SLT:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 1'b00;
							ALUCtrl = 3'b111;
							currentState = stateSLT;
						end
						SUB:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b00;
							ALUCtrl = ulaSUB;
							currentState = ov ? stateEXCP : stateRESULT;
						end
						BREAK:
						begin
							ALUSrcA = 2'b00;
							ALUSrcB = 2'b01;
							ALUCtrl = 3'b010;
							currentState = stateBREAK;
						end
						RTE:
						begin
							PCSrc = 3'b100;
							PCCtrl = 1'b1;
							currentState = stateWAIT;
						end
						ADDI:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b10;
							SECtrl = 1'b1;
							ALUCtrl = 3'b001;
							currentState = ov ? stateEXCP : stateRESULT;
						end
						ADDIU:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b10;
							SECtrl = 1'b0;
							ALUCtrl = 3'b001;
							currentState = stateRESULT;
						end
						BEQ, BNE, BLE, BGT:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b00;
							ALUCtrl = 3'b111;
							currentState = stateBRANCH2;
							
						end
						BEQM:
						begin
							ALUSrcA = 2'b01;
							ALUOutCtrl = 1'b0;
							ALUCtrl = 3'b000;
							currentState = stateBEQM;
						end
						LB, LH, LW, SB, SH, SW:
						begin
							ALUSrcA = 2'b01;
							ALUSrcB = 2'b10;
							SECtrl = 1'b0;
							ALUCtrl = 3'b001;
							currentState = stateRESULT;
						end
						LUI:
						begin
							DataSrc = 4'b0110;
							RegDst = 2'b00;
							RegWrite = 1'b1;
							currentState = stateWAIT;
						end
						SLTI:
						begin
							SECtrl = 1'b1;
							ALUSrcB = 2'b10;
							ALUSrcA= 2'b01;
							ALUCtrl = 3'b111;
							currentState = stateSLT;
						end
						J:
						begin
							PCSrc = 3'b010;
							PCCtrl = 1'b1;
							currentState = stateWAIT;
						end
						JAL:
						begin
							ALUSrcA = 2'b00;
							ALUCtrl = 3'b000;
							currentState = stateRESULT;
						end
						default:
						begin
							currentState = stateEXCP;
						end
					endcase
				end
			endcase		
		end
	end
endmodule
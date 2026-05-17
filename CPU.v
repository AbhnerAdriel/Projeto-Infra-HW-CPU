module CPU(
		input wire clk,
		input wire reset,
		input wire MemCtrl,
		input wire PCCtrl,
		input wire MDCtrl,
		input wire SECtrl,
		input wire ShiftSrc,
		input wire ShiftAmt,
		input wire ShiftMem,
		input wire IRWrite,
		input wire RegWrite,
		input wire ALUOutCtrl,
		input wire EPCCtrl,
		input wire HILOWrite,
		input wire XchgTempWrite,
		input wire [1:0] IorD,
		input wire [1:0] ALUSrcA,
		input wire [1:0] ALUSrcB,
		input wire [1:0] RegDst,
		input wire [1:0] LSCtrl,
		input wire [1:0] SSCtrl,
		input wire [1:0] ExcptCtrl,
		input wire [1:0] MemAddrCtrl,
		input wire [1:0] MemDataSrc,
		input wire [2:0] ShiftCtrl,
		input wire [2:0] PCSrc,
		input wire [2:0] ALUCtrl,
		input wire [3:0] DataSrc,
		output wire eqf,
		output wire gtf,
		output wire ov,
		output wire div0,
		output wire [5:0] funct,
		output wire [5:0] opCode,
		output wire [31:0] wPCOut,
		output wire [31:0] wALUResult,
		output wire [31:0] wShiftRegOut,
		output wire [31:0] wMemOut,
		input wire start
);

//PC 
wire [31:0] wPCData;
Registrador PC(clk, reset, PCCtrl, wPCData, wPCOut);

//IorD
wire [31:0] wIorD;
wire [31:0] wALUOut;
wire [31:0] wExcep;
mux4to1 IorDMux(wPCOut, wALUResult, wALUOut, wExcep, IorD, wIorD);

//Memoria
wire [31:0] wSSOut;
wire [31:0] wMDROut;
wire [31:0] wAOut;
wire [31:0] wBOut;
reg [31:0] wXchgTemp;
wire [31:0] wMemAddress;
wire [31:0] wMemDataIn;

always @(posedge clk or posedge reset) begin
	if (reset)
		wXchgTemp <= 32'b0;
	else if (XchgTempWrite)
		wXchgTemp <= wMemOut;
end

assign wMemAddress = (reset !== 1'b0) ? 32'b0 :
							(MemAddrCtrl == 2'b01) ? wAOut :
							(MemAddrCtrl == 2'b10) ? wBOut :
														 wIorD;
assign wMemDataIn = (MemDataSrc == 2'b01) ? wXchgTemp :
						  (MemDataSrc == 2'b10) ? wMDROut :
														 wSSOut;

Memoria MEM(wMemAddress, clk, MemCtrl, wMemDataIn, wMemOut);

//Exception Mux
wire [31:0] exc1;
wire [31:0] exc2;
wire [31:0] exc3;
assign exc1 = 32'd253;
assign exc2 = 32'd254;
assign exc3 = 32'd255;
Mux3to1 ExcptCtrlMux(exc1, exc2, exc3, ExcptCtrl, wExcep);

//IR
wire [4:0] rs;
wire [4:0] rt;
wire [15:0] immediate;
assign funct = immediate[5:0];
Instr_Reg IR(clk, reset, IRWrite, wMemOut, opCode, rs, rt, immediate);

//RegDstMux
wire [4:0] rdst3;
wire [4:0] rdst4;
assign rdst3 = 30;
assign rdst4 = 31;
wire [4:0] wRegDstOut;
assign wRegDstOut = (RegDst == 2'b00) ? rt :
                    (RegDst == 2'b01) ? immediate[15:11] :
                    (RegDst == 2'b10) ? rdst3 :
                                         rdst4;

//DataSrcMux
wire [31:0] wLSOut;
wire [31:0] wHIOut;
wire [31:0] wLOOut;
wire [31:0] wSE1Out;
wire [31:0] wSE16Out;
wire [31:0] wSL16Out;
//wire [31:0] wShiftRegOut;
reg [31:0] wDataSrcOut;

always @(*) begin
	case (DataSrc)
		4'b0000: wDataSrcOut = wALUOut;
		4'b0001: wDataSrcOut = wLSOut;
		4'b0010: wDataSrcOut = wHIOut;
		4'b0011: wDataSrcOut = wLOOut;
		4'b0100: wDataSrcOut = wSE1Out;
		4'b0101: wDataSrcOut = wSE16Out;
		4'b0110: wDataSrcOut = wSL16Out;
		4'b0111: wDataSrcOut = wExcep;
		4'b1000: wDataSrcOut = wShiftRegOut;
		4'b1001: wDataSrcOut = wPCOut;
		default: wDataSrcOut = 32'b0;
	endcase
end

//BR
wire [31:0] wA;
wire [31:0] wB;
Banco_reg BR(clk, reset, RegWrite, rs, rt, wRegDstOut, wDataSrcOut, wA, wB);

//RegA
wire loadA;
assign loadA = 1;
Registrador A(clk, reset, loadA, wA, wAOut);

//RegB
wire loadB;
assign loadB = 1;
Registrador B(clk, reset, loadB, wB, wBOut);

//ALUSrcAMux
wire [31:0] wAluSrcAOut;
Mux3to1 ALUSrcAMux(wPCOut, wAOut, wLSOut, ALUSrcA, wAluSrcAOut);

//ALUSrcBMux
wire [31:0] wAluSrcBOut;
wire [31:0] wSL2Out;
wire [31:0] w4;
assign w4 = 32'b00000000000000000000000000000100;
mux4to1 ALUSrcBMux(wBOut, w4, wSE16Out, wSL2Out, ALUSrcB, wAluSrcBOut);

//ULA
wire neg;
wire z;
wire ltf;
ula32 ULA(wAluSrcAOut, wAluSrcBOut, ALUCtrl, wALUResult, ov, neg, z, eqf, gtf, ltf);

//ALUOut
Registrador ALUOut(clk, reset, ALUOutCtrl, wALUResult, wALUOut);

//EPC
wire [31:0] wEPCOut;
Registrador EPC(clk, reset, EPCCtrl, wALUResult, wEPCOut);

//PCSrcMux
wire [27:0] wSL26Out;
wire [31:0] wPCSrc2;
assign wPCSrc2 = {wPCOut[31:28], wSL26Out[27:0]};
Mux5to1 PCSrcMux(wALUResult, wALUOut, wPCSrc2, wLSOut, wEPCOut, PCSrc, wPCData);

//ShiftLeft26
wire [25:0] wSL26In;
assign wSL26In = {rs, rt, immediate};
ShiftLeft26to28 SL26(wSL26In, wSL26Out);

//ShiftLeft32
ShiftLeft2 SL2(wSE16Out, wSL2Out);

//MDR
wire MDRLoad;
assign MDRLoad = 1;
Registrador MDR(clk, reset, MDRLoad, wMemOut, wMDROut);

//StoreSize
StoreSize SS(SSCtrl, wBOut, wMDROut, wSSOut);

//LoadSize
LoadSize LS(LSCtrl, wMDROut, wLSOut);

//MULT/DIV
wire [31:0] wHIIn;
wire [31:0] wLOIn;
DIVMULT DM(wAOut, wBOut, MDCtrl, clk, start, reset, div0, wHIIn, wLOIn);

//HI
Registrador HI(clk, reset, HILOWrite, wHIIn, wHIOut);

//LO
Registrador LO(clk, reset, HILOWrite, wLOIn, wLOOut);

//SignExtend1
SignExtend1to32 SE1(ltf, wSE1Out);

//SignExtend16
SignExtend16to32 SE16(immediate, SECtrl, wSE16Out);

//ShiftLeft16
ShiftLeft16 SL16(immediate, wSL16Out);

//ShiftSrcMux
wire [31:0] wShiftSrcOut;
Mux2to1 ShiftSrcMux(wAOut, wBOut, ShiftSrc, wShiftSrcOut);

//ShiftAmtMux
wire [4:0] wShiftAmtOut;
assign wShiftAmtOut = ShiftMem ? wMDROut[4:0] :
					   (ShiftAmt ? immediate[10:6] : wBOut[4:0]);

//ShiftReg
RegDesloc ShiftReg(clk, reset, ShiftCtrl, wShiftAmtOut, wShiftSrcOut, wShiftRegOut);

endmodule

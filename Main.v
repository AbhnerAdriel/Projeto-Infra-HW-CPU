module Main(
	input wire clk,
	output wire [31:0] wPCOut,
	output wire [31:0] wShiftRegOut,
	output wire [31:0] wALUResult,
	output wire [31:0] wMemOut,
	output wire eqf
);

wire reset;
wire MemCtrl;
wire PCCtrl;
wire MDCtrl;
wire SECtrl;
wire ShiftSrc;
wire ShiftAmt;
wire IRWrite;
wire RegWrite;
wire ALUOutCtrl;
wire EPCCtrl;
wire HILOWrite;
wire [1:0] IorD;
wire [1:0] ALUSrcA;
wire [1:0] ALUSrcB;
wire [1:0] RegDst;
wire [1:0] LSCtrl;
wire [1:0] SSCtrl;
wire [1:0] ExcptCtrl;
wire [2:0] ShiftCtrl;
wire [2:0] PCSrc;
wire [2:0] ALUCtrl;
wire [3:0] DataSrc;
//wire eqf;
wire gtf;
wire ov;
wire div0;
wire [5:0] funct;
wire [5:0] opCode;
wire start;

CPU cpu(clk, reset, MemCtrl, PCCtrl, MDCtrl, SECtrl, ShiftSrc, ShiftAmt, IRWrite, RegWrite, ALUOutCtrl, EPCCtrl, HILOWrite, IorD,
			ALUSrcA, ALUSrcB, RegDst, LSCtrl, SSCtrl, ExcptCtrl, ShiftCtrl, PCSrc, ALUCtrl, DataSrc, eqf, gtf, ov, div0, funct, opCode, wPCOut, wALUResult, wShiftRegOut, wMemOut, start);
			
uControl uc(clk, reset, eqf, gtf, ov, div0, funct, opCode, MemCtrl, PCCtrl, MDCtrl, SECtrl, ShiftSrc, ShiftAmt, IRWrite, RegWrite, ALUOutCtrl, EPCCtrl, HILOWrite, IorD,
			ALUSrcA, ALUSrcB, RegDst, LSCtrl, SSCtrl, ExcptCtrl, ShiftCtrl, PCSrc, ALUCtrl, DataSrc, start);


endmodule 
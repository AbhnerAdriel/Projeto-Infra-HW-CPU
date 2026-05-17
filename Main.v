module Main(
	input wire clk,
	input wire reset,
	output wire [31:0] wPCOut,
	output wire [31:0] wShiftRegOut,
	output wire [31:0] wALUResult,
	output wire [31:0] wMemOut,
	output wire eqf,
	output wire [5:0] wCurrentState
);

wire MemCtrl;
wire PCCtrl;
wire MDCtrl;
wire SECtrl;
wire ShiftSrc;
wire ShiftAmt;
wire ShiftMem;
wire IRWrite;
wire RegWrite;
wire ALUOutCtrl;
wire EPCCtrl;
wire HILOWrite;
wire XchgTempWrite;
wire [1:0] IorD;
wire [1:0] ALUSrcA;
wire [1:0] ALUSrcB;
wire [1:0] RegDst;
wire [1:0] LSCtrl;
wire [1:0] SSCtrl;
wire [1:0] ExcptCtrl;
wire [1:0] MemAddrCtrl;
wire [1:0] MemDataSrc;
wire [2:0] ShiftCtrl;
wire [2:0] PCSrc;
wire [2:0] ALUCtrl;
wire [3:0] DataSrc;
wire gtf;
wire ov;
wire div0;
wire [5:0] funct;
wire [5:0] opCode;
wire start;

CPU cpu(
	.clk(clk),
	.reset(reset),
	.MemCtrl(MemCtrl),
	.PCCtrl(PCCtrl),
	.MDCtrl(MDCtrl),
	.SECtrl(SECtrl),
	.ShiftSrc(ShiftSrc),
	.ShiftAmt(ShiftAmt),
	.ShiftMem(ShiftMem),
	.IRWrite(IRWrite),
	.RegWrite(RegWrite),
	.ALUOutCtrl(ALUOutCtrl),
	.EPCCtrl(EPCCtrl),
	.HILOWrite(HILOWrite),
	.XchgTempWrite(XchgTempWrite),
	.IorD(IorD),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.RegDst(RegDst),
	.LSCtrl(LSCtrl),
	.SSCtrl(SSCtrl),
	.ExcptCtrl(ExcptCtrl),
	.MemAddrCtrl(MemAddrCtrl),
	.MemDataSrc(MemDataSrc),
	.ShiftCtrl(ShiftCtrl),
	.PCSrc(PCSrc),
	.ALUCtrl(ALUCtrl),
	.DataSrc(DataSrc),
	.eqf(eqf),
	.gtf(gtf),
	.ov(ov),
	.div0(div0),
	.funct(funct),
	.opCode(opCode),
	.wPCOut(wPCOut),
	.wALUResult(wALUResult),
	.wShiftRegOut(wShiftRegOut),
	.wMemOut(wMemOut),
	.start(start)
);

uControl uc(
	.clk(clk),
	.reset(reset),
	.eqf(eqf),
	.gtf(gtf),
	.ov(ov),
	.div0(div0),
	.funct(funct),
	.opCode(opCode),
	.MemCtrl(MemCtrl),
	.PCCtrl(PCCtrl),
	.MDCtrl(MDCtrl),
	.SECtrl(SECtrl),
	.ShiftSrc(ShiftSrc),
	.ShiftAmt(ShiftAmt),
	.ShiftMem(ShiftMem),
	.IRWrite(IRWrite),
	.RegWrite(RegWrite),
	.ALUOutCtrl(ALUOutCtrl),
	.EPCCtrl(EPCCtrl),
	.HILOWrite(HILOWrite),
	.XchgTempWrite(XchgTempWrite),
	.IorD(IorD),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.RegDst(RegDst),
	.LSCtrl(LSCtrl),
	.SSCtrl(SSCtrl),
	.ExcptCtrl(ExcptCtrl),
	.MemAddrCtrl(MemAddrCtrl),
	.MemDataSrc(MemDataSrc),
	.ShiftCtrl(ShiftCtrl),
	.PCSrc(PCSrc),
	.ALUCtrl(ALUCtrl),
	.DataSrc(DataSrc),
	.start(start),
	.currentState(wCurrentState)
);

endmodule

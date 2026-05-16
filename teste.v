module teste (
	input wire [31:0] A,
	input wire [31:0] B,
	input wire MDControl,
	input wire clk,
	input wire start,
	input wire reset,
	input wire load,
	output wire [31:0] HI,
	output wire [31:0] LO,
	output wire div0
	);
	
wire [31:0] wDMtoHI;
wire [31:0] wDMtoLO;	
wire [31:0] wHI;
wire [31:0] wLO;

DIVMULT dm(A, B, MDControl, clk, start, reset, div0, wDMtoHI, wDMtoLO);

Registrador RHI(.Clk(clk), .Reset(reset), .Load(load), .Entrada(wDMtoHI), .Saida(wHI));
Registrador RLO(.Clk(clk), .Reset(reset), .Load(load), .Entrada(wDMtoLO), .Saida(wLO));

assign HI = wHI;
assign LO = wLO;

endmodule

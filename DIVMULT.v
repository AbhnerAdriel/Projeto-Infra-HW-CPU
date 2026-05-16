module DIVMULT (
	input wire [31:0] A,
	input wire [31:0] B,
	input wire MDControl,
	input wire clk,
	input wire start,
	input wire reset,
	output wire div0,
	output wire [31:0] HI,
	output wire [31:0] LO
	);

wire [31:0] wMtoHI;
wire [31:0] wMtoLO;
wire [31:0] wDtoHI;
wire [31:0] wDtoLO;

mult m(A, B, clk, start, reset, wMtoHI, wMtoLO);
Div d(A, B, clk, start, reset, wDtoHI, wDtoLO, div0); 

assign HI = (!MDControl) ? wMtoHI : wDtoHI;
assign LO = (!MDControl) ? wMtoLO : wDtoLO;

endmodule

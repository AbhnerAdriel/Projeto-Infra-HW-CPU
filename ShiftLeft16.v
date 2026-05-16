module ShiftLeft16 (
	input [15:0] in, 
	output [31:0] out
	);

assign out = {in, 16'b0};

endmodule

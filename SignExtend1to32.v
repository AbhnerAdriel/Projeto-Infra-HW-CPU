module SignExtend1to32 (
	input in,
	output [31:0] out
	);
	
assign out = {31'b0, in};

endmodule

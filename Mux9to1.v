module Mux9to1 (
	input wire [31:0] in1,
	input wire [31:0] in2,
	input wire [31:0] in3,
	input wire [31:0] in4,
	input wire [31:0] in5,
	input wire [31:0] in6,
	input wire [31:0] in7,
	input wire [31:0] in8,
	input wire [31:0] in9,
	input wire [3:0] control,
	output reg [31:0] out
	);
	
always @(*) begin
	case (control)
		4'b0000: out <= in1;
		4'b0001: out <= in2;
		4'b0010: out <= in3;
		4'b0011: out <= in4;
		4'b0100: out <= in5;
		4'b0101: out <= in6;
		4'b0110: out <= in7;
		4'b0111: out <= in8;
		4'b1000: out <= in9;
		default: out <= out;
	endcase
end

endmodule

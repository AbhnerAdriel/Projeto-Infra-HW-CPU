module Mux5to1 (
	input wire [31:0] in1,
	input wire [31:0] in2,
	input wire [31:0] in3,
	input wire [31:0] in4,
	input wire [31:0] in5,
	input wire [2:0] control,
	output reg [31:0] out
	);
	
always @* begin
	case (control)
		3'b000: out <= in1;
		3'b001: out <= in2;
		3'b010: out <= in3;
		3'b011: out <= in4;
		3'b100: out <= in5;
		default: out <= out;
	endcase
end

endmodule

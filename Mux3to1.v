module Mux3to1 (
	input wire [31:0] in1,
	input wire [31:0] in2,
	input wire [31:0] in3,
	input wire [1:0] control,
	output reg [31:0] out
	);
	
always @* begin
	case (control)
		2'b00: out <= in1;
		2'b01: out <= in2;
		2'b10: out <= in3;
		default: out <= out;
	endcase
end

endmodule

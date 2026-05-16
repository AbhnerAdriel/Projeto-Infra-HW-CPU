module SignExtend16to32 (
	input [15:0] in,
	input SECtrl,
	output reg [31:0] out );
	
	
always @* begin
	case (SECtrl)
		1'b0: out = {16'b0, in};
		1'b1: begin
			if (in[15] == 0) out = {16'b0, in};
			else out = {16'b1111111111111111, in};
		end
	endcase
end

endmodule

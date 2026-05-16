module LoadSize(
	input [1:0] LSCtrl,
	input [31:0] Data,
	output reg [31:0] out
);

always @(*)
begin
	case (LSCtrl)
		2'b00: out <= {24'b0, Data[7:0]};
		2'b01: out <= {16'b0, Data[15:0]};
		2'b10: out <= Data[31:0];
	endcase
end

endmodule

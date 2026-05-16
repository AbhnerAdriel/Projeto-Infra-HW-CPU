module StoreSize(
	input [1:0] SSControl,
	input [31:0] B,
	input [31:0] Data,
	
	output reg [31:0] out
);

always @(*)
begin
	case (SSControl)
		2'b00: out <= {Data[31:8], B[7:0]};
		2'b01: out <= {Data[31:16], B[15:0]};
		2'b10: out <= B[31:0];
	endcase
end

endmodule

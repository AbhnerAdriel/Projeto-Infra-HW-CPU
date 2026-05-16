module Div (
	input [31:0] A,
	input [31:0] B,
	input clk,
	input start,
	input reset,
	output reg [31:0] HI,
	output reg [31:0] LO,
	output reg div0
);
	
parameter INITIAL = 2'b00;
parameter LOAD = 2'b01;
parameter DIV = 2'b10;
parameter DONE = 2'b11;
	
reg [1:0] state = INITIAL;
reg [31:0] Quotient;
reg [63:0] Divisor;
reg [63:0] Remainder;
reg [7:0] contador;
reg negativeA;
reg negativeB;

initial begin
	state <= INITIAL;
end

always @(posedge clk or posedge reset) begin
	if (reset == 1) begin
		state <= INITIAL;
	end
	else begin
		case (state)
			INITIAL: begin
				if (start == 1) begin
					state <= LOAD;
				end
				Quotient <= 0;
				Divisor <= 0;
				Remainder <= 0;
			end
			LOAD: begin
				contador <= 0;
				if (B == 32'b0) begin
					div0 <= 1;
					state <= INITIAL;
				end
				else if (A[31] == 1) begin
					Remainder[31:0] = ~A + 1;
					negativeA <= 1;
					if (B[31] == 1) begin
						Divisor <= {~B + 1,32'b0};
						negativeB <= 1;
					end
					else begin
						Divisor <= {B, 32'b0};
						negativeB <= 0;
					end
					state <= DIV;
				end
				else begin
					Remainder <= A;
					negativeA <= 0;
					if (B[31] == 1) begin
						Divisor <= {~B + 1, 32'b0};
						negativeB <= 1;
					end
					else begin
						Divisor <= {B, 32'b0};
						negativeB <= 0;
					end
					state <= DIV;
				end	
			end
			DIV: begin
				if (contador < 33) begin
					Remainder = Remainder - Divisor;
					if (Remainder[63] == 1) begin
						Remainder = Remainder + Divisor;
						Quotient = Quotient << 1;
						Quotient[0] = 0;
					end
					else begin
						Quotient = Quotient << 1;
						Quotient[0] = 1;
					end
					Divisor = Divisor >> 1;
				end
				else begin
					if (negativeA == 0) begin
						if (negativeB == 1) begin
							Quotient = ~Quotient + 1;
						end
					end
					else begin
						Remainder = ~Remainder + 1;
						if (negativeB == 0) begin
							Quotient = ~Quotient + 1;
						end
					end
					state <= DONE;
				end
				contador <= contador + 1;
			end
			DONE: begin
				HI <= Remainder[31:0];
				LO <= Quotient;
				state <= INITIAL;
			end
		endcase
	end
end

endmodule

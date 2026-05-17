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

localparam IDLE = 2'b00;
localparam RUN  = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [5:0] counter;
reg signed [31:0] dividend;
reg signed [31:0] divisor;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= IDLE;
		counter <= 6'd0;
		dividend <= 32'sd0;
		divisor <= 32'sd0;
		HI <= 32'd0;
		LO <= 32'd0;
		div0 <= 1'b0;
	end else begin
		case (state)
			IDLE: begin
				counter <= 6'd0;

				if (start) begin
					if (B == 32'd0) begin
						HI <= 32'd0;
						LO <= 32'd0;
						div0 <= 1'b1;
						state <= DONE;
					end else begin
						div0 <= 1'b0;
						dividend <= A;
						divisor <= B;
						state <= RUN;
					end
				end
			end

			RUN: begin
				if (counter == 6'd32) begin
					HI <= dividend % divisor;
					LO <= dividend / divisor;
					state <= DONE;
				end else begin
					counter <= counter + 6'd1;
				end
			end

			DONE: begin
				if (!start)
					state <= IDLE;
			end

			default: begin
				state <= IDLE;
			end
		endcase
	end
end

endmodule

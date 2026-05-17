module mult (
	input [31:0] A,
	input [31:0] B,
	input clk,
	input start,
	input reset,
	output reg [31:0] HI,
	output reg [31:0] LO
);

localparam IDLE = 2'b00;
localparam RUN  = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [5:0] counter;
reg signed [63:0] product;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= IDLE;
		counter <= 6'd0;
		product <= 64'sd0;
		HI <= 32'd0;
		LO <= 32'd0;
	end else begin
		case (state)
			IDLE: begin
				counter <= 6'd0;

				if (start) begin
					product <= $signed(A) * $signed(B);
					state <= RUN;
				end
			end

			RUN: begin
				if (counter == 6'd32) begin
					HI <= product[63:32];
					LO <= product[31:0];
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

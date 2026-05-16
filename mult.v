module mult (
	input [31:0] A,
	input [31:0] B,
	input clk,
	input start,
	input reset,
	output reg [31:0] HI,
	output reg [31:0] LO
	);

parameter INITIAL = 2'b00;
parameter LOAD = 2'b01;
parameter MULT = 2'b10;
parameter DONE = 2'b11;

reg [1:0] state = INITIAL;
reg [63:0] PROD;
reg [31:0] MPLIER;
reg [63:0] MCAND;
reg [6:0] contador;
reg negative;

initial begin
	state <= INITIAL;
	PROD <= 0;
	MPLIER <= 0;
	MCAND  <= 0;
	HI <= 0;
	LO <= 0;
end

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		state <= INITIAL;
		PROD <= 0;
		MPLIER <= 0;
		MCAND  <= 0;
		HI <= 0;
		LO <= 0;
	end
	else begin
		case (state)
			INITIAL: begin
				if (start == 1) begin
					state <= LOAD;
				end
				PROD <= 0;
				MPLIER <= 0;
				MCAND  <= 0;
			end
			LOAD: begin
				contador <= 0;
				if (A[31] == 1) begin
					MPLIER <= ~A + 1;
					if (B[31] == 1) begin
						MCAND <= {32'b0, ~B + 1};
						negative <= 0;
					end
					else begin
						MCAND <= B;
						negative <= 1;
					end
				end
				else begin
					MPLIER <= A;
					if (B[31] == 1) begin
						MCAND <= {32'b0, ~B + 1};
						negative <= 1;
					end
					else begin
						MCAND <= B;
						negative <= 0;
					end
				end
				state <= MULT;
			end
			MULT: begin
				if (contador < 6'b100000) begin
					if (MPLIER[0] == 1)
						PROD <= PROD + MCAND;
					MPLIER <= MPLIER >> 1;
					MCAND <= MCAND << 1;
				end
				else begin
					if (negative == 1)
						PROD <= ~PROD + 1;
					else begin
						if (MPLIER[0] == 1)
							PROD <= PROD + MCAND;
						MPLIER <= MPLIER >> 1;
						MCAND <= MCAND << 1;
					end
					state <= DONE;
				end
				contador <= contador + 1;
			end
			DONE: begin
				HI <= PROD[63:32];
				LO <= PROD[31:0];
				state <= INITIAL;
			end
		endcase
	end
end

endmodule


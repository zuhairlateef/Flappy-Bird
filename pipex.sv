module pipex(reset, clk, in, out);
	input logic reset, clk;
	input logic [7:0] in;
	output logic [7:0] out;
	reg [9:0] count; 
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= '0;
			count <= 10'b0000000000;
		end
		else if (count == 10'b1111111111)begin
			out <= in;
			count <= 0;
		end
		else begin
			count <= count + 10'b0000000001;
		end
	end
endmodule

module pipex_testbench();
	logic reset, clk;
	logic [7:0] in, out;
	pipex dut(.reset, .clk, .in, .out);
	pipe1 duty(.reset, .clk, .location(in));
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	initial begin
						@(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for(integer i=0;i<1024;i++) begin
						@(posedge clk);
		end
		$stop; // End the simulation.
	end
endmodule
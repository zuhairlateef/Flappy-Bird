module key(clk,reset,in,out);
	input logic clk, reset;
	input logic in;
	output logic out;
	enum {A, B} ps, ns;
	always_comb begin
	case(ps)
		A:
		if(in) begin
			ns = A;
			out = 0;
		end
		else begin
			ns = B;
			out = 0;
		end
		B:
		if(in) begin
			ns = A;
			out = 1;
		end
		else begin
			ns = B;
			out = 0;
		end
		//default ns = 1'bx;
	endcase
	end
		
	reg [7:0] count; 
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= B;
			count <= 8'b00000000;
		end
		else if (count == 8'b01111111)begin
			ps <= ns;
		end
		else begin
			count <= count + 8'b00000001;
		end
	end
endmodule

module key_testbench();
	logic clk, reset, in;
	logic out;
	key dut (clk, reset, in, out);
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
									@(posedge clk);
		reset <= 1; 			@(posedge clk);
		reset <= 0; in <= 0; @(posedge clk);
									@(posedge clk);
		in <= 1; 				@(posedge clk);					
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
		in <= 0; 				@(posedge clk);
									@(posedge clk);
		$stop; // End the simulation.
	end
endmodule


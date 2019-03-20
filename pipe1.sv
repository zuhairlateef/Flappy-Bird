module pipe1(reset, clk, location);
	input logic reset, clk;
	output logic [7:0] location;
	parameter zero = 		11'b00011000011;
	parameter one = 		11'b00000000000; 	
	parameter two = 		11'b00011100001;
	parameter three = 	11'b00100000000; 
	parameter four = 		11'b00111000011;
	parameter five = 		11'b01100000000;	
	parameter six =		11'b00010000111; 
	parameter seven = 	11'b10000000000; 
	reg [10:0] ns, ps;
	always_comb begin
		case(ps)
			zero:
				ns = one;
			one:
				ns = two;
			two:
				ns = three;
			three:
				ns = four;
			four:
				ns = five;
			five:
				ns = six;
			six:
				ns = seven;
			seven:
				ns = zero;
			default ns = zero;
		endcase
	end
		reg [9:0] count; 
		always_ff @(posedge clk) begin
			if (reset) begin
				ps <= zero;
				location <= zero[7:0];
				count <= 10'b0000000000;
			end
			else if (count == 10'b1111111111)begin
				ps <= ns;
				count <= 0;
				location <= ps[7:0];
			end
			else begin
				count <= count + 10'b0000000001;
			end
		end
endmodule

module pipe1_testbench();
	logic reset, clk;
	logic [7:0] location;
	pipe1 dut(.reset, .clk, .location);
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	// Set up the inputs to the design. Each line is a clock cycle.
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
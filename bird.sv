module bird(reset, clk, in, location, lose);
	input logic reset, clk, in;
	output logic [7:0][7:0] location;
	output logic lose;
	parameter zero = 	8'b00000001; 
	parameter one = 	8'b00000010;
	parameter two = 	8'b00000100; 
	parameter three = 8'b00001000; 
	parameter four = 	8'b00010000; 
	parameter five = 	8'b00100000;
	parameter six = 	8'b01000000; 
	parameter seven = 8'b10000000;
	logic [7:0] ns, ps;
	always_comb begin
		case(ps)
			zero:
				if(in) begin
					ns = one;
					lose = 0;
				end
				else begin
					ns = zero;
					lose = 1;
				end
			one:
				if(in) begin
					ns = two;
					lose = 0;
				end
				else begin
					ns = zero;
					lose = 0;
				end
			two:
				if(in) begin
					ns = three;
					lose = 0;
				end
				else begin
					ns = one;
					lose = 0;
				end
			three:
				if(in) begin
					ns = four;
					lose = 0;
				end
				else begin
					ns = two;
					lose = 0;
				end
			four:
				if(in) begin
					ns = five;
					lose = 0;
				end
				else begin
					ns = three;
					lose = 0;
				end
			five:
				if(in) begin
					ns = six;
					lose = 0;
				end
				else begin
					ns = four;
					lose = 0;
				end
			six:
				if(in) begin
					ns = seven;
					lose = 0;
				end
				else begin
					ns = five;
					lose = 0;
				end
			seven:
				if(in) begin
					ns = seven;
					lose = 0;
				end
				else begin
					ns = six;
					lose = 0;
				end
			endcase
		end
		reg [7:0] count; 
		always_ff @(posedge clk) begin
			if (reset) begin
				ps <= four;
				location[0] <= ps;
				location[7:1] <= '0;
				count <= 8'b00000000;
			end
			else if (count == 8'b10111111)begin
				ps <= ns;
				count <= 0;
				location[0] <= ps;
				location[7:1] <= '0;
			end
			else begin
				count <= count + 8'b00000001;
			end
		end
endmodule

module bird_testbench();
	logic reset, clk, in, lose;
	logic [7:0][7:0] location;
	bird dut(.reset, .clk, .in, .location, .lose);
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
		for(integer i=0;i<8;i++) begin
						in <= 1; @(posedge clk);
		end
		in <= 0; 	@(posedge clk);
		for(integer i=0;i<8;i++) begin
						@(posedge clk);
		end
		$stop; // End the simulation.
	end
endmodule
module counter(clk, reset, in, HEX, out);
	input logic clk, reset, in;
	output logic [6:0]HEX;
	output logic out;
	enum {zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9} ps, ns;
	always_comb begin
	case(ps)
	zero:
		if(in) begin
			ns = one;
			out = 0;
		end
		else begin
			ns = zero;
			out = 0;
		end
	one:
		if(in) begin
			ns = two;
			out = 0;
		end
		else begin
			ns = one;
			out = 0;
		end
	two:
		if(in) begin
			ns = three;
			out = 0;
		end
		else begin
			ns = two;
			out = 0;
		end
	three:
		if(in) begin
			ns = four;
			out = 0;
		end
		else begin
			ns = three;
			out = 0;
		end
	four:
		if(in) begin
			ns = five;
			out = 0;
		end
		else begin
			ns = four;
			out = 0;
		end
	five:
		if(in) begin
			ns = six;
			out = 0;
		end
		else begin
			ns = five;
			out = 0;
		end
	six:
		if(in) begin
			ns = seven;
			out = 0;
		end
		else begin
			ns = six;
			out = 0;
		end
	seven:
		if(in) begin
			ns = eight;
			out = 0;
		end
		else begin
			ns = seven;
			out = 0;
		end
	eight:
		if(in) begin
			ns = nine;
			out = 0;
		end
		else begin
			ns = eight;
			out = 0;
		end
	nine:
		if(in) begin
			ns = zero;
			out = 1;
		end
		else begin
			ns = nine;
			out = 0;
		end
	default out = 0;
	endcase
	end
	seg7 count(.bcd(ps[3:0]), .leds(HEX));
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= zero;
		end
		else begin
			ps <= ns;
		end
	end
endmodule

module counter_testbench();
	logic clk, reset, in;
	logic out;
	logic [6:0] HEX;
	counter dut (.clk,.reset,.in,.HEX,.out);
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
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 1; 				@(posedge clk);					
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);					
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		in <= 0; 				@(posedge clk);					
		in <= 1; 				@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
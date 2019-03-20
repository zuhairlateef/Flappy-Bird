module DE1_SoC (CLOCK_50, GPIO_0, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	output logic [35:0] GPIO_0;
	
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	logic reset;
	assign reset = SW[0] | lose |
						(red[0][1] & green[0][1]) | (red[0][2] & green[0][2]) |
						(red[0][0] & green[0][0]) | (red[0][5] & green[0][5]) |
						(red[0][6] & green[0][6]) | (red[0][7] & green[0][7]);
						
	parameter whichClock = 15;
	
	//Logic
	logic [7:0][7:0] red, green;
	
	//Score Keeping
	key count(.clk(clk[whichClock]), .reset, .in(green[0][0]), .out(point));
	counter ones(.clk(clk[whichClock]), .reset, .in(point), .HEX(HEX0), .out(next1));
	counter tens(.clk(clk[whichClock]), .reset, .in(next1), .HEX(HEX1), .out(next2));
	counter hundreds(.clk(clk[whichClock]), .reset, .in(next2), .HEX(HEX2), .out());
	//LED Matrix
	
	
	pipe1 create(.reset, .clk(clk[whichClock]), .location(green[7]));
	pipex read1(.reset, .clk(clk[whichClock]), .in(green[7]), .out(green[6]));
	pipex read2(.reset, .clk(clk[whichClock]), .in(green[6]), .out(green[5]));
	pipex read3(.reset, .clk(clk[whichClock]), .in(green[5]), .out(green[4]));
	pipex read4(.reset, .clk(clk[whichClock]), .in(green[4]), .out(green[3]));
	pipex read5(.reset, .clk(clk[whichClock]), .in(green[3]), .out(green[2]));
	pipex read6(.reset, .clk(clk[whichClock]), .in(green[2]), .out(green[1]));
	pipex read7(.reset, .clk(clk[whichClock]), .in(green[1]), .out(green[0]));
	
	purifier button(.clk(clk[whichClock]), .reset, .in(~KEY[3]), .out(value));
	logic lose;
	bird flappy(.reset, .clk(clk[whichClock]), .in(value), .location(red),
								.lose(lose));
	
	led_matrix_driver tmp(.clock(clk[whichClock]), .red_array(red), 
								.green_array(green), .red_driver(GPIO_0[27:20]), 
								.green_driver(GPIO_0[35:28]), .row_sink(GPIO_0[19:12]));
	//Clock
	clock_divider cdiv (.clock(CLOCK_50), .reset(reset), .divided_clocks(clk));
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz,
//[25] = 0.75Hz, ...
module clock_divider (clock, reset, divided_clocks);
 input logic reset, clock;
 output logic [31:0] divided_clocks = 0;
 always_ff @(posedge clock) begin
 divided_clocks <= divided_clocks + 1;
 end

endmodule

module DE1_SoC_testbench();
	logic CLOCK_50; // 50MHz clock.
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // True when not pressed, False when pressed
	logic [9:0] SW;
	logic [35:0] GPIO_0;
	logic clk;
	DE1_SoC dut(.CLOCK_50, .GPIO_0, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
						@(posedge clk);
		SW[0] <= 1; @(posedge clk);
		SW[0] <= 0; @(posedge clk);
		for(integer i=0;i<1024;i++) begin
						KEY[3] <= 0; @(posedge clk);
						KEY[3] <= 1; @(posedge clk);
		end
		$stop; // End the simulation.
	end
endmodule
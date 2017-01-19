module finalproject
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		SW,
		LEDR,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   							//	VGA Blue[9:0]
		
		PS2_CLK,
		PS2_DAT
	);

	input				CLOCK_50;				//	50 MHz
	input 	[9:0] SW;
	input 	[2:0] KEY;
	// Do not change the following outputs
	output		[9:0] LEDR;
	output 		[6:0] HEX0,HEX1,HEX2,HEX3;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	inout PS2_CLK;
	inout PS2_DAT;
	
	
	
	wire resetn;
	assign resetn = !KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [8:0] colour;
	wire [15:0] score;

	wire [8:0] x;
	wire [7:0] y;

	wire writeEn; //plot basically, based off of key 1
	

	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(!resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240"; //change to 320x240
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 3; //2 or 3 bits
		defparam VGA.BACKGROUND_IMAGE = "start.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
	part2 p2 (
		.clk (CLOCK_50),
		.reset (resetn), 	//key 0
		.color (SW[9:4]),
		.led (LEDR[0]),
		.led1 (LEDR[1]),
		.wasd (SW[3:0]),
		.start(!KEY[2]),
		.plot_out (writeEn),
		.x_out (x),
		.y_out (y),
		.color_out (colour),
		.ps2_clk (PS2_CLK),
		.ps2_dat(PS2_DAT),
		.score (score)
	);
	
	hex_decoder h3 (score[15:12], HEX3);
	
	hex_decoder h2 (score[11:8], HEX2);
	
	hex_decoder h1 (score[7:4], HEX1);
	
	hex_decoder h0 (score[3:0], HEX0);
	
	
endmodule


module part2 (
	input clk,
	input reset,
	input [8:0] color,
	input [3:0] wasd,
	input start,
	
	
	output plot_out,
	output [8:0] x_out,
	output [7:0] y_out,
	output [8:0] color_out,
	output led, led1,
	output [15:0]score,
	
	inout ps2_clk,
	inout ps2_dat
);
	wire [7:0] ps2_data;
	wire ld_draw,ld_erase;
	wire ld_draw1,ld_draw2,ld_draw3,ld_draw4,ld_draw5,ld_draw6,ld_draw7,ld_draw8;
	wire ld_draw_you,ld_draw_all,ld_draw_start,ld_load_start,ld_load_game_over;
	wire ld_reset,init;
	wire ld_h,ld_v,ld_h1,ld_v1,ld_h2,ld_v2,ld_h3,ld_v3,ld_h4,ld_v4,ld_h5,ld_v5,ld_h6,ld_v6,ld_h7,ld_v7,ld_h8,ld_v8;
	wire ld_user,ld_check;
	wire gameover,ld_end;
	wire [6:0]size_you;
	wire [6:0]size;
	wire [6:0]size1;
	wire [6:0]size2;
	wire [6:0]size3;
	wire [6:0]size4;
	wire [6:0]size5;
	wire [6:0]size6;
	wire [6:0]size7;
	wire [6:0]size8;
	
	control c0(
	.clk (clk),
	.reset (reset), //key 0
	.size_you (size_you),
	.size (size),
	.size1 (size1),
	.size2 (size2),
	.size3 (size3),
	.size4 (size4),
	.size5 (size5),
	.size6 (size6),
	.size7 (size7),
	.size8 (size8),
	.start (start),
	.ld_draw (ld_draw),
	.ld_erase (ld_erase),
	.ld_draw1 (ld_draw1),
	.ld_draw2 (ld_draw2),
	.ld_draw3 (ld_draw3),
	.ld_draw4 (ld_draw4),
	.ld_draw5 (ld_draw5),
	.ld_draw6 (ld_draw6),
	.ld_draw7 (ld_draw7),
	.ld_draw8 (ld_draw8),
	.ld_load_start (ld_load_start),
	.ld_draw_you (ld_draw_you),
	.ld_draw_all (ld_draw_all),
	.ld_draw_start (ld_draw_start),
	.ld_load_game_over(ld_load_game_over),
	.ld_h (ld_h),
	.ld_v (ld_v),
	.ld_h1 (ld_h1),
	.ld_v1 (ld_v1),
	.ld_h2 (ld_h2),
	.ld_v2 (ld_v2),
	.ld_h3 (ld_h3),
	.ld_v3 (ld_v3),
	.ld_h4 (ld_h4),
	.ld_v4 (ld_v4),
	.ld_h5 (ld_h5),
	.ld_v5 (ld_v5),
	.ld_h6 (ld_h6),
	.ld_v6 (ld_v6),
	.ld_h7 (ld_h7),
	.ld_v7 (ld_v7),
	.ld_h8 (ld_h8),
	.ld_v8 (ld_v8),
	.ld_reset(ld_reset),
	.init (init),
	.ld_user (ld_user),	
	.ld_check(ld_check),
	.ld_end (ld_end),
	.plot_out (plot_out),// goes to vga
	.gameover (gameover),
	.ps2_last_data (ps2_data)
	);

	datapath d0 (
	.clk (clk),
	.color (color),
	.ld_draw (ld_draw),
	.ld_erase (ld_erase),
	.ld_draw1 (ld_draw1),
	.ld_draw2 (ld_draw2),
	.ld_draw3 (ld_draw3),
	.ld_draw4 (ld_draw4),
	.ld_draw5 (ld_draw5),
	.ld_draw6 (ld_draw6),
	.ld_draw7 (ld_draw7),
	.ld_draw8 (ld_draw8),
	.ld_draw_you (ld_draw_you),
	.ld_draw_all (ld_draw_all),
	.ld_load_start (ld_load_start),
	.ld_draw_start (ld_draw_start),
	.ld_load_game_over(ld_load_game_over),
	.ld_h (ld_h),
	.ld_v (ld_v),
	.ld_h1 (ld_h1),
	.ld_v1 (ld_v1),
	.ld_h2 (ld_h2),
	.ld_v2 (ld_v2),
	.ld_h3 (ld_h3),
	.ld_v3 (ld_v3),
	.ld_h4 (ld_h4),
	.ld_v4 (ld_v4),
	.ld_h5 (ld_h5),
	.ld_v5 (ld_v5),
	.ld_h6 (ld_h6),
	.ld_v6 (ld_v6),
	.ld_h7 (ld_h7),
	.ld_v7 (ld_v7),
	.ld_h8 (ld_h8),
	.ld_v8 (ld_v8),
	.ld_user (ld_user),
	.ld_end (ld_end),
	.reset (ld_reset),
	.x_out (x_out),
	.y_out (y_out),
	.init (init),
	.color_out (color_out),
	.wasd (wasd),
	.size_you (size_you),
	.size (size),
	.size1 (size1),
	.size2 (size2),
	.size3 (size3),
	.size4 (size4),
	.size5 (size5),
	.size6 (size6),
	.size7 (size7),
	.size8 (size8),
	.led (led),
	.led1 (led1),
	.ld_check(ld_check),
	.ps2_clk (ps2_clk),
	.ps2_dat (ps2_dat),
	.gameover (gameover),
	.ps2_last_data(ps2_data),
	.score(score)
	);

endmodule




module control (
	input clk,
	input reset, //key 0
	input [6:0]size_you,
	input [6:0]size,
	input [6:0]size1,
	input [6:0]size2,
	input [6:0]size3,
	input [6:0]size4,
	input [6:0]size5,
	input [6:0]size6,
	input [6:0]size7,
	input [6:0]size8,
	input [7:0] ps2_last_data,
	input gameover,
	input start,
	
	output reg ld_draw,
	output reg ld_erase,
	output reg ld_draw1,
	output reg ld_draw2,
	output reg ld_draw3,
	output reg ld_draw4,
	output reg ld_draw5,
	output reg ld_draw6,
	output reg ld_draw7,
	output reg ld_draw8,
	output reg ld_draw_you,
	output reg ld_draw_all,
	output reg ld_load_start,
	output reg ld_draw_start,
	output reg ld_load_game_over,
	output reg ld_h,
	output reg ld_v,
	output reg ld_h1,
	output reg ld_v1,
	output reg ld_h2,
	output reg ld_v2,
	output reg ld_h3,
	output reg ld_v3,
	output reg ld_h4,
	output reg ld_v4,
	output reg ld_h5,
	output reg ld_v5,
	output reg ld_h6,
	output reg ld_v6,
	output reg ld_h7,
	output reg ld_v7,
	output reg ld_h8,
	output reg ld_v8,
	output reg ld_reset,
	output reg plot_out,
	output reg init,
	output reg ld_user,
	output reg ld_check,
	output reg ld_end
);

	 reg [5:0] current_state, next_state; 
	 reg [23:0] count; //reset <- 0
	 reg reset_en;
	 
	
	 
 
	 localparam  S_INIT			= 5'd0,
					 S_LOAD_START	= 5'd1,
					 S_DRAW_START	= 5'd2,
					 S_DRAW        = 5'd3,
					 S_ERASE   		= 5'd4,
					 S_UPDATE      = 5'd5,
					 S_RESET			= 5'd6,
					 S_RESETWAIT	= 5'd7,
					 S_DRAW_YOU		= 5'd8,
					 S_DRAW1			= 5'd9,
					 S_DRAW2			= 5'd10,
					 S_DRAW3			= 5'd11,
					 S_DRAW4			= 5'd12,
					 S_DRAW5			= 5'd13,
					 S_DRAW6			= 5'd14,
					 S_DRAW7			= 5'd15,
					 S_DRAW8			= 5'd16,
					 S_DRAW_ALL 	= 5'd17,
					 S_END			= 5'd18,
					 S_RESET_COUNT	= 5'd19,
					 S_RESET_COUNT_END = 5'd20,
					 S_LOAD_END = 5'd21;
					 
	initial begin
		count = 0;	//initial count = 0;
		//current_state = S_RESET;
	 end
	 
	 always @ (posedge clk) begin	
			if (current_state == 0)
				count <= 0;
			else if (count == 24'd800000)
				count <=0;
			else if (current_state == S_RESETWAIT)
				count <= 0;
			else if (current_state == S_RESET_COUNT_END)
				count <= 0;
			else if (current_state == S_RESET_COUNT)
				count <= 0;
			else if (current_state == S_UPDATE)
				count <= 0;
			else if (reset)
				count <= 24'd800000 - 24'd76800 - 2;
			else
				count <= count + 1;
	 end
	 
	 always@(*)
	 begin: state_table 
				case (current_state)
					 S_INIT: next_state = S_RESET;
					 
					 S_RESET: next_state = S_RESETWAIT;
					 
					 S_RESETWAIT: next_state = (!start)?S_LOAD_START:S_RESETWAIT;
					 
					 S_LOAD_START: next_state = (count == 24'd76800) ? S_DRAW_START:S_LOAD_START;
					 
					 S_DRAW_START: next_state = (start && count >  24'd153600) ? S_RESET_COUNT:S_DRAW_START;
					 
					 S_RESET_COUNT: next_state = S_DRAW;
					 
					 
					 
					 
					 S_DRAW: next_state = (count == (size*size)) ? S_DRAW1: S_DRAW;
					 
					 S_DRAW1: next_state = (count == (size1*size1) + (size*size))? S_DRAW2:S_DRAW1;
					 
					 S_DRAW2: next_state = (count == (size2*size2) + (size1*size1) + (size*size))? S_DRAW3:S_DRAW2;
					 
					 
					 
					 S_DRAW3: next_state = (count == (size3*size3)+(size2*size2) + (size1*size1) + (size*size)) ? S_DRAW4: S_DRAW3;
					 
					 S_DRAW4: next_state = (count == (size4*size4)+(size3*size3)+(size2*size2) + (size1*size1) + (size*size))? S_DRAW5:S_DRAW4;
					 
					 S_DRAW5: next_state = (count == (size5*size5)+ (size4*size4)+(size3*size3)+(size2*size2) + (size1*size1) + (size*size))? S_DRAW6:S_DRAW5;
					 
					 
					 S_DRAW6: next_state = (count == (size6*size6)+(size5*size5)+ (size4*size4)+(size3*size3)+(size2*size2) + (size1*size1) + (size*size)) ? S_DRAW7: S_DRAW6;
					 
					 S_DRAW7: next_state = (count == (size7* size7) + (size6*size6)+(size5*size5)+ (size4*size4)+(size3*size3)+(size2*size2) + (size1*size1) + (size*size))? S_DRAW8:S_DRAW7;
					 
					 S_DRAW8: next_state = (count == (size8*size8) +(size7* size7) + (size6*size6)+(size5*size5)+ (size4*size4)+(size3*size3)+(size2*size2) + (size1*size1) + (size*size))? S_DRAW_YOU:S_DRAW8;
					 
					 
					 
					 
					 S_DRAW_YOU: next_state = (count == (size8*size8) +(size7* size7) + (size6*size6)+(size5*size5)+ (size4*size4)+(size3*size3)+(size2*size2) + (size1*size1) + (size*size) + (size_you*size_you) + 2) ? S_DRAW_ALL: S_DRAW_YOU;
					 
					 S_DRAW_ALL:next_state = (count == 24'd800000 - 24'd76800) ? S_ERASE: S_DRAW_ALL;
					 
					 S_ERASE: next_state = (count == 24'd800000) ? (reset_en ? S_RESET:S_UPDATE): S_ERASE;

					 S_UPDATE: next_state = S_DRAW;
					 
					 
					 
					 //if game over, goes directly here
					 S_RESET_COUNT_END: next_state = S_LOAD_END;
					 
					 S_LOAD_END : next_state = (count == 24'd76800) ? S_END:S_LOAD_END;
					 
					 S_END: next_state = (start && count >  24'd153600) ? S_RESET : S_END;

					 
				default:     next_state = S_RESET;
		  endcase
	 end // state_table

	 
	 
	 
	 
	 // Output logic aka all of our datapath control signals
	 always @(*)
	 begin: enable_signals
		  // By default make all our signals 0
		  ld_draw = 1'b0;		  
		  ld_draw1 = 1'b0;
		  ld_draw2 = 1'b0;
		  ld_draw3 = 1'b0;		  
		  ld_draw4 = 1'b0;
		  ld_draw5 = 1'b0;
		  ld_draw6 = 1'b0;		  
		  ld_draw7 = 1'b0;
		  ld_draw8 = 1'b0;
		  ld_draw_all = 1'b0;
		  ld_load_start = 1'b0;
		  ld_draw_start = 1'b0;
		  ld_load_game_over = 1'b0;
		  ld_end = 1'b0;
		  ld_erase = 1'b0;
		  ld_h = 1'b0;
		  ld_v = 1'b0;
		  ld_h1 = 1'b0;
		  ld_v1 = 1'b0;
		  ld_h2 = 1'b0;
		  ld_v2 = 1'b0;
		  ld_h3 = 1'b0;
		  ld_v3 = 1'b0;
		  ld_h4 = 1'b0;
		  ld_v4 = 1'b0;
		  ld_h5 = 1'b0;
		  ld_v5 = 1'b0;
		  ld_h6 = 1'b0;
		  ld_v6 = 1'b0;
		  ld_h7 = 1'b0;
		  ld_v7 = 1'b0;
		  ld_h8 = 1'b0;
		  ld_v8 = 1'b0;
		  plot_out = 1'b0;
		  ld_reset = 1'b0;
		  init = 1'b0;
		  ld_draw_you = 1'b0;
		  ld_user = 1'b0;
		  ld_check = 1'b0;
		  
		  
		  case (current_state)
				S_INIT: begin
					init = 1'b1;
					//plot_out = 1'b1;
					end
					
				S_LOAD_START:begin
					ld_load_start = 1'b1;
					end
				S_DRAW_START: begin
					ld_draw_start = 1'b1;
					plot_out = 1'b1;
					end
					
				S_DRAW: begin
					 ld_draw = 1'b1;
					 end
				S_DRAW1: begin
					 ld_draw1 = 1'b1;
					 end
				S_DRAW2: begin
					 ld_draw2 = 1'b1;
					 end
				S_DRAW3: begin
					 ld_draw3 = 1'b1;
					 end
				S_DRAW4: begin
					 ld_draw4 = 1'b1;
					 end
				S_DRAW5: begin
					 ld_draw5 = 1'b1;
					 end
				S_DRAW6: begin
					 ld_draw6 = 1'b1;
					 end
				S_DRAW7: begin
					 ld_draw7 = 1'b1;
					 end
				S_DRAW8: begin
					 ld_draw8 = 1'b1;
					 end	 
					 
					 
					 
					 
				S_DRAW_YOU: begin
					ld_draw_you = 1'b1;
					end
				S_DRAW_ALL:begin
					 ld_draw_all = 1'b1;
					 plot_out = 1'b1;
				end
				S_ERASE: begin
					 ld_erase = 1'b1;
					 end
				S_UPDATE: begin
					 ld_h = 1'b1;
					 ld_v = 1'b1;
					 ld_h1 = 1'b1;
					 ld_v1 = 1'b1;
					 ld_h2 = 1'b1;
					 ld_v2 = 1'b1;
					 ld_h3 = 1'b1;
					 ld_v3 = 1'b1;
					 ld_h4 = 1'b1;
					 ld_v4 = 1'b1;
					 ld_h5 = 1'b1;
					 ld_v5 = 1'b1;
					 ld_h6 = 1'b1;
					 ld_v6 = 1'b1;
					 ld_h7 = 1'b1;
					 ld_v7 = 1'b1;
					 ld_h8 = 1'b1;
					 ld_v8 = 1'b1;
					 ld_user = 1'b1;
					 ld_check = 1'b1;
				end

				S_RESET: begin
					ld_reset = 1'b1;
				end
				
				S_LOAD_END: begin
					ld_load_game_over = 1'b1;
				end
				
				S_END: begin
					ld_end = 1'b1;
					plot_out = 1'b1;
				end

		  // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
		  endcase
	 end // enable_signals
	
	
	always @ (*) begin
		if (reset)
			reset_en = 1'b1;

		if (current_state == S_RESET)
			reset_en = 1'b0;
	

	end
	
	
	 always@(posedge clk)
	 begin: state_FFs
		  if(reset)
				current_state <= S_ERASE;
				
		  else if(gameover && current_state!= S_RESET_COUNT_END)
				current_state <= S_RESET_COUNT_END;
				
					
		  else
				current_state <= next_state;
			
	 end 	 
	 
	 
endmodule


module datapath (
	input clk,
	input reset,
	input [8:0] color,
	input [3:0] wasd,
	input ld_draw,ld_draw1,ld_draw2, ld_draw3,ld_draw4,ld_draw5, ld_draw6,ld_draw7,ld_draw8,
	input ld_draw_you,ld_erase, ld_draw_all,
	input ld_draw_start,ld_load_start, ld_load_game_over,
	input ld_user, ld_check,
	input ld_h,ld_v,ld_h1,ld_v1,ld_h2,ld_v2,ld_h3,ld_v3,ld_h4,ld_v4,ld_h5,ld_v5,ld_h6,ld_v6,ld_h7,ld_v7,ld_h8,ld_v8,
	input init,
	input ps2_clk,
	input ps2_dat,
	input ld_end,
	output reg [8:0] x_out,
	output reg [7:0] y_out,
	output reg [8:0] color_out,
	output reg [6:0] size_you,
	output reg [6:0] size,
	output reg [6:0] size1,
	output reg [6:0] size2,
	output reg [6:0] size3,
	output reg [6:0] size4,
	output reg [6:0] size5,
	output reg [6:0] size6,
	output reg [6:0] size7,
	output reg [6:0] size8,
	output reg led, led1,
	output reg [7:0] ps2_last_data,
	output reg gameover,
	output reg [15:0] score //up to 4 hex digits
);	
	
	
	reg [8:0] x_count;
	reg [7:0] y_count;
	
	reg [8:0] x_prev_out;
	reg [7:0] y_prev_out;
	
	
	
	reg [8:0] x1_count;
	reg [7:0] y1_count;
	
	reg [8:0] x1_prev_out;
	reg [7:0] y1_prev_out;
	
	
	
	reg [8:0] x2_count;
	reg [7:0] y2_count;
	
	reg [8:0] x2_prev_out;
	reg [7:0] y2_prev_out;
	
	
	
	reg [8:0] x3_count;
	reg [7:0] y3_count;
	
	reg [8:0] x3_prev_out;
	reg [7:0] y3_prev_out;
	
	
	
	reg [8:0] x4_count;
	reg [7:0] y4_count;
	
	reg [8:0] x4_prev_out;
	reg [7:0] y4_prev_out;
	
	
	
	reg [8:0] x5_count;
	reg [7:0] y5_count;
	
	reg [8:0] x5_prev_out;
	reg [7:0] y5_prev_out;
	
	
	
	reg [8:0] x6_count;
	reg [7:0] y6_count;
	
	reg [8:0] x6_prev_out;
	reg [7:0] y6_prev_out;
	
	
	
	reg [8:0] x7_count;
	reg [7:0] y7_count;
	
	reg [8:0] x7_prev_out;
	reg [7:0] y7_prev_out;
	
	
	
	reg [8:0] x8_count;
	reg [7:0] y8_count;
	
	reg [8:0] x8_prev_out;
	reg [7:0] y8_prev_out;
	
	
	
	
	
	
	
	
	
	reg [8:0] x_you_count;
	reg [7:0] y_you_count;
	

	reg [8:0] x_you_prev_out;
	reg [7:0] y_you_prev_out;
	
	reg eaten, eaten1, eaten2, eaten3, eaten4, eaten5, eaten6, eaten7, eaten8;
	
	reg [3:0] score_count; //score for staying alive, +1 every 16 cycles
	
	
	reg h,v,h1,v1,h2,v2,h3,v3,h4,v4,h5,v5,h6,v6,h7,v7,h8,v8;
	reg shiftoutx,shiftouty;
	reg [29:0] b30x,b30y;
	reg changeH,changeH1,changeH2,changeH3,changeH4,changeH5,changeH6,changeH7,changeH8;
	reg changeV,changeV1,changeV2,changeV3,changeV4,changeV5,changeV6,changeV7,changeV8;
	reg [8:0]draw;
	
	
	
	wire ps2_en;
	wire [7:0] ps2_data;
	wire [8:0] erase;
	wire [8:0] startscreen;	
	wire [8:0] gameoverscreen;
	wire [8:0] drawout;
	wire [16:0] address;
	
	
	PS2_Controller PS2(
		.CLOCK_50(clk),
		.reset(reset),
		
		.PS2_CLK (ps2_clk),
		.PS2_DAT (ps2_dat),
		
		.received_data (ps2_data),
		.received_data_en (ps2_en)
	
	);
	
	
	
	reg en;

always @ (*)begin
if (ps2_data == 'hF0)
	en = 1'b1;
if (ps2_data == 'hE0)
	en = 1'b0;

end 
	
	
	always@ (posedge clk)
	begin
		if (reset || en)
			ps2_last_data <= 8'h00;
		else if (ps2_en == 1'b1)
			ps2_last_data<= ps2_data;
	end
	
	
	vga_address_translator a1(.x(x_out),
										.y(y_out),
										.mem_address(address));
	
	star u1(.address(address),
				.clock(clk),
				.q(erase));
		
	beginscreen u2(.address(address),
				.clock(clk),
				.q(startscreen));

	draw u4(.address(address),
				.clock(clk),
				.data(draw),
				.wren(ld_draw||ld_draw1||ld_draw2||ld_draw3||ld_draw4||ld_draw5||ld_draw6||ld_draw7||ld_draw8||ld_draw_you||ld_erase||ld_load_start||ld_load_game_over),
				.q(drawout));
				
	

	initial begin
		en = 1'b1;
		gameover = 1'b0;
		led1 = 1'b0;
		score = 16'b0;
		score_count = 5'b0;
		b30x <= 30'b 000101001000011001101101010100;
		b30y <= 30'b 011101000011011010101010100101;
		
		x_you_count = 0;
		y_you_count = 0;
		
		x_you_prev_out = 9'd 158;
		y_you_prev_out = 8'd 118;
		
		led = 1'b0;
		
		size_you = 4'd4;

		eaten = 1'b0;
		eaten1 = 1'b0;
		eaten2 = 1'b0;
		eaten3 = 1'b0;
		eaten4 = 1'b0;
		eaten5 = 1'b0;
		eaten6 = 1'b0;
		eaten7 = 1'b0;
		eaten8 = 1'b0;

		
			size = 7'd2;
			size1 = 7'd4;
			size2 = 7'd8;
			size3 = 7'd8;
			size4 = 7'd8;
			size5 = 7'd16;
			size6 = 7'd16;
			size7 = 7'd32;
			size8 = 7'd32;
		
		
		if (b30x[29:21]>(320-size-2)) //once we start changing the size, it will be 160-size-2 eg. for screen 160 & size 4,
					//it needs to be greater than 154 before subtracting
					//so 155 -> 160 inclusive
					//bc if its at 155, the square will reach 159, don't want it to be right on the boundary
					
							x_prev_out <= b30x[29:21]-(320-size-2);
						
					
					else 
						
							x_prev_out <= b30x[29:21];
						
					
							
					if (b30y[29:22]>(240-size-2)) //once we start changing the size, it will be 120-size-2
						
							y_prev_out <= b30y[29:22]-(240-size-2);
						
					
					else
						
							y_prev_out <= b30y[29:22];
						
						

			
			if (b30x[28:20]>(320-size1-2)) //once we start changing the size, it will be 160-size-2 eg. for screen 160 & size 4,
					//it needs to be greater than 154 before subtracting
					//so 155 -> 160 inclusive
					//bc if its at 155, the square will reach 159, don't want it to be right on the boundary
					
							x1_prev_out <= b30x[28:20]-(320-size1-2);
					
					else 
						
							x1_prev_out <= b30x[28:20];
						
							
					if (b30y[28:21]>(240-size1-2)) //once we start changing the size, it will be 120-size-2
						
							y1_prev_out <= b30y[28:21]-(240-size1-2);
						
					else
						
							y1_prev_out <= b30y[28:21];
						
						
						
						
						
			if (b30x[27:19]>(320-size2-2)) //once we start changing the size, it will be 160-size-2 eg. for screen 160 & size 4,
					//it needs to be greater than 154 before subtracting
					//so 155 -> 160 inclusive
					//bc if its at 155, the square will reach 159, don't want it to be right on the boundary
						
							x2_prev_out <= b30x[27:19]-(320-size2-2);
						
					else 
						
							x2_prev_out <= b30x[27:19];
						
							
					if (b30y[27:20]>(240-size2-2)) //once we start changing the size, it will be 120-size-2
						
							y2_prev_out <= b30y[27:20]-(240-size2-2);
							
					else
					
							y2_prev_out <= b30y[27:20];
							
							
							
			if (b30x[26:18]>(320-size3-2))
							x3_prev_out <= b30x[26:18]-(320-size3-2);
					else 
							x3_prev_out <= b30x[26:18];
					if (b30y[26:19]>(240-size3-2)) 
							y3_prev_out <= b30y[26:19]-(240-size3-2);
					else
							y3_prev_out <= b30y[26:19];
							
							
			if (b30x[25:17]>(320-size4-2))
							x4_prev_out <= b30x[25:17]-(320-size4-2);
					else 
							x4_prev_out <= b30x[25:17];
					if (b30y[25:18]>(240-size4-2)) 
							y4_prev_out <= b30y[25:18]-(240-size4-2);
					else
							y4_prev_out <= b30y[25:18];
							
							
			if (b30x[24:16]>(320-size5-2))
							x5_prev_out <= b30x[24:16]-(320-size5-2);
					else 
							x5_prev_out <= b30x[24:16];
					if (b30y[24:17]>(240-size5-2)) 
							y5_prev_out <= b30y[24:17]-(240-size5-2);
					else
							y5_prev_out <= b30y[24:17];
			
			if (b30x[23:15]>(320-size6-2))
							x6_prev_out <= b30x[23:15]-(320-size6-2);
					else 
							x6_prev_out <= b30x[23:15];
					if (b30y[23:16]>(240-size6-2)) 
							y6_prev_out <= b30y[23:16]-(240-size6-2);
					else
							y6_prev_out <= b30y[23:16];
							
			if (b30x[22:14]>(320-size7-2))
							x7_prev_out <= b30x[22:14]-(320-size7-2);
					else 
							x7_prev_out <= b30x[22:14];
					if (b30y[22:15]>(240-size7-2)) 
							y7_prev_out <= b30y[22:15]-(240-size7-2);
					else
							y7_prev_out <= b30y[22:15];
							
			if (b30x[21:13]>(320-size8-2))
							x8_prev_out <= b30x[21:13]-(320-size8-2);
					else 
							x8_prev_out <= b30x[21:13];
					if (b30y[21:14]>(240-size8-2)) 
							y8_prev_out <= b30y[21:14]-(240-size8-2);
					else
							y8_prev_out <= b30y[21:14];
						
end
			
			
	
	
	
	always @ (*)begin
		shiftoutx = b30x[0] ^ b30x[29];
		shiftouty = b30y[0] ^ b30y[29];
		changeH = ~(b30x[21]||b30x[22]||b30x[23]||b30x[24]||b30x[25]);
		changeV = ~(b30y[21]||b30y[22]||b30y[23]||b30y[24]||b30y[25]);
		changeH1 = ~(b30x[20]||b30x[21]||b30x[22]||b30x[23]||b30x[24]);
		changeV1 = ~(b30y[20]||b30y[21]||b30y[22]||b30y[23]||b30y[24]);
		changeH2 = ~(b30x[19]||b30x[20]||b30x[21]||b30x[22]||b30x[23]);
		changeV2 = ~(b30y[19]||b30y[20]||b30y[21]||b30y[22]||b30y[23]);
		changeH3 = ~(b30x[18]||b30x[19]||b30x[20]||b30x[21]||b30x[22]);
		changeV3 = ~(b30y[18]||b30y[19]||b30y[20]||b30y[21]||b30y[22]);
		changeH4 = ~(b30x[17]||b30x[18]||b30x[19]||b30x[20]||b30x[21]);
		changeV4 = ~(b30y[17]||b30y[18]||b30y[19]||b30y[20]||b30y[21]);
		changeH5 = ~(b30x[16]||b30x[17]||b30x[18]||b30x[19]||b30x[20]);
		changeV5 = ~(b30y[16]||b30y[17]||b30y[18]||b30y[19]||b30y[20]);
		changeH6 = ~(b30x[15]||b30x[16]||b30x[17]||b30x[18]||b30x[19]);
		changeV6 = ~(b30y[15]||b30y[16]||b30y[17]||b30y[18]||b30y[19]);
		changeH7 = ~(b30x[14]||b30x[15]||b30x[16]||b30x[17]||b30x[18]);
		changeV7 = ~(b30y[14]||b30y[15]||b30y[16]||b30y[17]||b30y[18]);
		changeH8 = ~(b30x[13]||b30x[14]||b30x[15]||b30x[16]||b30x[17]);
		changeV8 = ~(b30y[13]||b30y[14]||b30y[15]||b30y[16]||b30y[17]);
		
		
	end
	
	
	always@(posedge clk) begin
			b30x <= {shiftoutx , b30x[29:1]};
			b30y <= {shiftouty , b30y[29:1]};
			if (init)   begin
					b30x <= 30'b 000101001000011001101101010100;
					b30y <= 30'b 011101000011011010101010100101;
					led1 <= 1'b1;
					
			end
		  
			if (ld_load_start)begin

				if (x_count <320 && y_count<240) begin 	
					x_out<= x_count;
					y_out<= y_count;
				end
				
				else begin
					x_out <= 0;
					y_out <= 0;
					x_count <= 0;
					y_count <= 0;	
				end
				
				x_count <= x_count + 1;
				if (x_count > (320-2)) begin
					x_count <= 9'b0;
					y_count <= y_count + 1;
				end
			
				draw <= startscreen;


			end
			
			

			
			if (reset) begin
					score <= 9'b0;
					score_count <= 5'b0;
					gameover <= 1'b0;
					led <= 1'b0;
					led1 <= 1'b0;
					x_you_count <= 9'd 0;
					y_you_count <= 8'd 0;
		
					x_you_prev_out <= 9'd 158;
					y_you_prev_out <= 8'd 118;
					
					eaten <= 1'b0;
					eaten1 <= 1'b0;
					eaten2 <= 1'b0;
					eaten3 <= 1'b0;
					eaten4 <= 1'b0;
					eaten5 <= 1'b0;
					eaten6 <= 1'b0;
					eaten7 <= 1'b0;
					eaten8 <= 1'b0;

					color_out <= 9'd0;
					x_count <= 9'b0;
					y_count <= 8'b0;
					x1_count <= 9'b0;
					y1_count <= 8'b0;
					x2_count <= 9'b0;
					y2_count <= 8'b0;
					x3_count <= 9'b0;
					y3_count <= 8'b0;
					x4_count <= 9'b0;
					y4_count <= 8'b0;
					x5_count <= 9'b0;
					y5_count <= 8'b0;
					x6_count <= 9'b0;
					y6_count <= 8'b0;
					x7_count <= 9'b0;
					y7_count <= 8'b0;
					x8_count <= 9'b0;
					y8_count <= 8'b0;
					
					h <=0;
					v <=0;
					h1 <=0;
					v1 <=0;
					h2 <=0;
					v2 <=0;
					h3 <=0;
					v3 <=0;
					h4 <=0;
					v4 <=0;
					h5 <=0;
					v5 <=0;
					h6 <=0;
					v6 <=0;
					h7 <=0;
					v7 <=0;
					h8 <=0;
					v8 <=0;



			size_you <= 7'd4;
			size <= 7'd2;
			size1 <= 7'd2;
			size2 <= 7'd4;
			size3 <= 7'd8;
			size4 <= 7'd8;
			size5 <= 7'd16;
			size6 <= 7'd16;
			size7 <= 7'd32;
			size8 <= 7'd32;
		
		
		if (b30x[29:21]>(320-size-2)) //once we start changing the size, it will be 160-size-2 eg. for screen 160 & size 4,
					//it needs to be greater than 154 before subtracting
					//so 155 -> 160 inclusive
					//bc if its at 155, the square will reach 159, don't want it to be right on the boundary
					
							x_prev_out <= b30x[29:21]-(320-size-2);
						
					
					else 
						
							x_prev_out <= b30x[29:21];
						
					
							
					if (b30y[29:22]>(240-size-2)) //once we start changing the size, it will be 120-size-2
						
							y_prev_out <= b30y[29:22]-(240-size-2);
						
					
					else
						
							y_prev_out <= b30y[29:22];
						
						

			
			if (b30x[28:20]>(320-size1-2)) //once we start changing the size, it will be 160-size-2 eg. for screen 160 & size 4,
					//it needs to be greater than 154 before subtracting
					//so 155 -> 160 inclusive
					//bc if its at 155, the square will reach 159, don't want it to be right on the boundary
					
							x1_prev_out <= b30x[28:20]-(320-size1-2);
					
					else 
						
							x1_prev_out <= b30x[28:20];
						
							
					if (b30y[28:21]>(240-size1-2)) //once we start changing the size, it will be 120-size-2
						
							y1_prev_out <= b30y[28:21]-(240-size1-2);
						
					else
						
							y1_prev_out <= b30y[28:21];
						
						
						
						
						
			if (b30x[27:19]>(320-size2-2)) //once we start changing the size, it will be 160-size-2 eg. for screen 160 & size 4,
					//it needs to be greater than 154 before subtracting
					//so 155 -> 160 inclusive
					//bc if its at 155, the square will reach 159, don't want it to be right on the boundary
						
							x2_prev_out <= b30x[27:19]-(320-size2-2);
						
					else 
						
							x2_prev_out <= b30x[27:19];
						
							
					if (b30y[27:20]>(240-size2-2)) //once we start changing the size, it will be 120-size-2
						
							y2_prev_out <= b30y[27:20]-(240-size2-2);
							
					else
					
							y2_prev_out <= b30y[27:20];
							
							
							
			if (b30x[26:18]>(320-size3-2))
							x3_prev_out <= b30x[26:18]-(320-size3-2);
					else 
							x3_prev_out <= b30x[26:18];
					if (b30y[26:19]>(240-size3-2)) 
							y3_prev_out <= b30y[26:19]-(240-size3-2);
					else
							y3_prev_out <= b30y[26:19];
							
							
			if (b30x[25:17]>(320-size4-2))
							x4_prev_out <= b30x[25:17]-(320-size4-2);
					else 
							x4_prev_out <= b30x[25:17];
					if (b30y[25:18]>(240-size4-2)) 
							y4_prev_out <= b30y[25:18]-(240-size4-2);
					else
							y4_prev_out <= b30y[25:18];
							
							
			if (b30x[24:16]>(320-size5-2))
							x5_prev_out <= b30x[24:16]-(320-size5-2);
					else 
							x5_prev_out <= b30x[24:16];
					if (b30y[24:17]>(240-size5-2)) 
							y5_prev_out <= b30y[24:17]-(240-size5-2);
					else
							y5_prev_out <= b30y[24:17];
			
			if (b30x[23:15]>(320-size6-2))
							x6_prev_out <= b30x[23:15]-(320-size6-2);
					else 
							x6_prev_out <= b30x[23:15];
					if (b30y[23:16]>(240-size6-2)) 
							y6_prev_out <= b30y[23:16]-(240-size6-2);
					else
							y6_prev_out <= b30y[23:16];
							
			if (b30x[22:14]>(320-size7-2))
							x7_prev_out <= b30x[22:14]-(320-size7-2);
					else 
							x7_prev_out <= b30x[22:14];
					if (b30y[22:15]>(240-size7-2)) 
							y7_prev_out <= b30y[22:15]-(240-size7-2);
					else
							y7_prev_out <= b30y[22:15];
							
			if (b30x[21:13]>(320-size8-2))
							x8_prev_out <= b30x[21:13]-(320-size8-2);
					else 
							x8_prev_out <= b30x[21:13];
					if (b30y[21:14]>(240-size8-2)) 
							y8_prev_out <= b30y[21:14]-(240-size8-2);
					else
							y8_prev_out <= b30y[21:14];
							
							
							
							
							
									
							
							
							
							
							
							
			
			end
					
	
		   if (ld_draw) begin
		  
				if(eaten)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x_count <size && y_count<size) begin 
					x_out<=x_prev_out + x_count;
					y_out<=y_prev_out + y_count;
				end
				else begin
					x_out <= x_prev_out;
					y_out <= y_prev_out;
					x_count <= 0;
					y_count <= 0;
				end
				
				x_count <= x_count + 1;
				
				if (x_count > (size-2)) begin //look this over
					x_count <= 9'b0;
					y_count <= y_count + 1;
				end			
			end
	
			if (ld_draw1) begin
		  
				if(eaten1)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x1_count <size1 && y1_count<size1) begin 
					x_out<=x1_prev_out + x1_count;
					y_out<=y1_prev_out + y1_count;
				end
				else begin
					x_out <= x1_prev_out;
					y_out <= y1_prev_out;
					x1_count <= 0;
					y1_count <= 0;
				end
				
				x1_count <= x1_count + 1;
				
				if (x1_count > (size1-2)) begin //look this over
					x1_count <= 9'b0;
					y1_count <= y1_count + 1;
				end			
			end
			
			
			
			
			
			if (ld_draw2) begin
		  
				if(eaten2)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x2_count <size2 && y2_count<size2) begin 
					x_out<=x2_prev_out + x2_count;
					y_out<=y2_prev_out + y2_count;
				end
				else begin
					x_out <= x2_prev_out;
					y_out <= y2_prev_out;
					x2_count <= 0;
					y2_count <= 0;
				end
				
				x2_count <= x2_count + 1;
				
				if (x2_count > (size2-2)) begin //look this over
					x2_count <= 9'b0;
					y2_count <= y2_count + 1;
				end			
			end
			
			
			if (ld_draw3) begin
		  
				if(eaten3)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x3_count <size3 && y3_count<size3) begin 
					x_out<=x3_prev_out + x3_count;
					y_out<=y3_prev_out + y3_count;
				end
				else begin
					x_out <= x3_prev_out;
					y_out <= y3_prev_out;
					x3_count <= 0;
					y3_count <= 0;
				end
				
				x3_count <= x3_count + 1;
				
				if (x3_count > (size3-2)) begin //look this over
					x3_count <= 9'b0;
					y3_count <= y3_count + 1;
				end			
			end
			
			
			if (ld_draw4) begin
		  
				if(eaten4)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x4_count <size4 && y4_count<size4) begin 
					x_out<=x4_prev_out + x4_count;
					y_out<=y4_prev_out + y4_count;
				end
				else begin
					x_out <= x4_prev_out;
					y_out <= y4_prev_out;
					x4_count <= 0;
					y4_count <= 0;
				end
				
				x4_count <= x4_count + 1;
				
				if (x4_count > (size4-2)) begin //look this over
					x4_count <= 9'b0;
					y4_count <= y4_count + 1;
				end			
			end
			
			if (ld_draw5) begin
		  
				if(eaten5)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x5_count <size5 && y5_count<size5) begin 
					x_out<=x5_prev_out + x5_count;
					y_out<=y5_prev_out + y5_count;
				end
				else begin
					x_out <= x5_prev_out;
					y_out <= y5_prev_out;
					x5_count <= 0;
					y5_count <= 0;
				end
				
				x5_count <= x5_count + 1;
				
				if (x5_count > (size5-2)) begin //look this over
					x5_count <= 9'b0;
					y5_count <= y5_count + 1;
				end			
			end
			
			if (ld_draw6) begin
		  
				if(eaten6)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x6_count <size6 && y6_count<size6) begin 
					x_out<=x6_prev_out + x6_count;
					y_out<=y6_prev_out + y6_count;
				end
				else begin
					x_out <= x6_prev_out;
					y_out <= y6_prev_out;
					x6_count <= 0;
					y6_count <= 0;
				end
				
				x6_count <= x6_count + 1;
				
				if (x6_count > (size6-2)) begin //look this over
					x6_count <= 9'b0;
					y6_count <= y6_count + 1;
				end			
			end
			
			
			
			if (ld_draw7) begin
		  
				if(eaten7)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x7_count <size7 && y7_count<size7) begin 
					x_out<=x7_prev_out + x7_count;
					y_out<=y7_prev_out + y7_count;
				end
				else begin
					x_out <= x7_prev_out;
					y_out <= y7_prev_out;
					x7_count <= 0;
					y7_count <= 0;
				end
				
				x7_count <= x7_count + 1;
				
				if (x7_count > (size7-2)) begin //look this over
					x7_count <= 9'b0;
					y7_count <= y7_count + 1;
				end			
			end
			
			
			
			if (ld_draw8) begin
		  
				if(eaten8)
					draw <= 9'b111111111;
				else
					draw <= color;
				
				if (x8_count <size8 && y8_count<size8) begin 
					x_out<=x8_prev_out + x8_count;
					y_out<=y8_prev_out + y8_count;
				end
				else begin
					x_out <= x8_prev_out;
					y_out <= y8_prev_out;
					x8_count <= 0;
					y8_count <= 0;
				end
				
				x8_count <= x8_count + 1;
				
				if (x8_count > (size8-2)) begin //look this over
					x8_count <= 9'b0;
					y8_count <= y8_count + 1;
				end			
			end
			
			
			
			
			
			
			if (ld_draw_you) begin 
			
			
			
				draw <= 9'b111111111;
				
				if (x_you_count < size_you && y_you_count< size_you) begin 
					x_out<=x_you_prev_out + x_you_count;
					y_out<=y_you_prev_out + y_you_count;
				end
				else begin
					x_out <= x_you_prev_out;
					y_out <= y_you_prev_out;
					x_you_count <= 0;
					y_you_count <= 0;
				end
				
				x_you_count <= x_you_count + 1;
				
				if (x_you_count > (size_you-2)) begin //look this over
					x_you_count <= 9'b0;
					y_you_count <= y_you_count + 1;
				end			
			end
			
			
			
			if (ld_draw_all || ld_draw_start || ld_end) begin

				
				if (x_count <320 && y_count<240) begin 	
					x_out<= x_count;
					y_out<= y_count;
				end
				
				else begin
					x_out <= 0;
					y_out <= 0;
					x_count <= 0;
					y_count <= 0;	
				end
				
				x_count <= x_count + 1;
				if (x_count > (320-2)) begin
					x_count <= 9'b0;
					y_count <= y_count + 1;
				end
			
				color_out <= drawout;
				//if reset, reset the counts & prev stuffs. & clear
				
				
		
			end
			
			
				//prev out is initially 0, then it increments
				
			if (ld_erase) begin

				
				
				if (x_count <320 && y_count<240) begin 	
					x_out<= x_count;
					y_out<= y_count;
				end
				
				else begin
					x_out <= 0;
					y_out <= 0;
					x_count <= 0;
					y_count <= 0;	
				end
				
				x_count <= x_count + 1;
				if (x_count > (320-2)) begin
					x_count <= 9'b0;
					y_count <= y_count + 1;
				end
			
				draw <= erase;
				//if reset, reset the counts & prev stuffs. & clear
				
				
		
			end
			
			
			
			if (ld_h) begin

				if(!eaten)begin
					if (h) //h = 1
						x_prev_out <= x_prev_out - 1;

					else //h = 0
						x_prev_out <= x_prev_out + 1;

					if(changeH)begin
						if(h == 0)
							h <= 1;
						else h<= 0;
					end
					
					if (x_prev_out == (320-size-3))
						h <= 1;

					if (x_prev_out == 1)
						h <= 0;
				end
			end
			
			
			
			
			
			if (ld_h1) begin
				if (!eaten1) begin
					if (h1) //h = 1
						x1_prev_out <= x1_prev_out - 1;

					else //h = 0
						x1_prev_out <= x1_prev_out + 1;

					if(changeH1)begin
						if(h1 == 0)
							h1 <= 1;
						else h1<= 0;
					end
					
					if (x1_prev_out == (320-size1-3))
						h1 <= 1;

					if (x1_prev_out == 1)
						h1 <= 0;
				end
			end
			
			if (ld_h2) begin
				
				if (!eaten2) begin
					if (h2) //h = 1
						x2_prev_out <= x2_prev_out - 1;

					else //h = 0
						x2_prev_out <= x2_prev_out + 1;

					if(changeH2)begin
						if(h2 == 0)
							h2 <= 1;
						else h2<= 0;
					end
					
					if (x2_prev_out == (320-size2-3))
						h2 <= 1;

					if (x2_prev_out == 1)
						h2 <= 0;
			
					end
			end
			
			if (ld_h3) begin
				
				if (!eaten3) begin
					if (h3) //h = 1
						x3_prev_out <= x3_prev_out - 1;

					else //h = 0
						x3_prev_out <= x3_prev_out + 1;

					if(changeH3)begin
						if(h3 == 0)
							h3 <= 1;
						else h3<= 0;
					end
					
					if (x3_prev_out == (320-size3-3))
						h3 <= 1;

					if (x3_prev_out == 1)
						h3 <= 0;
			
					end
			end
			
			
			if (ld_h4) begin
				
				if (!eaten4) begin
					if (h4) //h = 1
						x4_prev_out <= x4_prev_out - 1;

					else //h = 0
						x4_prev_out <= x4_prev_out + 1;

					if(changeH4)begin
						if(h4 == 0)
							h4 <= 1;
						else h4<= 0;
					end
					
					if (x4_prev_out == (320-size4-3))
						h4 <= 1;

					if (x4_prev_out == 1)
						h4 <= 0;
			
					end
			end
			
			
			
			if (ld_h5) begin
				
				if (!eaten5) begin
					if (h5) //h = 1
						x5_prev_out <= x5_prev_out - 1;

					else //h = 0
						x5_prev_out <= x5_prev_out + 1;

					if(changeH5)begin
						if(h5 == 0)
							h5 <= 1;
						else h5<= 0;
					end
					
					if (x5_prev_out == (320-size5-3))
						h5 <= 1;

					if (x5_prev_out == 1)
						h5 <= 0;
			
					end
			end
			
			
			if (ld_h6) begin
				
				if (!eaten6) begin
					if (h6) //h = 1
						x6_prev_out <= x6_prev_out - 1;

					else //h = 0
						x6_prev_out <= x6_prev_out + 1;

					if(changeH6)begin
						if(h6 == 0)
							h6 <= 1;
						else h6<= 0;
					end
					
					if (x6_prev_out == (320-size6-3))
						h6 <= 1;

					if (x6_prev_out == 1)
						h6 <= 0;
			
					end
			end
			
			if (ld_h7) begin
				
				if (!eaten7) begin
					if (h7) //h = 1
						x7_prev_out <= x7_prev_out - 1;

					else //h = 0
						x7_prev_out <= x7_prev_out + 1;

					if(changeH7)begin
						if(h7 == 0)
							h7 <= 1;
						else h7<= 0;
					end
					
					if (x7_prev_out == (320-size7-3))
						h7 <= 1;

					if (x7_prev_out == 1)
						h7 <= 0;
			
					end
			end
			
			if (ld_h8) begin
				
				if (!eaten8) begin
					if (h8) //h = 1
						x8_prev_out <= x8_prev_out - 1;

					else //h = 0
						x8_prev_out <= x8_prev_out + 1;

					if(changeH8)begin
						if(h8 == 0)
							h8 <= 1;
						else h8<= 0;
					end
					
					if (x8_prev_out == (320-size8-3))
						h8 <= 1;

					if (x8_prev_out == 1)
						h8 <= 0;
			
					end
			end
			
			
			
			
			
			
			
			
			
			
			
			
			
			if (ld_v) begin

				if (eaten) begin
					
					
					
					
					if (ps2_last_data == 'h75 && y_prev_out >1)

					y_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x_prev_out >0)

					x_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x_prev_out <= x_you_prev_out +1;
					
					
					
					
					
					
				end
				else begin
				

				x_count <= 9'b0;
				y_count <= 8'b0;
				
				if (v) //v = 1
				y_prev_out <= y_prev_out - 1;
				
				else //v = 0
				y_prev_out <= y_prev_out + 1;
				
				if(changeV)begin
					if(v == 0)
						v <= 1;
					else v<= 0;
				end
				
				if (y_prev_out == (240-size-1))
					v <= 1;
				if (y_prev_out == 1)
					v <= 0;
				end	
			end
			
			if (ld_v1) begin

				if (eaten1) begin
					if (ps2_last_data == 'h75 && y1_prev_out >1)

					y1_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x1_prev_out >0)

					x1_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y1_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y1_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x1_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x1_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x1_count <= 9'b0;
				y1_count <= 8'b0;
				
				if (v1) //v = 1
				y1_prev_out <= y1_prev_out - 1;
				
				else //v = 0
				y1_prev_out <= y1_prev_out + 1;
				
				if(changeV1)begin
					if(v1 == 0)
						v1 <= 1;
					else v1<= 0;
				end
				
				if (y1_prev_out == (240-size1-1))
					v1 <= 1;
				if (y1_prev_out == 1)
					v1 <= 0;
				end	
			end
			
			if (ld_v2) begin

				if (eaten2) begin
					if (ps2_last_data == 'h75 && y2_prev_out >1)

					y2_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x2_prev_out >0)

					x2_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y2_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y2_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x2_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x2_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x2_count <= 9'b0;
				y2_count <= 8'b0;
				
				if (v2) //v = 1
				y2_prev_out <= y2_prev_out - 1;
				
				else //v = 0
				y2_prev_out <= y2_prev_out + 1;
				
				if(changeV2)begin
					if(v2 == 0)
						v2 <= 1;
					else v2<= 0;
				end
				
				if (y2_prev_out == (240-size2-1))
					v2 <= 1;
				if (y2_prev_out == 1)
					v2 <= 0;
				end
			end
		
		
		
		if (ld_v3) begin

				if (eaten3) begin
					if (ps2_last_data == 'h75 && y3_prev_out >1)

					y3_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x3_prev_out >0)

					x3_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y3_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y3_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x3_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x3_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x3_count <= 9'b0;
				y3_count <= 8'b0;
				
				if (v3) //v = 1
				y3_prev_out <= y3_prev_out - 1;
				
				else //v = 0
				y3_prev_out <= y3_prev_out + 1;
				
				if(changeV3)begin
					if(v3 == 0)
						v3 <= 1;
					else v3<= 0;
				end
				
				if (y3_prev_out == (240-size3-1))
					v3 <= 1;
				if (y3_prev_out == 1)
					v3 <= 0;
				end
			end
			
			
			
			if (ld_v4) begin

				if (eaten4) begin
					if (ps2_last_data == 'h75 && y4_prev_out >1)

					y4_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x4_prev_out >0)

					x4_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y4_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y4_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x4_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x4_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x4_count <= 9'b0;
				y4_count <= 8'b0;
				
				if (v4) //v = 1
				y4_prev_out <= y4_prev_out - 1;
				
				else //v = 0
				y4_prev_out <= y4_prev_out + 1;
				
				if(changeV4)begin
					if(v4 == 0)
						v4 <= 1;
					else v4<= 0;
				end
				
				if (y4_prev_out == (240-size4-1))
					v4 <= 1;
				if (y4_prev_out == 1)
					v4 <= 0;
				end
			end
			
			
			if (ld_v5) begin

				if (eaten5) begin
					if (ps2_last_data == 'h75 && y5_prev_out >1)

					y5_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x5_prev_out >0)

					x5_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y5_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y5_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x5_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x5_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x5_count <= 9'b0;
				y5_count <= 8'b0;
				
				if (v5) //v = 1
				y5_prev_out <= y5_prev_out - 1;
				
				else //v = 0
				y5_prev_out <= y5_prev_out + 1;
				
				if(changeV5)begin
					if(v5 == 0)
						v5 <= 1;
					else v5<= 0;
				end
				
				if (y5_prev_out == (240-size5-1))
					v5 <= 1;
				if (y5_prev_out == 1)
					v5 <= 0;
				end
			end
			
			
			if (ld_v6) begin

				if (eaten6) begin
					if (ps2_last_data == 'h75 && y6_prev_out >1)

					y6_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x6_prev_out >0)

					x6_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y6_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y6_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x6_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x6_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x6_count <= 9'b0;
				y6_count <= 8'b0;
				
				if (v6) //v = 1
				y6_prev_out <= y6_prev_out - 1;
				
				else //v = 0
				y6_prev_out <= y6_prev_out + 1;
				
				if(changeV6)begin
					if(v6 == 0)
						v6 <= 1;
					else v6<= 0;
				end
				
				if (y6_prev_out == (240-size6-1))
					v6 <= 1;
				if (y6_prev_out == 1)
					v6 <= 0;
				end
			end
			
			
			
			
			if (ld_v7) begin

				if (eaten7) begin
					if (ps2_last_data == 'h75 && y7_prev_out >1)

					y7_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x7_prev_out >0)

					x7_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y7_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y7_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x7_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x7_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x7_count <= 9'b0;
				y7_count <= 8'b0;
				
				if (v7) //v = 1
				y7_prev_out <= y7_prev_out - 1;
				
				else //v = 0
				y7_prev_out <= y7_prev_out + 1;
				
				if(changeV7)begin
					if(v7 == 0)
						v7 <= 1;
					else v7<= 0;
				end
				
				if (y7_prev_out == (240-size7-1))
					v7 <= 1;
				if (y7_prev_out == 1)
					v7 <= 0;
				end
			end
			
			
			
			if (ld_v8) begin

				if (eaten8) begin
					if (ps2_last_data == 'h75 && y8_prev_out >1)

					y8_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x8_prev_out >0)

					x8_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y8_prev_out < 240 - size_you - 1) //120-size (4) - 1

					y8_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x8_prev_out < 320 - size_you - 2) //160 - size (4) - 1

					x8_prev_out <= x_you_prev_out +1;
				end
				else begin
				

				x8_count <= 9'b0;
				y8_count <= 8'b0;
				
				if (v8) //v = 1
				y8_prev_out <= y8_prev_out - 1;
				
				else //v = 0
				y8_prev_out <= y8_prev_out + 1;
				
				if(changeV8)begin
					if(v8 == 0)
						v8 <= 1;
					else v8<= 0;
				end
				
				if (y8_prev_out == (240-size8-1))
					v8 <= 1;
				if (y8_prev_out == 1)
					v8 <= 0;
				end
			end
			
			
		
	
			if (ld_user) begin
			
				if (ps2_last_data == 'h75 && y_you_prev_out >1)

					y_you_prev_out <= y_you_prev_out - 1;

				if (ps2_last_data == 'h6B && x_you_prev_out >0)

					x_you_prev_out <= x_you_prev_out -1;

				if (ps2_last_data == 'h72 && y_you_prev_out <240-size_you-1) //120-size (4) - 1

					y_you_prev_out <= y_you_prev_out + 1;

				if (ps2_last_data == 'h74 && x_you_prev_out < 320-size_you-2) //160 - size (4) - 1

					x_you_prev_out <= x_you_prev_out +1;
			
			
			end
			
			if (ld_check) begin //updates score & checks for collision
				score_count <= score_count +1;
				if (score_count == 0)
					score <= score+1;
						 
					 
					if((x_you_prev_out + size_you > x_prev_out && x_you_prev_out < x_prev_out + size ) && (y_you_prev_out + size_you > y_prev_out && y_you_prev_out < y_prev_out + size ) && eaten == 1'd0) begin
						if( size < size_you || size == size_you)begin

							if(x_prev_out + size > x_you_prev_out && y_prev_out + size > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out -size;
								y_you_prev_out <= y_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end

							else if(y_prev_out + size > y_you_prev_out && x_you_prev_out + size_you > x_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x_prev_out && y_you_prev_out + size_you > y_prev_out) begin
								size_you <= size_you + size;
								eaten <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y_prev_out && x_prev_out + size > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out -size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end



							else if(x_prev_out + size > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size - size_you - 3 || y_you_prev_out == 240 - size - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size;
								y_you_prev_out <= y_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							end




							else if(y_prev_out + size > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size - size_you - 5 || y_you_prev_out == 240 - size - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size;
								y_you_prev_out <= y_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x_prev_out)begin

							if(y_you_prev_out < 320 - size - size_you - 5) begin
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size - size_you - 5 || y_you_prev_out == 240 - size - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y_prev_out)begin

							if(x_you_prev_out < 240 - size - size_you - 5) begin
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size - size_you - 5 || x_you_prev_out == 240 - size - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size;
								size_you <= size_you + size;
								eaten <= 1'd1;
							end
							end

							score <= score + 15;

						end

						else if( size > size_you )
							gameover <= 1'd1;
					end
					
					




					if((x_you_prev_out + size_you > x1_prev_out && x_you_prev_out < x1_prev_out + size1 ) && (y_you_prev_out + size_you > y1_prev_out && y_you_prev_out < y1_prev_out + size1 ) && eaten1 == 1'd0) begin
						if( size1 < size_you || size1 == size_you)begin

							if(x1_prev_out + size1 > x_you_prev_out && y1_prev_out + size1 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size1;
								y_you_prev_out <= y_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end

							else if(y1_prev_out + size1 > y_you_prev_out && x_you_prev_out + size_you > x1_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x1_prev_out && y_you_prev_out + size_you > y1_prev_out) begin
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y1_prev_out && x1_prev_out + size1 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end



							else if(x1_prev_out + size1 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size1 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size1 - size_you - 5 || y_you_prev_out == 240 - size1 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size1;
								y_you_prev_out <= y_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							end




							else if(y1_prev_out + size1 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size1 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size1 - size_you - 5 || y_you_prev_out == 240 - size1 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size1;
								y_you_prev_out <= y_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x1_prev_out)begin

							if(y_you_prev_out < 320 - size1 - size_you - 5) begin
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size1 - size_you - 5 || y_you_prev_out == 240 - size1 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y1_prev_out)begin

							if(x_you_prev_out < 240 - size1 - size_you - 3) begin
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size1 - size_you - 5 || x_you_prev_out == 240 - size1 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size1;
								size_you <= size_you + size1;
								eaten1 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size1 > size_you )
							gameover <= 1'd1;
					end	
					
					
					
					if((x_you_prev_out + size_you > x2_prev_out && x_you_prev_out < x2_prev_out + size2 ) && (y_you_prev_out + size_you > y2_prev_out && y_you_prev_out < y2_prev_out + size2 ) && eaten2 == 1'd0) begin
						if( size2 < size_you || size2 == size_you)begin

							if(x2_prev_out + size2 > x_you_prev_out && y2_prev_out + size2 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size2;
								y_you_prev_out <= y_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end

							else if(y2_prev_out + size2 > y_you_prev_out && x_you_prev_out + size_you > x2_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x2_prev_out && y_you_prev_out + size_you > y2_prev_out) begin
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y2_prev_out && x2_prev_out + size2 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end



							else if(x2_prev_out + size2 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size2 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size2 - size_you - 5 || y_you_prev_out == 240 - size2 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size2;
								y_you_prev_out <= y_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							end




							else if(y2_prev_out + size2 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size2 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size2 - size_you - 5 || y_you_prev_out == 240 - size2 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size2;
								y_you_prev_out <= y_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x2_prev_out)begin

							if(y_you_prev_out < 320 - size2 - size_you - 5) begin
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size2 - size_you - 5 || y_you_prev_out == 240 - size2 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y2_prev_out)begin

							if(x_you_prev_out < 240 - size2 - size_you - 5) begin
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size2 - size_you - 5 || x_you_prev_out == 240 - size2 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size2;
								size_you <= size_you + size2;
								eaten2 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size2 > size_you )
							gameover <= 1'd1;
					end
					
					
					
					
					if((x_you_prev_out + size_you > x3_prev_out && x_you_prev_out < x3_prev_out + size3 ) && (y_you_prev_out + size_you > y3_prev_out && y_you_prev_out < y3_prev_out + size3 ) && eaten3 == 1'd0) begin
						if( size3 < size_you || size3 == size_you)begin

							if(x3_prev_out + size3 > x_you_prev_out && y3_prev_out + size3 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size3;
								y_you_prev_out <= y_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end

							else if(y3_prev_out + size3 > y_you_prev_out && x_you_prev_out + size_you > x3_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x3_prev_out && y_you_prev_out + size_you > y3_prev_out) begin
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y3_prev_out && x3_prev_out + size3 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end



							else if(x3_prev_out + size3 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size3 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size3 - size_you - 5 || y_you_prev_out == 240 - size3 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size3;
								y_you_prev_out <= y_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							end




							else if(y3_prev_out + size3 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size3 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size3 - size_you - 5 || y_you_prev_out == 240 - size3 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size3;
								y_you_prev_out <= y_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x3_prev_out)begin

							if(y_you_prev_out < 320 - size3 - size_you - 5) begin
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size3 - size_you - 5 || y_you_prev_out == 240 - size3 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y3_prev_out)begin

							if(x_you_prev_out < 240 - size3 - size_you - 5) begin
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size3 - size_you - 5 || x_you_prev_out == 240 - size3 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size3;
								size_you <= size_you + size3;
								eaten3 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size3 > size_you )
							gameover <= 1'd1;
					end
					
					
					
					
					
					
					if((x_you_prev_out + size_you > x4_prev_out && x_you_prev_out < x4_prev_out + size4 ) && (y_you_prev_out + size_you > y4_prev_out && y_you_prev_out < y4_prev_out + size4 ) && eaten4 == 1'd0) begin
						if( size4 < size_you || size4 == size_you)begin

							if(x4_prev_out + size4 > x_you_prev_out && y4_prev_out + size4 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size4;
								y_you_prev_out <= y_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end

							else if(y4_prev_out + size4 > y_you_prev_out && x_you_prev_out + size_you > x4_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x4_prev_out && y_you_prev_out + size_you > y4_prev_out) begin
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y4_prev_out && x4_prev_out + size4 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end



							else if(x4_prev_out + size4 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size4 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size4 - size_you - 5 || y_you_prev_out == 240 - size4 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size4;
								y_you_prev_out <= y_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							end




							else if(y4_prev_out + size4 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size4 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size4 - size_you - 5 || y_you_prev_out == 240 - size4 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size4;
								y_you_prev_out <= y_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x4_prev_out)begin

							if(y_you_prev_out < 320 - size4 - size_you - 5) begin
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size4 - size_you - 5 || y_you_prev_out == 240 - size4 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y4_prev_out)begin

							if(x_you_prev_out < 240 - size4 - size_you - 5) begin
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size4 - size_you - 5 || x_you_prev_out == 240 - size4 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size4;
								size_you <= size_you + size4;
								eaten4 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size4 > size_you )
							gameover <= 1'd1;
					end
					
					
					
					
					
					
					if((x_you_prev_out + size_you > x5_prev_out && x_you_prev_out < x5_prev_out + size5 ) && (y_you_prev_out + size_you > y5_prev_out && y_you_prev_out < y5_prev_out + size5 ) && eaten5 == 1'd0) begin
						if( size5 < size_you || size5 == size_you)begin

							if(x5_prev_out + size5 > x_you_prev_out && y5_prev_out + size5 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size5;
								y_you_prev_out <= y_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end

							else if(y5_prev_out + size5 > y_you_prev_out && x_you_prev_out + size_you > x5_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x5_prev_out && y_you_prev_out + size_you > y5_prev_out) begin
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y5_prev_out && x5_prev_out + size5 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end



							else if(x5_prev_out + size5 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size5 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size5 - size_you - 5 || y_you_prev_out == 240 - size5 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size5;
								y_you_prev_out <= y_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							end




							else if(y5_prev_out + size5 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size5 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size5 - size_you - 5 || y_you_prev_out == 240 - size5 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size5;
								y_you_prev_out <= y_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x5_prev_out)begin

							if(y_you_prev_out < 320 - size5 - size_you - 5) begin
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size5 - size_you - 5 || y_you_prev_out == 240 - size5 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y5_prev_out)begin

							if(x_you_prev_out < 240 - size5 - size_you - 5) begin
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size5 - size_you - 5 || x_you_prev_out == 240 - size5 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size5;
								size_you <= size_you + size5;
								eaten5 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size5 > size_you )
							gameover <= 1'd1;
					end
					
					
					
					
					
					if((x_you_prev_out + size_you > x6_prev_out && x_you_prev_out < x6_prev_out + size6 ) && (y_you_prev_out + size_you > y6_prev_out && y_you_prev_out < y6_prev_out + size6 ) && eaten6 == 1'd0) begin
						if( size6 < size_you || size6 == size_you)begin

							if(x6_prev_out + size6 > x_you_prev_out && y6_prev_out + size6 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size6;
								y_you_prev_out <= y_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end

							else if(y6_prev_out + size6 > y_you_prev_out && x_you_prev_out + size_you > x6_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x6_prev_out && y_you_prev_out + size_you > y6_prev_out) begin
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y6_prev_out && x6_prev_out + size6 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end



							else if(x6_prev_out + size6 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size6 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size6 - size_you - 5 || y_you_prev_out == 240 - size6 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size6;
								y_you_prev_out <= y_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							end




							else if(y6_prev_out + size6 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size6 - size_you - 3) begin
								y_you_prev_out <= y_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size6 - size_you - 5 || y_you_prev_out == 240 - size6 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size6;
								y_you_prev_out <= y_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x6_prev_out)begin

							if(y_you_prev_out < 320 - size6 - size_you - 5) begin
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size6 - size_you - 5 || y_you_prev_out == 240 - size6 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y6_prev_out)begin

							if(x_you_prev_out < 240 - size6 - size_you - 5) begin
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size6 - size_you - 5 || x_you_prev_out == 240 - size6 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size6;
								size_you <= size_you + size6;
								eaten6 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size6 > size_you )
							gameover <= 1'd1;
					end
					
					
					
					
					if((x_you_prev_out + size_you > x7_prev_out && x_you_prev_out < x7_prev_out + size7 ) && (y_you_prev_out + size_you > y7_prev_out && y_you_prev_out < y7_prev_out + size7 ) && eaten7 == 1'd0) begin
						if( size7 < size_you || size7 == size_you)begin

							if(x7_prev_out + size7 > x_you_prev_out && y7_prev_out + size7 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size7;
								y_you_prev_out <= y_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end

							else if(y7_prev_out + size7 > y_you_prev_out && x_you_prev_out + size_you > x7_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x7_prev_out && y_you_prev_out + size_you > y7_prev_out) begin
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y7_prev_out && x7_prev_out + size7 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end



							else if(x7_prev_out + size7 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size7 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size7 - size_you - 5 || y_you_prev_out == 240 - size7 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size7;
								y_you_prev_out <= y_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							end




							else if(y7_prev_out + size7 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size7 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size7 - size_you - 5 || y_you_prev_out == 240 - size7 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size7;
								y_you_prev_out <= y_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x7_prev_out)begin

							if(y_you_prev_out < 320 - size7 - size_you - 5) begin
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size7 - size_you - 5 || y_you_prev_out == 240 - size7 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y7_prev_out)begin

							if(x_you_prev_out < 240 - size7 - size_you - 5) begin
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size7 - size_you - 5 || x_you_prev_out == 240 - size7 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size7;
								size_you <= size_you + size7;
								eaten7 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size7 > size_you )
							gameover <= 1'd1;
					end
					
					
					
					
					if((x_you_prev_out + size_you > x8_prev_out && x_you_prev_out < x8_prev_out + size8 ) && (y_you_prev_out + size_you > y8_prev_out && y_you_prev_out < y8_prev_out + size8 ) && eaten8 == 1'd0) begin
						if( size8 < size_you || size8 == size_you)begin

							if(x8_prev_out + size8 > x_you_prev_out && y8_prev_out + size8 > y_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size8;
								y_you_prev_out <= y_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end

							else if(y8_prev_out + size8 > y_you_prev_out && x_you_prev_out + size_you > x8_prev_out)begin
								y_you_prev_out <= y_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end

							else if(x_you_prev_out + size_you > x8_prev_out && y_you_prev_out + size_you > y8_prev_out) begin
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end

							else if(y_you_prev_out + size_you > y8_prev_out && x8_prev_out + size8 > x_you_prev_out)begin
								x_you_prev_out <= x_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end



							else if(x8_prev_out + size8 > x_you_prev_out)begin

							if(y_you_prev_out < 240 - size8 - size_you - 5) begin
								x_you_prev_out <= x_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							else if(y_you_prev_out > 240 - size8 - size_you - 5 || y_you_prev_out == 240 - size8 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size8;
								y_you_prev_out <= y_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							end




							else if(y8_prev_out + size8 > y_you_prev_out)begin

							if(x_you_prev_out < 320 - size8 - size_you - 5) begin
								y_you_prev_out <= y_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size8 - size_you - 5 || y_you_prev_out == 240 - size8 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out - size8;
								y_you_prev_out <= y_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							end




							else if(x_you_prev_out + size_you > x8_prev_out)begin

							if(y_you_prev_out < 320 - size8 - size_you - 5) begin
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							else if(y_you_prev_out > 320 - size8 - size_you - 5 || y_you_prev_out == 240 - size8 - size_you - 5)begin
								y_you_prev_out <= y_you_prev_out - size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							end



							else if(y_you_prev_out + size_you > y8_prev_out)begin

							if(x_you_prev_out < 240 - size8 - size_you - 5) begin
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							else if(x_you_prev_out > 240 - size8 - size_you - 5 || x_you_prev_out == 240 - size8 - size_you - 5)begin
								x_you_prev_out <= x_you_prev_out -size8;
								size_you <= size_you + size8;
								eaten8 <= 1'd1;
							end
							end

							score <= score + 15;

						end
						else if( size8 > size_you )
							gameover <= 1'd1;
					end
					

					
					
					
				end //end of ld check

			//end
			
			
			if (ld_load_game_over) begin
				gameover <= 1'b0;
				if (x_count <320 && y_count<240) begin 	
					x_out<= x_count;
					y_out<= y_count;
				end
				
				else begin
					x_out <= 0;
					y_out <= 0;
					x_count <= 0;
					y_count <= 0;	
				end
				
				x_count <= x_count + 1;
				if (x_count > (320-2)) begin
					x_count <= 9'b0;
					y_count <= y_count + 1;
				end
			
				draw <= 9'd0;
			
				
		end
		
		
		
		
	 end
	

endmodule




module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule

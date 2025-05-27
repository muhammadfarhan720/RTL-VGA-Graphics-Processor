////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Filename: tb_VGA.sv
// Author:   Muhammad Farhan Azmine
// Date:     May 2024
// Revision: 1
// Description : This testbench is only for validating the synchronization of the hsync and vsync signals of Graphics Processor with top.sv instatiation
////////////////////////////////////////////////////////////////////////////////////////////////////




`timescale 1ns/1ns
module tb_VGA;
	logic   clock, reset_n;
	logic   sync_n, blank_n, hsync_n, vsync_n, vga_clk;
	logic  [7:0] red, green, blue;
	
	top dut(clock,reset_n,sync_n,blank_n,hsync_n,vsync_n,vga_clk,red,green,blue);
	
	
	initial begin
		clock = '0;
		while (1) begin
			#5ns clock <= ~clock;
			end
		end
	
	initial begin
		reset_n = '0;
		//attack_n = '1;
		# 100ns;
		reset_n = '1;
		
		# 200ns;
		//attack_n = '0;
		# 200ns;
		//attack_n = '1;
		
		end

endmodule
		

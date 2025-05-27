module top(
	input  logic   clock,
	input  logic   reset_n,
	input  logic   restart_n,
	input  logic   attack_n,
	input  logic   skill_n,
	output logic   sync_n,
	output logic   blank_n,
	output logic   hsync_n,
	output logic   vsync_n,
	output logic   vga_clk,
	output logic  [7:0] red,
	output logic  [7:0] green,
	output logic  [7:0] blue
	
);
	
	
	logic [9:0] hcount, vcount;
	logic [18:0] fb_addr;
	logic [23:0] fb_rom;
	
	logic cmd_restart, cmd_attack, cmd_skill;
	
	//25.175MHz
	clock_generator vga_clock(
			.refclk(clock),      //  refclk.clk
			.rst(!reset_n),      //   reset.reset
			.outclk_0(vga_clk)   // outclk0.clk
	);
	
	keypress k1(.clock(vga_clk), .reset_n(reset_n), .key_in(restart_n), .enable_out(cmd_restart));
	keypress k2(.clock(vga_clk), .reset_n(reset_n), .key_in(attack_n), .enable_out(cmd_attack));
	keypress k3(.clock(vga_clk), .reset_n(reset_n), .key_in(skill_n), .enable_out(cmd_skill));
	
	
	vga_controller ctr1(
		.vga_clock(vga_clk),
		.reset_n(reset_n),
		.sync_n(sync_n),
		.blank_n(blank_n),
		.hsync_n(hsync_n),
		.vsync_n(vsync_n),
		.hcount(hcount),
		.vcount(vcount)
	);

	pattern_generator pattern_gen1(
		.vga_clock(vga_clk),
		.reset_n(reset_n),
		.cmd_restart(cmd_restart),
		.cmd_attack(cmd_attack),
		.cmd_skill(cmd_skill),
		.hcount(hcount),
		.vcount(vcount),
		.red(red),
		.green(green),
		.blue(blue)
	);
	
	


endmodule

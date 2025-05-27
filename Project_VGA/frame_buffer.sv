module frame_buffer(
	input  logic   clock,
	input  logic [18:0] addr,  // 640 x 480 = 307200
	output logic [23:0] rom

);

	always_ff@(posedge clock) begin
		rom = 24'hff_ff_ff;  // white background
		end


endmodule

module sprite_rom(
	input  logic   clock,
	input  logic [2:0] sprite_index,  // 5 sprites to select
	input  logic [63:0] sprite_row,   // maximum row number is 64
	input  logic [63:0] pixel_index,  // maximum pixel number in each row is 64
	output logic [23:0] rom

);
	// sprite 1: heart, 16x16
	always_ff@(posedge clock) begin
		case ({sprite_row[15:0], pixel_index[15:0]})
		32'h00_00:  rom = 24'hff_00_00;  // test red
		
		
		endcase
	end

	// sprite 2: attack button, 32x48
	always_ff@(posedge clock) begin
		case ({sprite_row[31:0], pixel_index[47:0]})
		80'h0000_000000:  rom = 24'hff_00_00;  // test red
		
		
		endcase
	end
	
	


endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Filename: pattern_generator.sv
// Author:   Muhammad Farhan Azmine
// Date:     May 2024
// Revision: 1
//
// Description: This synchronous finite-state machine generates an ACTIVE-HIGH enable pulse that
//              lasts for one clock period each time an ACTIVE-LOW key is pressed and released.
//
//              Specifically, the enable pulse occurs during the clock period AFTER the key is
//              released.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module pattern_generator(
	input  logic   vga_clock,
	input  logic   reset_n,
	input  logic   cmd_restart,
	input  logic   cmd_attack,
	input  logic   cmd_skill,
	input  logic  [9:0] hcount,
	input  logic  [9:0] vcount,
	output logic  [7:0] red,
	output logic  [7:0] green,
	output logic  [7:0] blue
);

	logic  [18:0] fb_addr;
	logic  [23:0] fb_rom;
	logic  [11:0] pr_addr;
	logic  [7:0]  prr_rom,prg_rom,prb_rom;
	logic  [11:0] er_addr;
	logic  [7:0]  err_rom,erg_rom,erb_rom;
	logic  [8:0]  hr_addr;
	logic  [7:0]  hrr_rom,hrg_rom,hrb_rom;
	
	logic  [10:0]  ar_addr;
	logic  [7:0]  arr_rom,arg_rom,arb_rom;
	
	logic  [9:0]  rr_addr;
	logic  [7:0]  rrr_rom,rrg_rom,rrb_rom;
	// New
	logic  [8:0]  ch_name_addr;
	logic  [7:0]  ch_namer_rom,ch_nameg_rom,ch_nameb_rom;
	
	logic  [9:0]  pika_name_addr;
	logic  [7:0]  pika_namer_rom,pika_nameg_rom,pika_nameb_rom;
	
	logic  [11:0]  flameat_addr;
	logic  [7:0]   flameatr_rom,flameatg_rom,flameatb_rom;
	
	logic  [11:0]  dragon_addr;
	logic  [7:0]   dragonr_rom,dragong_rom,dragonb_rom;
	
	
	// --------------  ROM with the white background --------------
	// 19-bit input, 24-bit output
	frame_buffer fb(.clock(vga_clock), .addr(fb_addr), .rom(fb_rom));
	// RGB roms for Pikachu
	// for each rom, 12-bit input for 64x64 pixels, 8-bit output
	pika_rom_r prr(.clock(vga_clock), .address(pr_addr), .data_out(prr_rom));
	pika_rom_g prg(.clock(vga_clock), .address(pr_addr), .data_out(prg_rom));
	pika_rom_b prb(.clock(vga_clock), .address(pr_addr), .data_out(prb_rom));
	// RGB roms for ekans/Charmander
	// for each rom, 12-bit input for 64x64 pixels
	ekans_rom_r err(.clock(vga_clock), .address(er_addr), .data_out(err_rom));
	ekans_rom_g erg(.clock(vga_clock), .address(er_addr), .data_out(erg_rom));
	ekans_rom_b erb(.clock(vga_clock), .address(er_addr), .data_out(erb_rom));
	// RGB roms for heart
	// for each rom, 8-bit for 16 x 16 pixels
	heart_rom_r hrr(.clock(vga_clock), .address(hr_addr), .data_out(hrr_rom));
	heart_rom_g hrg(.clock(vga_clock), .address(hr_addr), .data_out(hrg_rom));
	heart_rom_b hrb(.clock(vga_clock), .address(hr_addr), .data_out(hrb_rom));
	// RGB roms for attack
	// for each rom, 10-bit for 32 x 32 pixels
	attack_rom_r arr(.clock(vga_clock), .address(ar_addr), .data_out(arr_rom));
	attack_rom_g arg(.clock(vga_clock), .address(ar_addr), .data_out(arg_rom));
	attack_rom_b arb(.clock(vga_clock), .address(ar_addr), .data_out(arb_rom));
	// RGB roms for run
	// for each rom, 10-bit for 32 x 32 pixels
	run_rom_r rrr(.clock(vga_clock), .address(rr_addr), .data_out(rrr_rom));
	run_rom_g rrg(.clock(vga_clock), .address(rr_addr), .data_out(rrg_rom));
	run_rom_b rrb(.clock(vga_clock), .address(rr_addr), .data_out(rrb_rom));
	// roms for flameat (flame image)
	flameat_rom_r flmr(.clock(vga_clock), .address(flameat_addr), .data_out(flameatr_rom));
	flameat_rom_g flmg(.clock(vga_clock), .address(flameat_addr), .data_out(flameatg_rom));
	flameat_rom_b flmb(.clock(vga_clock), .address(flameat_addr), .data_out(flameatb_rom));
	// roms for Charmander's name
	char_rom_r chr(.clock(vga_clock), .address(ch_name_addr), .data_out(ch_namer_rom));
	char_rom_g chg(.clock(vga_clock), .address(ch_name_addr), .data_out(ch_nameg_rom));
	char_rom_b chb(.clock(vga_clock), .address(ch_name_addr), .data_out(ch_nameb_rom));
	// roms for pikachu's name
	pika_name_r pknr(.clock(vga_clock), .address(pika_name_addr), .data_out(pika_namer_rom));
	pika_name_g pkng(.clock(vga_clock), .address(pika_name_addr), .data_out(pika_nameg_rom));
	pika_name_b pknb(.clock(vga_clock), .address(pika_name_addr), .data_out(pika_nameb_rom));
	// roms for dragon (envolved charmander)
	dragon_rom_r drgr(.clock(vga_clock), .address(dragon_addr), .data_out(dragonr_rom));
	dragon_rom_g drgg(.clock(vga_clock), .address(dragon_addr), .data_out(dragong_rom));
	dragon_rom_b drgb(.clock(vga_clock), .address(dragon_addr), .data_out(dragonb_rom));
	
	
	//---------------   Set the address and read the roms   ------------------
	localparam int STEP = 2;  // step for the continuous movement
	localparam int CNT_FLASH = 180;  // the flashrate, keep one frame for 29, 120, 180 flashes
	
	localparam int PIKANAME_START_X=400 ,PIKANAME_START_Y=165;
	localparam int PIKA_START_X=400, PIKA_START_Y=100;
	logic [9:0] pika_start_x, pika_start_y;
	logic [9:0] pikaname_start_x, pikaname_start_y;
	
	localparam int CHARNAME_START_X=100 ,CHARNAME_START_Y=365; // for char's name
	localparam int EKANS_START_X=100,EKANS_START_Y=300;  // for charmander sprite
	localparam int DRAGON_START_X=100 ,DRAGON_START_Y=100;  // for dragon sprite
	logic [9:0] ekans_start_x, ekans_start_y;
	logic [9:0] charname_start_x, charname_start_y;
	logic       char_status;  // 0 for charmander, 1 for dragon
	
	localparam int RUN_START_X=400 ,RUN_START_Y=340;       // for tackle option (normal attack)
	logic [9:0] tackle_start_x, tackle_start_y;
	
	localparam int ATTACK_START_X=400 ,ATTACK_START_Y=360; // for flame option
	logic [9:0] flame_start_x, flame_start_y;
	
	localparam int FLAMEAT_START_X=210 ,FLAMEAT_START_Y=260; // for flame image
	logic [9:0] flameat_start_x, flameat_start_y;
	logic       flame_status;  // 0,1 the flame exist or not
	
   localparam int HEART_START_X=400 ,HEART_START_Y=80;    // for heart sprite
	logic [9:0] heart1_start_x, heart1_start_y;
	localparam int HEART_POS2_START_X=20;                   // for other hearts
	logic [1:0] heart_count;

	//localparam int RAICHU_START_X=200 ,RAICHU_START_Y=200;

	
	always_comb begin
		// pikachu, attack
		pr_addr = 0;
		er_addr=0;
		ar_addr=0;
		rr_addr=0;
		hr_addr=0;
		ch_name_addr=0;
		pika_name_addr=0;
		flameat_addr=0;
		dragon_addr=0;
		
		// for pikachu sprite
		if (((hcount>=pika_start_x)&&(hcount<pika_start_x+64)) 
						&& ((vcount>=pika_start_y)&&(vcount<pika_start_y+64))) begin
			pr_addr = 64 * (vcount-pika_start_y) + (hcount-pika_start_x);
			end
		// for enermy/ekans/charmander sprite
	   else if (((hcount>=ekans_start_x)&&(hcount<ekans_start_x+64)) 
						&& ((vcount>=ekans_start_y)&&(vcount<ekans_start_y+64))) begin
			er_addr = 64 * (vcount-ekans_start_y) + (hcount-ekans_start_x);
			dragon_addr = 64 * (vcount-ekans_start_y) + (hcount-ekans_start_x);
			end
		// for flame option
		else if (((hcount>=flame_start_x)&&(hcount<flame_start_x+64)) 
						&& ((vcount>=flame_start_y)&&(vcount<flame_start_y+24))) begin
			ar_addr = 64* (vcount-flame_start_y) + (hcount-flame_start_x);
			end
		// for tackle option
		else if (((hcount>=tackle_start_x)&&(hcount<tackle_start_x+64)) 
						&& ((vcount>=tackle_start_y)&&(vcount<tackle_start_y+13))) begin
			rr_addr = (64 * (vcount-tackle_start_y)) + (hcount-tackle_start_x);
			end
		// for flame image
		else if (((hcount>=flameat_start_x)&&(hcount<flameat_start_x+64)) 
						&& ((vcount>=flameat_start_y)&&(vcount<flameat_start_y+43))) begin
			flameat_addr = (64 * (vcount-flameat_start_y)) + (hcount-flameat_start_x);
			end	
		// for charmander name
		else if (((hcount>=charname_start_x)&&(hcount<charname_start_x+64)) 
						&& ((vcount>=charname_start_y)&&(vcount<charname_start_y+7))) begin
			ch_name_addr = (64 * (vcount-charname_start_y)) + (hcount-charname_start_x);
			end
		// for pikachu name	
	   else if (((hcount>=pikaname_start_x)&&(hcount<pikaname_start_x+64)) 
						&& ((vcount>=pikaname_start_y)&&(vcount<pikaname_start_y+11))) begin
			pika_name_addr = (64 * (vcount-pikaname_start_y)) + (hcount-pikaname_start_x);
			end
		// for dragon image	
		else if (((hcount>=DRAGON_START_X)&&(hcount<DRAGON_START_X+64)) 
						&& ((vcount>=DRAGON_START_Y)&&(vcount<DRAGON_START_Y+64))) begin
			dragon_addr = (64 * (vcount-DRAGON_START_Y)) + (hcount-DRAGON_START_X);
			end
		// for heart image
		else if (((hcount>=heart1_start_x)&&(hcount<heart1_start_x+20)) 
					&& ((vcount>=heart1_start_y)&&(vcount<heart1_start_y+18))) begin
			hr_addr = (20 * (vcount-heart1_start_y)) + (hcount-heart1_start_x);
		end
		// for heart2 image
		else if (((hcount>=heart1_start_x+HEART_POS2_START_X)&&(hcount<heart1_start_x+2*HEART_POS2_START_X)) 
					&& ((vcount>=heart1_start_y)&&(vcount<heart1_start_y+18))) begin
			hr_addr = (20 * (vcount-heart1_start_y)) + (hcount-heart1_start_x);
		end
		// for heart3 image
		else if (((hcount>=heart1_start_x+2*HEART_POS2_START_X)&&(hcount<heart1_start_x+3*HEART_POS2_START_X)) 
					&& ((vcount>=heart1_start_y)&&(vcount<heart1_start_y+18))) begin
			hr_addr = (20 * (vcount-heart1_start_y)) + (hcount-heart1_start_x);
		end
			
			
	end
	
	always_ff@(posedge vga_clock, negedge reset_n) begin
		if (!reset_n) begin
			{red, green, blue} <= 24'hff_ff_ff;
			end
		else begin
			
			// for pikachu
			if (((hcount>=pika_start_x)&&(hcount<pika_start_x+64)) 
						&& ((vcount>=pika_start_y)&&(vcount<pika_start_y+64)))
				{red, green, blue} <= (heart_count == 'b00)  ? 24'hff_00_00
																			: {prr_rom<<4,prg_rom<<4,prb_rom<<4};
			// for charmander	
			else if (((hcount>=ekans_start_x)&&(hcount<ekans_start_x+64)) 
						&& ((vcount>=ekans_start_y)&&(vcount<ekans_start_y+64)))
				{red, green, blue} <= char_status ? {dragonr_rom<<4,dragong_rom<<4,dragonb_rom<<4}
															 : {err_rom<<4,erg_rom<<4,erb_rom<<4};
		   // for Flame option	
			else if (((hcount>=flame_start_x)&&(hcount<flame_start_x+64)) 
						&& ((vcount>=flame_start_y)&&(vcount<flame_start_y+24)))
				{red, green, blue} <= {arr_rom<<4,arg_rom<<4,arb_rom<<4};
			// for Tackle option
			else if (((hcount>=tackle_start_x)&&(hcount<tackle_start_x+64)) 
						&& ((vcount>=tackle_start_y)&&(vcount<tackle_start_y+13)))
				{red, green, blue} <= {rrr_rom<<4,rrg_rom<<4,rrb_rom<<4};
			// for Flame image	
			else if (((hcount>=flameat_start_x)&&(hcount<flameat_start_x+64)) 
						&& ((vcount>=flameat_start_y)&&(vcount<flameat_start_y+43)))
				{red, green, blue} <= flame_status ? {flameatr_rom<<4,flameatg_rom<<4,flameatb_rom<<4}
															  : 24'hff_ff_ff;		
			// for charmander name	
			else if (((hcount>=CHARNAME_START_X)&&(hcount<CHARNAME_START_X+64)) 
						&& ((vcount>=CHARNAME_START_Y)&&(vcount<CHARNAME_START_Y+7)))
				{red, green, blue} <= {ch_namer_rom<<4,ch_nameg_rom<<4,ch_nameb_rom<<4};	
			// for pikachu name
			else if (((hcount>=PIKANAME_START_X)&&(hcount<PIKANAME_START_X+64)) 
						&& ((vcount>=PIKANAME_START_Y)&&(vcount<PIKANAME_START_Y+11)))
				{red, green, blue} <= {pika_namer_rom<<4,pika_nameg_rom<<4,pika_nameb_rom<<4};	
			// for dragon 		
//			else if (((hcount>=DRAGON_START_X)&&(hcount<DRAGON_START_X+64)) 
//						&& ((vcount>=DRAGON_START_Y)&&(vcount<DRAGON_START_Y+64)))
//				{red, green, blue} <= {dragonr_rom<<4,dragong_rom<<4,dragonb_rom<<4};		
			// for heart1									
			else if (((hcount>=HEART_START_X)&&(hcount<HEART_START_X+20)) 
						&& ((vcount>=HEART_START_Y)&&(vcount<HEART_START_Y+18)))
				{red, green, blue} <= (heart_count != 'b00)  ? {hrr_rom<<4,hrg_rom<<4,hrb_rom<<4}
																         : 24'hff_ff_ff;	
			// for heart2
			else if (((hcount>=HEART_START_X+HEART_POS2_START_X)&&(hcount<HEART_START_X+2*HEART_POS2_START_X)) 
						&& ((vcount>=HEART_START_Y)&&(vcount<HEART_START_Y+18)))
				{red, green, blue} <= (heart_count[1] == 'b1) ? {hrr_rom<<4,hrg_rom<<4,hrb_rom<<4}
																        : 24'hff_ff_ff;
			// for heart3
			else if (((hcount>=HEART_START_X+2*HEART_POS2_START_X)&&(hcount<HEART_START_X+3*HEART_POS2_START_X)) 
						&& ((vcount>=HEART_START_Y)&&(vcount<HEART_START_Y+18)))
				{red, green, blue} <= (heart_count == 'b11) ? {hrr_rom<<4,hrg_rom<<4,hrb_rom<<4}
																        : 24'hff_ff_ff; 
			
			// for background
			else
				{red, green, blue} <= 24'hff_ff_ff;
			end
		end	
		
	
	// ----------------   FSM for the sprite control -----------

	localparam [3:0] STATIC = 4'd0; 
	localparam [3:0] ATTACK1 = 4'd1, ATTACK2 = 4'd2, ATTACK3 = 4'd3, ATTACK4 = 4'd4;
	localparam [3:0] EVOLUTION1 = 4'd5, EVOLUTION2 = 4'd6;
	localparam [3:0] SKILL1 = 4'd7, SKILL2 = 4'd8, SKILL3 = 4'd9;
	
	
	logic [3:0] cur_state, next_state;
	
	
	//----------- current state update -------
	always_ff@(posedge vga_clock, negedge reset_n) begin
		if (!reset_n)
			cur_state <= STATIC;
		else 
			cur_state <= next_state;
		end
		
	//---------- counters for FSM ----------
	localparam  ATTACK_MOVE = 20, SHAKE_MOVE = 4, FLAME_KEEP = 20;
	logic [13:0] cnt_flash;
	logic [5:0] cnt_attack, cnt_flame;  
	logic [3:0] cnt_shake;
	logic       skill_active;
	
	always_ff@(posedge vga_clock, negedge reset_n) begin
		if (!reset_n) begin
			cnt_flash <= 'd0;
			cnt_attack <= 'd0;
			cnt_shake <= 'd0;
			//cnt_flame <= 'd0;
			
			ekans_start_x <= EKANS_START_X;
			ekans_start_y <= EKANS_START_Y;
			charname_start_x <= CHARNAME_START_X;
			charname_start_y <= CHARNAME_START_Y;
			pika_start_x <= PIKA_START_X;
			pika_start_y <= PIKA_START_Y;
			pikaname_start_x <= PIKANAME_START_X;
			pikaname_start_x <= PIKANAME_START_Y;
			heart1_start_x <= HEART_START_X;
			heart1_start_y <= HEART_START_Y;
			tackle_start_x <= RUN_START_X;
			tackle_start_y <= RUN_START_Y;
			flame_start_x <= ATTACK_START_X;
			flame_start_y <= ATTACK_START_Y;
			flameat_start_x <= FLAMEAT_START_X;
			flameat_start_y <= FLAMEAT_START_Y;
			
			char_status <= '0;
			heart_count <= 'd3;
			skill_active <= '0;
			flame_status <= '0;
			
			end
		else begin
			case (cur_state)
				STATIC:  begin
							
							ekans_start_x <= EKANS_START_X;
							ekans_start_y <= EKANS_START_Y;
							charname_start_x <= CHARNAME_START_X;
							charname_start_y <= CHARNAME_START_Y;
							pika_start_x <= PIKA_START_X;
							pika_start_y <= PIKA_START_Y;
							pikaname_start_x <= PIKANAME_START_X;
							pikaname_start_y <= PIKANAME_START_Y;
							heart1_start_x <= HEART_START_X;
							heart1_start_y <= HEART_START_Y;
							tackle_start_x <= RUN_START_X;
							tackle_start_y <= RUN_START_Y;
							flame_start_x <= ATTACK_START_X;
							flame_start_y <= ATTACK_START_Y;
							flameat_start_x <= FLAMEAT_START_X;
							flameat_start_y <= FLAMEAT_START_Y;
							
							char_status <= char_status;
							heart_count <= heart_count;
							
							if (cmd_attack) begin
								cnt_attack <= 'd0;
								cnt_flash  <= 'd0;
								skill_active <= 'd0;
								end
							else if (cmd_skill) begin
								cnt_attack <= 'd0;
								cnt_flash  <= 'd0;
								skill_active <= 'd1;
								end
								
							end
				
				ATTACK1: begin
							if (cnt_flash == CNT_FLASH) begin
								cnt_flash <= 'd0;
								if (cnt_attack == ATTACK_MOVE)
									cnt_attack <= 'd0;  // start ATTACK2
								else begin
									cnt_attack <= cnt_attack + 'd1;
									ekans_start_x <= ekans_start_x + STEP;
									ekans_start_y <= ekans_start_y - STEP;
									end
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
				
				ATTACK2: begin
							if (cnt_flash == CNT_FLASH) begin
								cnt_flash <= 'd0;
								if (cnt_attack == ATTACK_MOVE) begin
									cnt_shake <= 'd0;  // start ATTACK3
									char_status <= '1; // the dragon comes
									if (skill_active) begin
										flame_status<='1;  // show the flame
										//cnt_flame <= '0;
										end
									end
								else begin
									cnt_attack <= cnt_attack + 'd1;
									ekans_start_x <= ekans_start_x - STEP;
									ekans_start_y <= ekans_start_y + STEP;
									end
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
				
				SKILL1:  begin
							if (cnt_flash == FLAME_KEEP*CNT_FLASH) begin
								cnt_flash <= 'd0;  // start SKILL2
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
				
				SKILL2:  begin
							if (cnt_flash == FLAME_KEEP*CNT_FLASH) begin
								cnt_flash <= 'd0;  // start SKILL3
								flameat_start_x <= flameat_start_x + 6*STEP;
								flameat_start_y <= flameat_start_y - 6*STEP;
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
				
				SKILL3:  begin
							if (cnt_flash == FLAME_KEEP*CNT_FLASH) begin
								cnt_flash <= 'd0;  // start ATTACK3
								flameat_start_x <= flameat_start_x + 6*STEP;
								flameat_start_y <= flameat_start_y - 6*STEP;
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
							
				ATTACK3: begin
							if (cnt_flash == CNT_FLASH) begin
								cnt_flash <= 'd0;
								if (cnt_shake == SHAKE_MOVE)
									cnt_shake <= 'd0;  // start ATTACK4
								else begin
									cnt_shake <= cnt_shake + 'd1;
									
									pika_start_x <= pika_start_x + STEP;
									pikaname_start_x <= pikaname_start_x + STEP;
									heart1_start_x <= heart1_start_x + STEP;
									if (skill_active)
										flame_start_x <= flame_start_x + STEP;
									else
										tackle_start_x <= tackle_start_x + STEP;
									
									end
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
				
				ATTACK4: begin
							if (cnt_flash == CNT_FLASH) begin
								cnt_flash <= 'd0;
								if (cnt_shake == SHAKE_MOVE) begin
									cnt_shake <= 'd0; 
									heart_count <= heart_count - 'd1;  // remove the heart
									skill_active <= '0;  // reset the skill and flame
									flame_status <= '0;
									end
								else begin
									cnt_shake <= cnt_shake + 'd1;
									
									pika_start_x <= pika_start_x - STEP;
									pikaname_start_x <= pikaname_start_x - STEP;
									heart1_start_x <= heart1_start_x - STEP;
									if (skill_active)
										flame_start_x <= flame_start_x - STEP;
									else
										tackle_start_x <= tackle_start_x - STEP;
									end
								end
							else if (vcount == 524)
								cnt_flash <= cnt_flash + 'd1;
							else
								cnt_flash <= cnt_flash;
							end
					
				endcase
			end
		end

				
				
			
	
	
	//----------- state transfer ------------
	always_comb begin
		case(cur_state)
			STATIC: 	begin
						if (cmd_attack || cmd_skill)
							next_state = ATTACK1;
						else if (cmd_skill)
							next_state = SKILL1;
						else
							next_state = STATIC;
						end
						
			// ATTACK1 for diagnol move up
			ATTACK1: begin
						if ((cnt_attack == ATTACK_MOVE) && (cnt_flash == CNT_FLASH))
							next_state = ATTACK2;
						else 
							next_state = ATTACK1;
						end
						
			// ATTACK2 for diagnol move down/back
			ATTACK2: begin
						if ((cnt_attack == ATTACK_MOVE) && (cnt_flash == CNT_FLASH) && (skill_active=='0))
							next_state = ATTACK3;
						else if ((cnt_attack == ATTACK_MOVE) && (cnt_flash == CNT_FLASH) && (skill_active=='1))
							next_state = SKILL1;
						else
							next_state = ATTACK2;
						end
			
			// SKILL1 for the first flame
			SKILL1: begin
						if (cnt_flash == FLAME_KEEP*CNT_FLASH)
							next_state = SKILL2;
						else
							next_state = SKILL1;
						end
						
			// SKILL2 for the second flame
			SKILL2: begin
						if (cnt_flash == FLAME_KEEP*CNT_FLASH)
							next_state = SKILL3;
						else
							next_state = SKILL2;
						end
			
			// SKILL3 for the third flame
			SKILL3: begin
						if (cnt_flash == FLAME_KEEP*CNT_FLASH)
							next_state = ATTACK3;
						else
							next_state = SKILL3;
						end
			
			// ATTACK3 for shake left
			ATTACK3: begin
						if ((cnt_shake == SHAKE_MOVE) && (cnt_flash == CNT_FLASH))
							next_state = ATTACK4;
						else 
							next_state = ATTACK3;
						end
			
			// ATTACK4 for shake right/back
			ATTACK4: begin
						if ((cnt_shake == SHAKE_MOVE) && (cnt_flash == CNT_FLASH))
							next_state = STATIC;
						else 
							next_state = ATTACK4;
						end
			
			
			
			// Default case
			default: next_state = STATIC;
			
		endcase
	end
						
		
		
		
		
		
		
		
		
	
		
		
		
		
//-----------------------------------------------------

//	logic [20:0] cnt;
//	logic flag;
//	always_ff@(posedge vga_clock, negedge reset_n) begin
//		if (!reset_n) begin
//			flag <= '0;
//			cnt <= 'd0;
//			end
//		else begin
//			if(cnt == 'd100) begin
//				cnt <='d0;
//				flag <= ~ flag;
//				end
//			else if(vcount == 524)
//				cnt <= cnt + 'd1;
//			else
//				cnt <= cnt;
//			end
//		end
//	assign {red, green, blue} = flag ? {8'h0e, 8'h0e, 8'h0e} : {8'h04, 8'h04, 8'h04};
////	assign {red, green, blue} = flag ? {8'hff, 8'h00, 8'h00} : {8'h00, 8'h00, 8'hff};
	
			

endmodule

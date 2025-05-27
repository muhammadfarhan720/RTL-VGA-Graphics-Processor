transcript on
if ![file isdirectory Project_VGA_iputf_libs] {
	file mkdir Project_VGA_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/clock_generator_sim/clock_generator.vo"
vlog "C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/PLL_30_sim/PLL_30.vo"                  
vlog "C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/PLL_10_sim/PLL_10.vo"                  

vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/run_rom_r.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/run_rom_g.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/run_rom_b.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/pika_rom_r.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/pika_rom_g.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/pika_rom_b.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/heart_rom_r.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/heart_rom_g.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/heart_rom_b.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/ekans_rom_r.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/ekans_rom_g.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/ekans_rom_b.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/attack_rom_r.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/attack_rom_g.v}
vlog -vlog01compat -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/sprite_roms/attack_rom_b.v}
vlog -sv -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/frame_buffer.sv}
vlog -sv -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/vga_controller.sv}
vlog -sv -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/top.sv}
vlog -sv -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/pattern_generator.sv}

vlog -sv -work work +incdir+C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA {C:/Users/chunx/OneDrive/Desktop/4514Course/Projects/Project_VGA/tb_VGA.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_VGA

add wave *
view structure
view signals
run -all

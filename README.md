# RTL-VGA-Graphics-Processor
This project implements RTL SystemVerilog design of a custom graphics processor pipeline, with real-time VGA signal generation and spriteROM rendering through FSM-based control logic and PLL-generated IP clocks.

![Demo_Picture](https://github.com/user-attachments/assets/e08c27a1-c6af-4389-b2a0-bbda1134e241)



## Key Features
- **Custom Graphics Processor**: Designed a game scenario through SpriteROM bitmap generation for 24-bit RGB VGA color pixel vectors and controlled sprite movement through FSM controller based pixel synchronization with VGA scanner pixel counters.
- **24-bit RGB VGA Output**: Real-time pixel generation from Sprite ROM memory frame buffer to VGA using bitmap sprite data.
- **Precise VGA Timing**: VGA scanner controller implemented using pixel and line counters with synchronization FSM.
- **PLL-IP Integration**:  Performed  clock synchronization among VGA scanner controller, FSM \& key debouncing circuit through Phased-Locked-Loop IP generated clock at 25.175 MHz


## Most important RTL files
- pattern_generator.sv
- vga_controller.sv
- top.sv
- bitmap of Sprites sprite_roms folder for storage in frame buffer
  



## Technologies

- SystemVerilog HDL
- PLL IP Cores
- VGA Scanner Protocol
- FSM-based design
- Altera Cyclone V FPGA (Intel Quartus II)

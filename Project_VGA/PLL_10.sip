set_global_assignment -entity "PLL_10" -library "lib_PLL_10" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_10" -library "lib_PLL_10" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "PLL_10" -library "lib_PLL_10" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_10" -name SPD_FILE [file join $::quartus(sip_path) "PLL_10.spd"]

set_global_assignment -library "lib_PLL_10" -name MISC_FILE [file join $::quartus(sip_path) "PLL_10_sim/PLL_10.vo"]

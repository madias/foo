package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "mjl_stratix"]} {
		puts "Project mjl_stratix is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists mjl_stratix]} {
		project_open -revision mjl_stratix mjl_stratix
	} else {
		project_new -revision mjl_stratix mjl_stratix
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY Stratix
	set_global_assignment -name DEVICE EP1S25F672C6
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name USE_GENERATED_PHYSICAL_CONSTRAINTS OFF -section_id eda_blast_fpga
	set_global_assignment -name MISC_FILE "mjl_stratix.dpf"
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED WITH WEAK PULL-UP"
	set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "AS INPUT TRI-STATED"

	set_global_assignment -name TOP_LEVEL_ENTITY debounce_top
	set_global_assignment -name VHDL_FILE ../src/counter.vhd
	set_global_assignment -name VHDL_FILE ../src/counter_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_fsm.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_fsm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_struct.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_top.vhd
	set_global_assignment -name VHDL_FILE ../src/debounce_top_struct.vhd
	set_global_assignment -name VHDL_FILE ../src/event_counter.vhd
	set_global_assignment -name VHDL_FILE ../src/event_counter_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/event_counter_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/math_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/sync.vhd
	set_global_assignment -name VHDL_FILE ../src/sync_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/sync_pkg.vhd
#by me.
	set_global_assignment -name VHDL_FILE ../src/cnt_to_vga.vhd
	set_global_assignment -name VHDL_FILE ../src/cnt_to_vga_4_cmds.vhd
	set_global_assignment -name VHDL_FILE ../src/cnt_to_vga_first_light.vhd
	set_global_assignment -name VHDL_FILE ../src/cnt_to_vga_pkg.vhd

	set_global_assignment -name VHDL_FILE ../src/vga/console_sm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/console_sm_sync_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/console_sm_sync.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/console_sm.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/font_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/font_rom_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/font_rom.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/interval_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/interval.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_component_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_h_sm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_h_sm.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_platform_dependent_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_struct.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_v_sm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/textmode_vga_v_sm.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/video_memory_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/vga/video_memory.vhd

	set_location_assignment PIN_T2 -to seg_b[6]
	set_location_assignment PIN_AA11 -to seg_b[5]
	set_location_assignment PIN_R6 -to seg_b[4]
	set_location_assignment PIN_R4 -to seg_b[3]
	set_location_assignment PIN_N8 -to seg_b[2]
	set_location_assignment PIN_Y11 -to seg_b[0]
	set_location_assignment PIN_N7 -to seg_b[1]
	set_location_assignment PIN_R23 -to seg_a[6]
	set_location_assignment PIN_R22 -to seg_a[5]
	set_location_assignment PIN_R21 -to seg_a[4]
	set_location_assignment PIN_R20 -to seg_a[3]
	set_location_assignment PIN_R19 -to seg_a[2]
	set_location_assignment PIN_R9 -to seg_a[1]
	set_location_assignment PIN_R8 -to seg_a[0]
	set_location_assignment PIN_N3 -to sys_clk
	set_location_assignment PIN_AF17 -to sys_res_n
    set_location_assignment PIN_A3 -to btn_a
    set_location_assignment PIN_A5 -to btn_b

    set_location_assignment PIN_E22 -to vga_r0
    set_location_assignment PIN_T4  -to vga_r1
    set_location_assignment PIN_T7  -to vga_r2
    set_location_assignment PIN_E23 -to vga_g0
    set_location_assignment PIN_T5  -to vga_g1
    set_location_assignment PIN_T24 -to vga_g2
    set_location_assignment PIN_E24 -to vga_b0
    set_location_assignment PIN_T6  -to vga_b1
    set_location_assignment PIN_F1  -to vga_hsync_n
    set_location_assignment PIN_F2  -to vga_vsync_n

	set_global_assignment -name FMAX_REQUIREMENT "33.33 MHz" -section_id sys_clk
	set_instance_assignment -name CLOCK_SETTINGS sys_clk -to sys_clk

	set_global_assignment -name LL_ROOT_REGION ON -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "Root Region"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}

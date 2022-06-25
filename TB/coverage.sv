module coverage_c(

input   tms_pad_i,      // JTAG test mode select pad
input   tck_pad_i,      // JTAG test clock pad
input   trst_pad_i,     // JTAG test reset pad
input   tdi_pad_i,      // JTAG test data input pad
input  tdo_pad_o,      // JTAG test data output pad
input  tdo_padoe_o,    // Output enable for JTAG test data output pad 

// TAP states
input  shift_dr_o,
input  pause_dr_o,
input  update_dr_o,
input  capture_dr_o,

// Select signals for boundary scan or mbist
input  extest_select_o,
input  sample_preload_select_o,
input  mbist_select_o,
input  debug_select_o,

// TDO signal that is connected to TDI of sub-modules.
input  tdo_o,

// TDI signals from sub-modules
input   debug_tdi_i,    // from debug module
input   bs_chain_tdi_i, // from Boundary Scan Chain
input   mbist_tdi_i    // from Mbist Chain
);


static shortreal pinsCoverage, TMSresetCoverage,  tdi_tdoCoverage, fsmCoverage, int_regCoverage, parallel_caseCoverage;

int total_coverage;


// JTAG pins
covergroup pins @(posedge tck_pad_i);
	option.at_least =1;
	tms_pad_cov: coverpoint tms_pad_i;
	trst_pad_cov: coverpoint trst_pad_i;
	tdi_pad_i_cov: coverpoint tdi_pad_i;
	tdo_pad_o_cov: coverpoint tdo_pad_o ;

endgroup


 // 5 consecutive TMS=1 causes reset
covergroup reset1 @(posedge tck_pad_i);
	reset_cov: coverpoint jtag_tap.tms_reset;
endgroup


// different TDI and TDO coverage
covergroup TDI_TDO_cov @(posedge tck_pad_i);
	BSC_cov: coverpoint bs_chain_tdi_i;
 	debug_cov: coverpoint debug_tdi_i;
	Mbist_cov: coverpoint mbist_tdi_i;
	tdo_cov: coverpoint tdo_o;
	
	
endgroup

//Bypass, instruction register, ID code coverage
covergroup int_reg_cov @(posedge tck_pad_i);
	Ins_reg_cov: coverpoint jtag_tap.jtag_ir;
	bypass_cov: coverpoint jtag_tap.bypass_reg;
	IDCode_cov: coverpoint jtag_tap.idcode_tdo;
	bypas_sel_cov: coverpoint jtag_tap.bypass_select;
	id_sel_cov: coverpoint jtag_tap.idcode_select;
		
endgroup

//covergroup for TAP FSM states and instruction_select and their crosses
covergroup fsm_cov @(posedge tck_pad_i or posedge trst_pad_i);
	test_logic_reset_cov: coverpoint jtag_tap.test_logic_reset;
	run_test_idle_cov: coverpoint jtag_tap.run_test_idle;
	select_dr_scan_cov: coverpoint jtag_tap.select_dr_scan;
	capture_dr_cov: coverpoint jtag_tap.capture_dr;
	shift_dr_cov: coverpoint jtag_tap.shift_dr;
	exit1_dr_cov: coverpoint jtag_tap.exit1_dr;
	pause_dr_cov: coverpoint jtag_tap.pause_dr;
	exit2_dr_cov: coverpoint jtag_tap.exit2_dr;
	update_dr_cov: coverpoint jtag_tap.update_dr;
	select_ir_scan_cov: coverpoint jtag_tap.select_ir_scan;
	capture_ir_cov: coverpoint jtag_tap.capture_ir;
	shift_ir_cov: coverpoint jtag_tap.shift_ir;
	exit1_ir_cov: coverpoint jtag_tap.exit1_ir;
	pause_ir_cov: coverpoint jtag_tap.pause_ir;
	exit2_ir_cov: coverpoint jtag_tap.exit2_ir;
	update_ir_cov: coverpoint jtag_tap.update_ir;
	
	tms_pad_cov2: coverpoint tms_pad_i;
	extest_sel_cov2: coverpoint extest_select_o;
	sample_preload_sel_cov2: coverpoint sample_preload_select_o;
	mbist_sel_cov2: coverpoint mbist_select_o;
	debug_sel_cov2: coverpoint debug_select_o;
	bypass_sel_cov2: coverpoint jtag_tap.bypass_select;
	id_sel_cov2: coverpoint jtag_tap.idcode_select;

	//TMS cross with every tap states
	tmsXtest_logic_reset_cov: cross tms_pad_cov2, test_logic_reset_cov;
	tmsXrun_test_idle_cov: cross tms_pad_cov2, run_test_idle_cov;
	tmsXselect_dr_scan_cov: cross tms_pad_cov2, select_dr_scan_cov;
	tmsXcapture_dr_cov: cross tms_pad_cov2, capture_dr_cov;
	tmsXshift_dr_cov: cross tms_pad_cov2, shift_dr_cov;
	tmsXexit1_dr_cov: cross tms_pad_cov2, exit1_dr_cov;
	tmsXpause_dr_cov: cross tms_pad_cov2, pause_dr_cov;
	tmsXexit2_dr_cov: cross tms_pad_cov2, exit2_dr_cov;
	tmsXupdate_dr_cov: cross tms_pad_cov2, update_dr_cov;
	tmsXselect_ir_scan_cov: cross tms_pad_cov2, select_ir_scan_cov;
	tmsXcapture_ir_cov: cross tms_pad_cov2, capture_ir_cov;
	tmsXshift_ir_cov: cross tms_pad_cov2, shift_ir_cov;
	tmsXexit1_ir_cov: cross tms_pad_cov2, exit1_ir_cov;
	tmsXpause_ir_cov: cross tms_pad_cov2, pause_ir_cov;
	tmsXexit2_ir_cov: cross tms_pad_cov2, exit2_ir_cov;
	tmsXupdate_ir_cov: cross tms_pad_cov2, update_ir_cov;

	//EXTEST instruction select cross with all tap states
	extest_selXtest_logic_reset_cov: cross extest_sel_cov2, test_logic_reset_cov;
	extest_selXrun_test_idle_cov: cross extest_sel_cov2, run_test_idle_cov;
	extest_selXselect_dr_scan_cov: cross extest_sel_cov2, select_dr_scan_cov;
	extest_selXcapture_dr_cov: cross extest_sel_cov2, capture_dr_cov;
	extest_selXshift_dr_cov: cross extest_sel_cov2, shift_dr_cov;
	extest_selXexit1_dr_cov: cross extest_sel_cov2, exit1_dr_cov;
	extest_selXpause_dr_cov: cross extest_sel_cov2, pause_dr_cov;
	extest_selXexit2_dr_cov: cross extest_sel_cov2, exit2_dr_cov;
	extest_selXupdate_dr_cov: cross extest_sel_cov2, update_dr_cov;
	extest_selXselect_ir_scan_cov: cross extest_sel_cov2, select_ir_scan_cov;
	extest_selXcapture_ir_cov: cross extest_sel_cov2, capture_ir_cov;
	extest_selXshift_ir_cov: cross extest_sel_cov2, shift_ir_cov;
	extest_selXexit1_ir_cov: cross extest_sel_cov2, exit1_ir_cov;
	extest_selXpause_ir_cov: cross extest_sel_cov2, pause_ir_cov;
	extest_selXexit2_ir_cov: cross extest_sel_cov2, exit2_ir_cov;
	extest_selXupdate_ir_cov: cross extest_sel_cov2, update_ir_cov;

	//SAMPLE-PRELOAD instruction select cross with all tap states
	sample_preload_selXtest_logic_reset_cov: cross sample_preload_sel_cov2, test_logic_reset_cov;
	sample_preload_selXrun_test_idle_cov: cross sample_preload_sel_cov2, run_test_idle_cov;
	sample_preload_selXselect_dr_scan_cov: cross sample_preload_sel_cov2, select_dr_scan_cov;
	sample_preload_selXcapture_dr_cov: cross sample_preload_sel_cov2, capture_dr_cov;
	sample_preload_selXshift_dr_cov: cross sample_preload_sel_cov2, shift_dr_cov;
	sample_preload_selXexit1_dr_cov: cross sample_preload_sel_cov2, exit1_dr_cov;
	sample_preload_selXpause_dr_cov: cross sample_preload_sel_cov2, pause_dr_cov;
	sample_preload_selXexit2_dr_cov: cross sample_preload_sel_cov2, exit2_dr_cov;
	sample_preload_selXupdate_dr_cov: cross sample_preload_sel_cov2, update_dr_cov;
	sample_preload_selXselect_ir_scan_cov: cross sample_preload_sel_cov2, select_ir_scan_cov;
	sample_preload_selXcapture_ir_cov: cross sample_preload_sel_cov2, capture_ir_cov;
	sample_preload_selXshift_ir_cov: cross sample_preload_sel_cov2, shift_ir_cov;
	sample_preload_selXexit1_ir_cov: cross sample_preload_sel_cov2, exit1_ir_cov;
	sample_preload_selXpause_ir_cov: cross sample_preload_sel_cov2, pause_ir_cov;
	sample_preload_selXexit2_ir_cov: cross sample_preload_sel_cov2, exit2_ir_cov;
	sample_preload_selXupdate_ir_cov: cross sample_preload_sel_cov2, update_ir_cov;

	//MBIST instruction select cross with all tap states
	mbist_selXtest_logic_reset_cov: cross mbist_sel_cov2, test_logic_reset_cov;
	mbist_selXrun_test_idle_cov: cross mbist_sel_cov2, run_test_idle_cov;
	mbist_selXselect_dr_scan_cov: cross mbist_sel_cov2, select_dr_scan_cov;
	mbist_selXcapture_dr_cov: cross mbist_sel_cov2, capture_dr_cov;
	mbist_selXshift_dr_cov: cross mbist_sel_cov2, shift_dr_cov;
	mbist_selXexit1_dr_cov: cross mbist_sel_cov2, exit1_dr_cov;
	mbist_selXpause_dr_cov: cross mbist_sel_cov2, pause_dr_cov;
	mbist_selXexit2_dr_cov: cross mbist_sel_cov2, exit2_dr_cov;
	mbist_selXupdate_dr_cov: cross mbist_sel_cov2, update_dr_cov;
	mbist_selXselect_ir_scan_cov: cross mbist_sel_cov2, select_ir_scan_cov;
	mbist_selXcapture_ir_cov: cross mbist_sel_cov2, capture_ir_cov;
	mbist_selXshift_ir_cov: cross mbist_sel_cov2, shift_ir_cov;
	mbist_selXexit1_ir_cov: cross mbist_sel_cov2, exit1_ir_cov;
	mbist_selXpause_ir_cov: cross mbist_sel_cov2, pause_ir_cov;
	mbist_selXexit2_ir_cov: cross mbist_sel_cov2, exit2_ir_cov;
	mbist_selXupdate_ir_cov: cross mbist_sel_cov2, update_ir_cov;

	//DEBUG instruction select cross with all tap states
	debug_selXtest_logic_reset_cov: cross debug_sel_cov2, test_logic_reset_cov;
	debug_selXrun_test_idle_cov: cross debug_sel_cov2, run_test_idle_cov;
	debug_selXselect_dr_scan_cov: cross debug_sel_cov2, select_dr_scan_cov;
	debug_selXcapture_dr_cov: cross debug_sel_cov2, capture_dr_cov;
	debug_selXshift_dr_cov: cross debug_sel_cov2, shift_dr_cov;
	debug_selXexit1_dr_cov: cross debug_sel_cov2, exit1_dr_cov;
	debug_selXpause_dr_cov: cross debug_sel_cov2, pause_dr_cov;
	debug_selXexit2_dr_cov: cross debug_sel_cov2, exit2_dr_cov;
	debug_selXupdate_dr_cov: cross debug_sel_cov2, update_dr_cov;
	debug_selXselect_ir_scan_cov: cross debug_sel_cov2, select_ir_scan_cov;
	debug_selXcapture_ir_cov: cross debug_sel_cov2, capture_ir_cov;
	debug_selXshift_ir_cov: cross debug_sel_cov2, shift_ir_cov;
	debug_selXexit1_ir_cov: cross debug_sel_cov2, exit1_ir_cov;
	debug_selXpause_ir_cov: cross debug_sel_cov2, pause_ir_cov;
	debug_selXexit2_ir_cov: cross debug_sel_cov2, exit2_ir_cov;
	debug_selXupdate_ir_cov: cross debug_sel_cov2, update_ir_cov;

	//BYPASS instruction select cross with all tap states
	bypass_selXtest_logic_reset_cov: cross bypass_sel_cov2, test_logic_reset_cov;
	bypass_selXrun_test_idle_cov: cross bypass_sel_cov2, run_test_idle_cov;
	bypass_selXselect_dr_scan_cov: cross bypass_sel_cov2, select_dr_scan_cov;
	bypass_selXcapture_dr_cov: cross bypass_sel_cov2, capture_dr_cov;
	bypass_selXshift_dr_cov: cross bypass_sel_cov2, shift_dr_cov;
	bypass_selXexit1_dr_cov: cross bypass_sel_cov2, exit1_dr_cov;
	bypass_selXpause_dr_cov: cross bypass_sel_cov2, pause_dr_cov;
	bypass_selXexit2_dr_cov: cross bypass_sel_cov2, exit2_dr_cov;
	bypass_selXupdate_dr_cov: cross bypass_sel_cov2, update_dr_cov;
	bypass_selXselect_ir_scan_cov: cross bypass_sel_cov2, select_ir_scan_cov;
	bypass_selXcapture_ir_cov: cross bypass_sel_cov2, capture_ir_cov;
	bypass_selXshift_ir_cov: cross bypass_sel_cov2, shift_ir_cov;
	bypass_selXexit1_ir_cov: cross bypass_sel_cov2, exit1_ir_cov;
	bypass_selXpause_ir_cov: cross bypass_sel_cov2, pause_ir_cov;
	bypass_selXexit2_ir_cov: cross bypass_sel_cov2, exit2_ir_cov;
	bypass_selXupdate_ir_cov: cross bypass_sel_cov2, update_ir_cov;

	//IDCODE instruction select cross with all tap states
	id_selXtest_logic_reset_cov: cross id_sel_cov2, test_logic_reset_cov;
	id_selXrun_test_idle_cov: cross id_sel_cov2, run_test_idle_cov;
	id_selXselect_dr_scan_cov: cross id_sel_cov2, select_dr_scan_cov;
	id_selXcapture_dr_cov: cross id_sel_cov2, capture_dr_cov;
	id_selXshift_dr_cov: cross id_sel_cov2, shift_dr_cov;
	id_selXexit1_dr_cov: cross id_sel_cov2, exit1_dr_cov;
	id_selXpause_dr_cov: cross id_sel_cov2, pause_dr_cov;
	id_selXexit2_dr_cov: cross id_sel_cov2, exit2_dr_cov;
	id_selXupdate_dr_cov: cross id_sel_cov2, update_dr_cov;
	id_selXselect_ir_scan_cov: cross id_sel_cov2, select_ir_scan_cov;
	id_selXcapture_ir_cov: cross id_sel_cov2, capture_ir_cov;
	id_selXshift_ir_cov: cross id_sel_cov2, shift_ir_cov;
	id_selXexit1_ir_cov: cross id_sel_cov2, exit1_ir_cov;
	id_selXpause_ir_cov: cross id_sel_cov2, pause_ir_cov;
	id_selXexit2_ir_cov: cross id_sel_cov2, exit2_ir_cov;
	id_selXupdate_ir_cov: cross id_sel_cov2, update_ir_cov;

endgroup

covergroup parallel_case @(posedge tck_pad_i);
	parll_case_cov: coverpoint jtag_tap.latched_jtag_ir;
	
endgroup


initial begin: coverage_block

	static pins pns = new;
	static reset1 rst = new;
	static TDI_TDO_cov tdi_tdo = new;
	static fsm_cov fsm_coverage = new;
	static int_reg_cov internal_reg_cov = new;
	static parallel_case parallel_case_cov = new;

forever begin: sampling_block
  pinsCoverage = pns.get_coverage();
  TMSresetCoverage = rst.get_coverage();
  tdi_tdoCoverage = tdi_tdo.get_coverage();
  fsmCoverage = fsm_coverage.get_coverage();
  int_regCoverage = internal_reg_cov.get_coverage();
  parallel_caseCoverage = parallel_case_cov.get_coverage();
  
  @(posedge tck_pad_i);
   
  total_coverage = (pinsCoverage + TMSresetCoverage +  tdi_tdoCoverage + fsmCoverage + int_regCoverage + parallel_caseCoverage)/6;
   
   //$monitor("%f %f %f %f %f %f", pinsCoverage, TMSresetCoverage, tdi_tdoCoverage, fsmCoverage, int_regCoverage, parallel_caseCoverage);
	
end: sampling_block

end: coverage_block


final
begin
	$display("total_coverage=%d",total_coverage);
end

endmodule
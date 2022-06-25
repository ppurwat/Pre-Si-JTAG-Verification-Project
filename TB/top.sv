`include "tap_defines.v"
`include "transaction.sv"
`include "generator.sv"
`include "jtag_intf.sv"
`include "coverage.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
//`include "/home/ppurwat/common/Documents/PreSi/Project/DUV/jtag.sv"
`include "../DUV/jtag.sv"
`include "reference_model.sv"
`include "environment.sv"
`include "test.sv"
module top;
  
  //clock and reset signal declaration
  bit tck_pad_i;
  bit trst_pad_i;
  
  always
  begin
    #10 tck_pad_i = ~tck_pad_i;
  end

  initial begin
    trst_pad_i = 1;
    repeat (2) @(negedge tck_pad_i);
    trst_pad_i = 0;
  end

  //creatinng instance of interface, inorder to connect DUT and testcase
  jtag_intf jvi1(.*);
  jtag_intf jvi2(.*);
  
  //Testcase instance, interface handle is passed to test as an argument
  test m (jvi1, jvi2);
  
  //Coverage binding
  bind jtag_tap coverage_c cvg
    (
                // JTAG pads
                jvi1.tms_pad_i, 
                jvi1.tck_pad_i, 
                jvi1.trst_pad_i, 
                jvi1.tdi_pad_i, 
                jvi1.tdo_pad_o, 
                jvi1.tdo_padoe_o,

                // TAP states
                jvi1.shift_dr_o,
                jvi1.pause_dr_o, 
                jvi1.update_dr_o,
                jvi1.capture_dr_o,
                
                // Select signals for boundary scan or mbist
                jvi1.extest_select_o, 
                jvi1.sample_preload_select_o,
                jvi1.mbist_select_o,
                jvi1.debug_select_o,
                
                // TDO signal that is connected to TDI of sub-modules.
                jvi1.tdo_o, 
                
                // TDI signals from sub-modules
                jvi1.debug_tdi_i,    // from debug module
                jvi1.bs_chain_tdi_i, // from Boundary Scan Chain
                jvi1.mbist_tdi_i     // from Mbist Chain
              );
    

  //Ref model instance
   ref_top REF (
        .tms_pad_i(jvi2.tms_pad_i),      // JTAG test mode select pad
        .tck_pad_i(jvi2.tck_pad_i),      // JTAG test clock pad
        .trst_pad_i(jvi2.trst_pad_i),     // JTAG test reset pad
        .tdi_pad_i(jvi2.tdi_pad_i),     // JTAG test data input pad
        .tdo_pad_o(jvi2.tdo_pad_o),      // JTAG test data logic pad
        .tdo_padoe_o(jvi2.tdo_padoe_o),    // logic enable for JTAG test data logic pad 

        // TAP states
        .shift_dr_o(jvi2.shift_dr_o),
        .pause_dr_o(jvi2.pause_dr_o),
        .update_dr_o(jvi2.update_dr_o),
        .capture_dr_o(jvi2.capture_dr_o),

        // Select signals for boundary scan or mbist
        .extest_select_o(jvi2.extest_select_o),
        .sample_preload_select_o(jvi2.sample_preload_select_o),
        .mbist_select_o(jvi2.mbist_select_o),
        .debug_select_o(jvi2.debug_select_o),

        // TDO signal that is connected to TDI of sub-modules.
        .tdo_o(jvi2.tdo_o),

        // TDI signals from sub-modules
        .debug_tdi_i(jvi2.debug_tdi_i),    // from debug module
        .bs_chain_tdi_i(jvi2.bs_chain_tdi_i), // from Boundary Scan Chain
        .mbist_tdi_i(jvi2.mbist_tdi_i)    // from Mbist Chain

  );

  
  //DUT instance
  jtag_tap DUV (
          .tms_pad_i(jvi1.tms_pad_i),      // JTAG test mode select pad
          .tck_pad_i(jvi1.tck_pad_i),      // JTAG test clock pad
          .trst_pad_i(jvi1.trst_pad_i),     // JTAG test reset pad
          .tdi_pad_i(jvi1.tdi_pad_i),     // JTAG test data input pad
          .tdo_pad_o(jvi1.tdo_pad_o),      // JTAG test data logic pad
          .tdo_padoe_o(jvi1.tdo_padoe_o),    // logic enable for JTAG test data logic pad 

          // TAP states
           .shift_dr_o(jvi1.shift_dr_o),
           .pause_dr_o(jvi1.pause_dr_o),
           .update_dr_o(jvi1.update_dr_o),
           .capture_dr_o(jvi1.capture_dr_o),

          // Select signals for boundary scan or mbist
           .extest_select_o(jvi1.extest_select_o),
           .sample_preload_select_o(jvi1.sample_preload_select_o),
           .mbist_select_o(jvi1.mbist_select_o),
           .debug_select_o(jvi1.debug_select_o),

          // TDO signal that is connected to TDI of sub-modules.
           .tdo_o(jvi1.tdo_o),

          // TDI signals from sub-modules
           .debug_tdi_i(jvi1.debug_tdi_i),    // from debug module
           .bs_chain_tdi_i(jvi1.bs_chain_tdi_i), // from Boundary Scan Chain
           .mbist_tdi_i(jvi1.mbist_tdi_i)    // from Mbist Chain
	);


  
   initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule

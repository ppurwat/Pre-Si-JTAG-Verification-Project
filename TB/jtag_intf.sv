`include "tap_defines.v"
interface jtag_intf(input bit tck_pad_i , input bit trst_pad_i);

logic  tms_pad_i;      // JTAG test mode select pad
logic  tdi_pad_i;      // JTAG test data input pad
logic  tdo_pad_o;      // JTAG test data logic pad
logic  tdo_padoe_o;    // logic enable for JTAG test data logic pad 

// TAP states
logic shift_dr_o;
logic  pause_dr_o;
logic  update_dr_o;
logic  capture_dr_o;

// Select signals for boundary scan or mbist
logic  extest_select_o;
logic  sample_preload_select_o;
logic  mbist_select_o;
logic  debug_select_o;

// TDO signal that is connected to TDI of sub-modules.
logic  tdo_o;

// TDI signals from sub-modules
logic   debug_tdi_i;    // from debug module
logic   bs_chain_tdi_i; // from Boundary Scan Chain
logic   mbist_tdi_i;    // from Mbist Chain

parameter DATA_LENGTH=29;
logic [`IR_LENGTH-1:0] Instr_reg;
logic [DATA_LENGTH-1:0] Data_reg;

endinterface

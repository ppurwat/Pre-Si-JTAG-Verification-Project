class jtag_trans;

logic tms_pad_i;      // JTAG test mode select pad
logic tdi_pad_i;      // JTAG test data input pad
logic  tdo_pad_o;      // JTAG test data output pad
logic  tdo_padoe_o;    // Output enable for JTAG test data output pad 

// TAP states
logic shift_dr_o;
logic pause_dr_o;
logic update_dr_o;
logic capture_dr_o;

// Select signals for boundary scan or mbist
logic extest_select_o;
logic sample_preload_select_o;
logic mbist_select_o;
logic debug_select_o;

// TDO signal that is connected to TDI of sub-modules.
logic  tdo_o;

// TDI signals from sub-modules
logic  debug_tdi_i;    // from debug module
logic  bs_chain_tdi_i; // from Boundary Scan Chain
logic  mbist_tdi_i;    // from Mbist Chain


//rand bit tdo_chain[];

rand bit tms_chain_ir[];
rand bit tms_chain_dr[];
rand bit tdi_dr_chain[];
rand bit tdi_ir_chain[];

static int nTx;

function void post_randomize();
nTx++;
endfunction

endclass

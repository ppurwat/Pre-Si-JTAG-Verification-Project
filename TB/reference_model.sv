`include "tap_defines.v"
// Top module
module ref_top(
                // JTAG pads
                tms_pad_i, 
                tck_pad_i, 
                trst_pad_i, 
                tdi_pad_i, 
                tdo_pad_o, 
                tdo_padoe_o,

                // TAP states
                shift_dr_o,
                update_dr_o,
                capture_dr_o,
                
                // Select signals for boundary scan or mbist
                extest_select_o, 
                 pause_dr_o, 
               sample_preload_select_o,
                mbist_select_o,
                debug_select_o,
                
                // TDO signal that is connected to TDI of sub-modules.
                tdo_o, 
                
                // TDI signals from sub-modules
                debug_tdi_i,    // from debug module
                bs_chain_tdi_i, // from Boundary Scan Chain
                mbist_tdi_i     // from Mbist Chain
              );
// JTAG pins
input   tms_pad_i;      // JTAG test mode select pad
input   tck_pad_i;      // JTAG test clock pad
input   trst_pad_i;     // JTAG test reset pad
input   tdi_pad_i;      // JTAG test data input pad
output  tdo_pad_o;      // JTAG test data output pad
output  tdo_padoe_o;    // Output enable for JTAG test data output pad 

// TAP states
output  shift_dr_o;
output  pause_dr_o;
output  update_dr_o;
output  capture_dr_o;

// Select signals for boundary scan or mbist
output  extest_select_o;
output  sample_preload_select_o;
output  mbist_select_o;
output  debug_select_o;

// TDO signal that is connected to TDI of sub-modules.
output  tdo_o;

// TDI signals from sub-modules
input   debug_tdi_i;    // from debug module
input   bs_chain_tdi_i; // from Boundary Scan Chain
input   mbist_tdi_i;    // from Mbist Chain

// Registers
reg     test_logic_reset;
reg     run_test_idle;
reg     select_dr_scan;
reg     capture_dr;
reg     shift_dr;
reg     exit1_dr;
reg     pause_dr;
reg     exit2_dr;
reg     update_dr;
reg     select_ir_scan;
reg     capture_ir;
reg     shift_ir, shift_ir_neg;
reg     exit1_ir;
reg     pause_ir;
reg     exit2_ir;
reg     update_ir;
reg     extest_select;
reg     sample_preload_select;
reg     idcode_select;
reg     mbist_select;
reg     debug_select;
reg     bypass_select;
reg     tdo_pad_o;
reg     tdo_padoe_o;
reg     tms_q1, tms_q2, tms_q3, tms_q4;
wire    tms_reset;

typedef enum logic [3:0] {Test_logic_rst_s, Run_tst_idle_s, Select_dr_scan_s, Capture_dr_s, Shift_dr_s, Exit1_dr_s, Pause_dr_s, Exit2_dr_s, Update_dr_s, Select_ir_scan_s, Capture_ir_s, Shift_ir_s, Exit1_ir_s, Pause_ir_s, Exit2_ir_s, Update_ir_s} St;
St state_tap, next_state;



assign tdo_o = tdi_pad_i;
assign shift_dr_o = shift_dr;
assign pause_dr_o = pause_dr;
assign update_dr_o = update_dr;
assign capture_dr_o = capture_dr;

assign extest_select_o = extest_select;
assign sample_preload_select_o = sample_preload_select;
assign mbist_select_o = mbist_select;
assign debug_select_o = debug_select;


always @ (posedge tck_pad_i)
begin
  tms_q1 <= #1 tms_pad_i;
  tms_q2 <= #1 tms_q1;
  tms_q3 <= #1 tms_q2;
  tms_q4 <= #1 tms_q3;
end


assign tms_reset = tms_q1 & tms_q2 & tms_q3 & tms_q4 & tms_pad_i;    // 5 consecutive TMS=1 causes reset

always @ (posedge tck_pad_i, posedge trst_pad_i)
//TAP state register 
	begin 
		if (trst_pad_i || tms_reset) begin
			state_tap <= Test_logic_rst_s;

			end
		else 
		state_tap <= next_state;
				
	end

//Tap next state logic
always_comb begin 
		 case(state_tap)
			Test_logic_rst_s: if (tms_pad_i == 1) next_state= Test_logic_rst_s; else next_state= Run_tst_idle_s;
			
			Run_tst_idle_s: if (tms_pad_i == 1) next_state= Select_dr_scan_s; else next_state = Run_tst_idle_s;
			
			Select_dr_scan_s: next_state= tms_pad_i? Select_ir_scan_s : Capture_dr_s;
			
			Capture_dr_s: next_state= tms_pad_i ? Exit1_dr_s : Shift_dr_s;
			
			Shift_dr_s: next_state= tms_pad_i ? Exit1_dr_s : Shift_dr_s;
			
			Exit1_dr_s: next_state= tms_pad_i ? Update_dr_s : Pause_dr_s;
			
			Pause_dr_s: next_state= tms_pad_i ? Exit2_dr_s : Pause_dr_s;
			
			Exit2_dr_s: next_state= tms_pad_i ? Update_dr_s : Shift_dr_s;
			
			Update_dr_s: next_state= tms_pad_i ? Select_dr_scan_s : Run_tst_idle_s;
			
			Select_ir_scan_s: next_state= tms_pad_i ? Test_logic_rst_s : Capture_ir_s;
			
			Capture_ir_s: next_state= tms_pad_i ? Exit1_ir_s : Shift_ir_s;
			
			Shift_ir_s: next_state= tms_pad_i ? Exit1_ir_s : Shift_ir_s;
			
			Exit1_ir_s: next_state= tms_pad_i ? Update_ir_s : Pause_ir_s;
			
			Pause_ir_s: next_state= tms_pad_i ? Exit2_ir_s : Pause_ir_s ;
			
			Exit2_ir_s: next_state= tms_pad_i ? Update_ir_s : Shift_ir_s;
			
			Update_ir_s: next_state= tms_pad_i ? Select_dr_scan_s : Run_tst_idle_s;
			
			default: next_state = Test_logic_rst_s;
		endcase
	end

//Current state logic
always @(state_tap) begin 

				run_test_idle<=#1 1'b0;
				select_dr_scan<=#1 1'b0;
				capture_dr<=#1 1'b0;
				shift_dr<=#1 1'b0;
				exit1_dr<=#1 1'b0;
				pause_dr<=#1 1'b0;
				exit2_dr<=#1 1'b0;
				update_dr<=#1 1'b0;
				select_ir_scan<=#1 1'b0;
				capture_ir<=#1 1'b0;
				shift_ir<=#1 1'b0;
				exit1_ir<=#1 1'b0;
				pause_ir<=#1 1'b0;
				exit2_ir<=#1 1'b0;
				update_ir<=#1 1'b0;


		 case(state_tap)
			Test_logic_rst_s: test_logic_reset<=#1 1'b1;
			
			Run_tst_idle_s: run_test_idle=#1 1'b1;
								
			Select_dr_scan_s: select_dr_scan=#1 1'b1;
								
			Capture_dr_s: capture_dr=#1 1'b1;
							
			Shift_dr_s: shift_dr=#1 1'b1;
							
			Exit1_dr_s: exit1_dr=#1 1'b1;
							
			Pause_dr_s: pause_dr=#1 1'b1;
							
			Exit2_dr_s: exit2_dr=#1 1'b1;
							
			Update_dr_s: update_dr=#1 1'b1;
							
			Select_ir_scan_s: select_ir_scan=#1 1'b1;
								
			Capture_ir_s: capture_ir=#1 1'b1;
							
			Shift_ir_s: shift_ir=#1 1'b1;
							
			Exit1_ir_s: exit1_ir=#1 1'b1;
							
			Pause_ir_s: pause_ir=#1 1'b1;
							
			Exit2_ir_s: exit2_ir=#1 1'b1;
							
			Update_ir_s: update_ir=#1 1'b1;
		endcase
	end
	
//End: TAP State Machine                                                        


//jtag_ir:  JTAG Instruction Register                                           
reg [`IR_LENGTH-1:0]  jtag_ir;          // Instruction register
reg [`IR_LENGTH-1:0]  latched_jtag_ir, latched_jtag_ir_neg;
reg                   instruction_tdo;

always @ (posedge tck_pad_i or posedge trst_pad_i)
begin
  if(trst_pad_i)
    jtag_ir[`IR_LENGTH-1:0] <= #1 `IR_LENGTH'b0;
  else if(capture_ir)
    jtag_ir <= #1 4'b0101;          // This value is fixed for easier fault detection
  else if(shift_ir)
    jtag_ir[`IR_LENGTH-1:0] <= #1 {tdi_pad_i, jtag_ir[`IR_LENGTH-1:1]};
end

always @ (negedge tck_pad_i)
begin
  instruction_tdo <= #1 jtag_ir[0];
end
// End: jtag_ir                                                                  //idcode logic                                                                  
reg [31:0] idcode_reg;
reg        idcode_tdo;

always @ (posedge tck_pad_i)
begin
  if(idcode_select & shift_dr)
    idcode_reg <= #1 {tdi_pad_i, idcode_reg[31:1]};
  else
    idcode_reg <= #1 `IDCODE_VALUE;
end

always @ (negedge tck_pad_i)
begin
    idcode_tdo <= #1 idcode_reg;
end
// End: idcode logic                                                             //  Bypass logic                                                                  
reg  bypassed_tdo;
reg  bypass_reg;

always @ (posedge tck_pad_i or posedge trst_pad_i)
begin
  if (trst_pad_i)
    bypass_reg<=#1 1'b0;
  else if(shift_dr)
    bypass_reg<=#1 tdi_pad_i;
end

always @ (negedge tck_pad_i)
begin
  bypassed_tdo <=#1 bypass_reg;
end
// End: Bypass logic                                                             // Activating Instructions                                                       
// Updating jtag_ir (Instruction Register)
always @ (posedge tck_pad_i or posedge trst_pad_i)
begin
  if(trst_pad_i)
    latched_jtag_ir <=#1 `IDCODE;   // IDCODE selected after reset
  else if (tms_reset)
    latched_jtag_ir <=#1 `IDCODE;   // IDCODE selected after reset
  else if(update_ir)
    latched_jtag_ir <=#1 jtag_ir;
end

// End: Activating Instructions                                                  //

// Updating jtag_ir (Instruction Register)
always @ (latched_jtag_ir)
begin
  extest_select           = 1'b0;
  sample_preload_select   = 1'b0;
  idcode_select           = 1'b0;
  mbist_select            = 1'b0;
  debug_select            = 1'b0;
  bypass_select           = 1'b0;

  case(latched_jtag_ir)    /* synthesis parallel_case */ 
    `EXTEST:            extest_select           = 1'b1;    // External test
    `SAMPLE_PRELOAD:    sample_preload_select   = 1'b1;    // Sample preload
    `IDCODE:            idcode_select           = 1'b1;    // ID Code
    `MBIST:             mbist_select            = 1'b1;    // Mbist test
    `DEBUG:             debug_select            = 1'b1;    // Debug
    `BYPASS:            bypass_select           = 1'b1;    // BYPASS
    default:            bypass_select           = 1'b1;    // BYPASS
  endcase
end



// Multiplexing TDO data                                                         //
always @ (shift_ir_neg or exit1_ir or instruction_tdo or latched_jtag_ir_neg or idcode_tdo or
          debug_tdi_i or bs_chain_tdi_i or mbist_tdi_i or 
          bypassed_tdo)
begin
  if(shift_ir_neg)
    tdo_pad_o = instruction_tdo;
  else
    begin
      case(latched_jtag_ir_neg)    // synthesis parallel_case
        `IDCODE:            tdo_pad_o = idcode_tdo;       // Reading ID code
        `DEBUG:             tdo_pad_o = debug_tdi_i;      // Debug
        `SAMPLE_PRELOAD:    tdo_pad_o = bs_chain_tdi_i;   // Sampling/Preloading
        `EXTEST:            tdo_pad_o = bs_chain_tdi_i;   // External test
        `MBIST:             tdo_pad_o = mbist_tdi_i;      // Mbist test
        default:            tdo_pad_o = bypassed_tdo;     // BYPASS instruction
      endcase
    end
end


// Tristate control for tdo_pad_o pin
always @ (negedge tck_pad_i)
begin
  tdo_padoe_o <= #1 shift_ir | shift_dr | (pause_dr & debug_select);
end
// End: Multiplexing TDO data                                                    //


always @ (negedge tck_pad_i)
begin
  shift_ir_neg <= #1 shift_ir;
  latched_jtag_ir_neg <= #1 latched_jtag_ir;
end


endmodule
		

							
			
		





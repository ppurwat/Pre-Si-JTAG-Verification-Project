class scoreboard;

 //transaction class handles
 jtag_trans trans1,trans2; 

int no_trans_sc;

 //mailbox from monitor to scoreboard	
 mailbox #(jtag_trans) m2s_trans1;
 mailbox #(jtag_trans) m2s_trans2;
  
   static int Errors,Hit;
  //constructor
  function new(mailbox #(jtag_trans) m2s_trans1, mailbox #(jtag_trans) m2s_trans2);
    this.m2s_trans1 = m2s_trans1;
	this.m2s_trans2 = m2s_trans2;
   endfunction
  
  //checks values from both checker  and scoreboard
  task scb_run(int tms_chain_ir_w, int tms_chain_dr_w);
	begin
			forever
			begin
				for(int i=0; i<tms_chain_ir_w; i++) //IR Recieving
		  	         begin
		  	           fork
		  	                  m2s_trans1.get(trans1);
		  	                  m2s_trans2.get(trans2);	
		  	           join
						 //$display("1: TMS=%b, TDI=%b, TDO=%b, TDO_e=%b",trans1.tms_pad_i,trans1.tdi_pad_i,trans1.tdo_o,trans1.tdo_padoe_o);
						 //$display("2: TMS=%b, TDI=%b, TDO=%b, TDO_e=%b",trans2.tms_pad_i,trans2.tdi_pad_i,trans2.tdo_o,trans2.tdo_padoe_o);
						 if(trans1.tdo_pad_o !== trans2.tdo_pad_o &&
								trans1.tdo_padoe_o !== trans2.tdo_padoe_o &&
								trans1.tdo_pad_o !== trans2.tdo_pad_o &&
								trans1.shift_dr_o !== trans2.shift_dr_o &&
								trans1.pause_dr_o !== trans2.pause_dr_o &&
								trans1.update_dr_o !== trans2.update_dr_o &&
								trans1.capture_dr_o !== trans2.capture_dr_o &&
								trans1.extest_select_o !== trans2.extest_select_o &&
								trans1.sample_preload_select_o !== trans2.sample_preload_select_o &&
								trans1.mbist_select_o !== trans2.mbist_select_o &&
								trans1.debug_select_o !== trans2.debug_select_o &&
								trans1.tdo_o !== trans2.tdo_o) 
								begin
									$display("Miss"); Errors++;
								end
								else begin
									//$display("Hit");
									Hit++;
								end
		  	         end
				for(int i=0; i<tms_chain_dr_w; i++) //DR Recieving
		  	         begin
		  	           fork
		  	                  m2s_trans1.get(trans1);
		  	                  m2s_trans2.get(trans2);
		  	           join
						 //$display("1: TMS=%b, TDI=%b, TDO=%b, TDO_e=%b",trans1.tms_pad_i,trans1.tdi_pad_i,trans1.tdo_o,trans1.tdo_padoe_o);
						 //$display("2: TMS=%b, TDI=%b, TDO=%b, TDO_e=%b",trans2.tms_pad_i,trans2.tdi_pad_i,trans2.tdo_o,trans2.tdo_padoe_o);
						 if(trans1.tdo_pad_o !== trans2.tdo_pad_o &&
								trans1.tdo_padoe_o !== trans2.tdo_padoe_o &&
								trans1.tdo_pad_o !== trans2.tdo_pad_o &&
								trans1.shift_dr_o !== trans2.shift_dr_o &&
								trans1.pause_dr_o !== trans2.pause_dr_o &&
								trans1.update_dr_o !== trans2.update_dr_o &&
								trans1.capture_dr_o !== trans2.capture_dr_o &&
								trans1.extest_select_o !== trans2.extest_select_o &&
								trans1.sample_preload_select_o !== trans2.sample_preload_select_o &&
								trans1.mbist_select_o !== trans2.mbist_select_o &&
								trans1.debug_select_o !== trans2.debug_select_o &&
								trans1.tdo_o !== trans2.tdo_o) 
								begin
									$display("Miss"); Errors++;
								end
								else begin
									//$display("Hit"); 
									Hit++;
								end
		  	         end
				no_trans_sc++;
			end
	end
	
  endtask

 endclass

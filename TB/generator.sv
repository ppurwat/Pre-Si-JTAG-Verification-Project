class generator;

//transaction clas handle
jtag_trans trans;

//mailbox to send data to driver	
mailbox #(jtag_trans) g2d;

//specify number of items to generate
int NUM;

event endtrans;

//constructor
function new(mailbox #(jtag_trans) g2d, event endtrans);

    this.g2d = g2d;
    this.endtrans = endtrans;
    trans = new();

  endfunction

task gen_run();
     repeat(NUM) begin
          //$display("Generator0: trans.tms_chain_ir=%p",trans.tms_chain_ir);
     assert(trans.randomize())
      begin
          //$display("Generator: trans.tms_chain_ir=%p",trans.tms_chain_ir);
          //$display("Generator: trans.tdi_ir_chain=%p",trans.tdi_ir_chain);
          //$display("Generator: trans.tms_chain_dr=%p",trans.tms_chain_dr);
          //$display("Generator: trans.tdi_dr_chain=%p",trans.tdi_dr_chain);
	     g2d.put(trans);
     end
     else $display("Randomization Failed");
     end
     -> endtrans;
endtask

endclass

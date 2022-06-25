`include "tap_defines.v"
class driver;

  //transaction clas handle
  jtag_trans trans; 

  //creating virtual interface handle
  virtual jtag_intf jvi1, jvi2;
  
  int no_trans_d;

  //creating mailbox handle for driver
  mailbox #(jtag_trans) g2d;
  
  //constructor
  function new(virtual jtag_intf jvi1, virtual jtag_intf jvi2, mailbox #(jtag_trans) g2d);
    this.jvi1 = jvi1;
    this.jvi2 = jvi2; 
    this.g2d = g2d;
  endfunction
  
    
   task reset(virtual jtag_intf jvi1, virtual jtag_intf jvi2);
    fork
      begin
          wait(jvi1.trst_pad_i);
          $display("jvi1: Driver's Reset Started");      
          wait(!jvi1.trst_pad_i);
          $display("jvi1: Driver's Reset Ended");
      end
      begin
          wait(jvi2.trst_pad_i);
          $display("jvi2: Driver's Reset Started");      
          wait(!jvi2.trst_pad_i);
          $display("jvi2: Driver's Reset Ended");
      end
    join
  endtask


  task drv_transmit();

    bit [3:0] ir;
	 g2d.get(trans);
   //saving IR instruction temporarily
   for(int i=5,j=3; i<9; i++,j--)
      begin
        ir[j] = trans.tdi_ir_chain[i];
      end

  fork
    begin//Thread1- for interface Jvi1 //DUV
          foreach(trans.tms_chain_ir[i])//IR_sending
            begin
                @(posedge jvi1.tck_pad_i)
                jvi1.tms_pad_i <= trans.tms_chain_ir[i];
                jvi1.tdi_pad_i <= trans.tdi_ir_chain[i];

              end
           foreach(trans.tms_chain_dr[i])// DR sending
              begin
                @(posedge jvi1.tck_pad_i)
                jvi1.tms_pad_i <= trans.tms_chain_dr[i];
                case(ir)
                  `EXTEST:          jvi1.bs_chain_tdi_i <= trans.tdi_ir_chain[i];
                  `SAMPLE_PRELOAD:  jvi1.bs_chain_tdi_i <= trans.tdi_ir_chain[i];
                  `DEBUG:           jvi1.debug_tdi_i <= trans.tdi_ir_chain[i];
                  `MBIST:           jvi1.mbist_tdi_i <= trans.tdi_ir_chain[i];
                  default:          jvi1.tdi_pad_i <= trans.tdi_ir_chain[i];
                endcase
              end
    end
    begin //Thread1- for interface Jvi2 //Reference Model
          foreach(trans.tms_chain_ir[i])//IR_sending
              begin
                @(posedge jvi2.tck_pad_i)
                jvi2.tms_pad_i <= trans.tms_chain_ir[i];
                jvi2.tdi_pad_i <= trans.tdi_ir_chain[i];
              end
           foreach(trans.tms_chain_dr[i])// DR sending
              begin
                @(posedge jvi2.tck_pad_i)
                jvi2.tms_pad_i <= trans.tms_chain_dr[i];
                case(ir)
                  `EXTEST:          jvi2.bs_chain_tdi_i <= trans.tdi_ir_chain[i];
                  `SAMPLE_PRELOAD:  jvi2.bs_chain_tdi_i <= trans.tdi_ir_chain[i];
                  `DEBUG:           jvi2.debug_tdi_i <= trans.tdi_ir_chain[i];
                  `MBIST:           jvi2.mbist_tdi_i <= trans.tdi_ir_chain[i];
                  default:          jvi2.tdi_pad_i <= trans.tdi_ir_chain[i];
                endcase
              end
    end
  join
    no_trans_d++;
 
    //$display("Driver: trans.tms_chain_ir=%p",trans.tms_chain_ir);
    //$display("Driver: trans.tdi_ir_chain=%p",trans.tdi_ir_chain);
    //$display("Driver: trans.tms_chain_dr=%p",trans.tms_chain_dr);
    //$display("Driver: trans.tdi_dr_chain=%p",trans.tdi_dr_chain);
 endtask 

task drv_run;
 forever begin
      fork
        //Thread1- Waiting for reset
        begin
          wait(jvi1.trst_pad_i || jvi2.trst_pad_i);
        end
        //Thread2- Calling drive transmit task
        begin
          forever
            drv_transmit();
        end
      join_any
      disable fork;
    end
endtask


endclass

class monitor;
  //transaction clas handle
  jtag_trans trans1,trans2; 
  
  //creating virtual interface handle
  virtual jtag_intf jvi1, jvi2;
  
  //creating mailbox handle
  mailbox #(jtag_trans) m2s_jvi1;
  mailbox #(jtag_trans) m2s_jvi2;
  
  int no_trans_m;

  //constructor
  function new(virtual jtag_intf jvi1, virtual jtag_intf jvi2,
              mailbox #(jtag_trans) m2s_jvi1, mailbox #(jtag_trans) m2s_jvi2);
  
    this.jvi1 = jvi1;
    this.jvi2 = jvi2;
    this.m2s_jvi1 = m2s_jvi1;
    this.m2s_jvi2 = m2s_jvi2;
    trans1 = new();
    trans2 = new();
  endfunction
  
 task mon_run(int tms_chain_ir_w, int tms_chain_dr_w);
  begin
    forever
      begin
           for(int i=0; i<tms_chain_ir_w; i++) //IR Recieving
           begin
             fork
               begin
                    
                    RecieveFromInf(jvi1, trans1);
                    m2s_jvi1.put(trans1);
                    //$display("M1: TMS=%b, TDI=%b, TDO=%b, TDO_e=%b",trans1.tms_pad_i,trans1.tdi_pad_i,trans1.tdo_o,trans1.tdo_padoe_o);
               end
               begin
                    
                    RecieveFromInf(jvi2, trans2);
                    m2s_jvi2.put(trans2);
                    //$display("M2: TMS=%b, TDI=%b, TDO=%b, TDO_e=%b",trans2.tms_pad_i,trans2.tdi_pad_i,trans2.tdo_o,trans2.tdo_padoe_o);
               end
             join
           end

           for(int i=0; i<tms_chain_dr_w; i++) //DR Recieving
           begin
             fork
               begin
                    
                    RecieveFromInf(jvi1, trans1);
                    m2s_jvi1.put(trans1);
               end
               begin
                    
                    RecieveFromInf(jvi2, trans2);
                    m2s_jvi2.put(trans2);
               end
             join
           end
          no_trans_m++;
          //$display("Monitor: No of Tx = %d",no_trans_m);
      end
  end
 endtask
  
  task RecieveFromInf(virtual jtag_intf jvi, jtag_trans trans);
  begin
     @(posedge jvi.tck_pad_i)
        trans.tms_pad_i <= jvi.tms_pad_i; 
        trans.tdi_pad_i <= jvi.tdi_pad_i;
        trans.tdo_pad_o <= jvi.tdo_pad_o;
        trans.tdo_padoe_o <= jvi.tdo_padoe_o;

        trans.shift_dr_o   <= jvi.shift_dr_o;
        trans.pause_dr_o   <= jvi.pause_dr_o;
        trans.update_dr_o  <= jvi.update_dr_o;
        trans.capture_dr_o <= jvi.capture_dr_o;

        trans.extest_select_o <= jvi.extest_select_o;
        trans.sample_preload_select_o <= jvi.sample_preload_select_o;
        trans.mbist_select_o <= jvi.mbist_select_o;
        trans.debug_select_o <= jvi.debug_select_o;

        trans.tdo_o <= jvi.tdo_o;

        trans.debug_tdi_i <= jvi.debug_tdi_i;
        trans.bs_chain_tdi_i <= jvi.bs_chain_tdi_i;
        trans.mbist_tdi_i <= jvi.mbist_tdi_i;
        trans.debug_select_o <= jvi.debug_select_o;
        trans.debug_select_o <= jvi.debug_select_o;
  end
  endtask
endclass

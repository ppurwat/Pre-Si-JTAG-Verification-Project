class environment;

  //mailbox handle's
  mailbox #(jtag_trans) g2d;
  mailbox #(jtag_trans) m2s_trans1;
  mailbox #(jtag_trans) m2s_trans2;
  
  //virtual interface
  virtual jtag_intf jvi1, jvi2;
  
  event endtrans;
  
  //generator and driver instance
  generator  gen;
  driver     driv;
  monitor    mon;
  scoreboard scb; 
  
  //constructor
  function new(virtual jtag_intf jvi1, virtual jtag_intf jvi2);
    this.jvi1 = jvi1;
    this.jvi2 = jvi2;
  endfunction
  
  function void build();
    g2d  = new();
    m2s_trans1  = new();
    m2s_trans2  = new();
    gen  = new(g2d, endtrans);
    driv = new(jvi1, jvi2, g2d);
    mon  = new(jvi1, jvi2, m2s_trans1, m2s_trans2);
    scb  = new(m2s_trans1, m2s_trans2);
  endfunction 

  task env_run(int tms_chain_ir_w, int tms_chain_dr_w);
    driv.reset(jvi1, jvi2);
    fork 
    gen.gen_run();
    driv.drv_run();
    mon.mon_run(tms_chain_ir_w, tms_chain_dr_w);
    scb.scb_run(tms_chain_ir_w, tms_chain_dr_w);
    join_any
    endOfTest();
  endtask
  
  task endOfTest;
    wait(endtrans.triggered);
    wait(gen.NUM == driv.no_trans_d);
    wait(gen.NUM == scb.no_trans_sc);
    $display("No of transaction completed=%d",scb.no_trans_sc);
    $display("No of Hits at the end=%d",scb.Hit);
    $finish();
  endtask
  
endclass

program test(jtag_intf jvi1, jtag_intf jvi2);
  
//Extended class for IDCODE instruction testcase 
class idcode_test extends jtag_trans;

parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
// tdi_dr_chain=32;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
//{0,1,1,0,0,   0,0,0,0,   1,1,0};
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b00000_0010_000;
//{0,0,0,0,0,   0,0,1,0,   0,0,0};
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;
//{0,0,   0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,   1,1,0};

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass


//Extended class for BYPASS instruction testcase
class bypass_test extends jtag_trans;
parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b000000_1111_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass

//Extended class for DEBUG instruction testcase
class debug_test extends jtag_trans;
parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b000000_1000_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass


//Extended class for MBIST instruction testcase
class mbist_test extends jtag_trans;
parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b000000_1001_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass

//Extended class for EXTEST instruction testcase
class extest_test extends jtag_trans;
parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b000000_0000_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass

//Extended class for SAMPLE_PRELOAD instruction testcase
class samp_prel_test extends jtag_trans;
parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b000000_0001_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass

//Extended class for Random testcases
class rand_test extends jtag_trans;

parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
//bit tms_chain_dr2[];

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
  //tms_chain_dr2 = new[tms_chain_dr_w];
endfunction
endclass

//Extended class for reaching all remaining FSM states, TMS_reset and short IR instruction (of 2 bits instead 4 bits)
class fsm_ir_test extends jtag_trans;
parameter tms_chain_ir_w=17, tms_chain_dr_w=41;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 17'b11111_011_0000_10_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 17'b00000_000000_0001_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 41'h08_0000_0016;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass

//Extended class for invalid IR instruction
class inv_ir_test extends jtag_trans;
parameter tms_chain_ir_w=12, tms_chain_dr_w=38;
bit [tms_chain_ir_w-1:0] tms_chain_ir_temp = 12'b01100_0000_110;
bit [tms_chain_ir_w-1:0] tdi_ir_chain_temp = 12'b000000_1101_000;
bit [tms_chain_dr_w-1:0] tms_chain_dr_temp = 38'h20_0000_0006;

constraint tms_scanchain_ir_c {foreach(tms_chain_ir[i]) tms_chain_ir[i] == tms_chain_ir_temp[tms_chain_ir_w-i-1]; }
constraint tdi_scanchain_ir_c {foreach(tdi_ir_chain[i]) tdi_ir_chain[i] == tdi_ir_chain_temp[tms_chain_ir_w-i-1]; }
constraint tms_scanchain_dr_c {foreach(tms_chain_dr[i]) tms_chain_dr[i] == tms_chain_dr_temp[tms_chain_dr_w-i-1]; }

function new();
  tms_chain_ir = new[tms_chain_ir_w];
  tdi_ir_chain = new[tms_chain_ir_w];
  tms_chain_dr = new[tms_chain_dr_w];
  tdi_dr_chain = new[tms_chain_dr_w];
endfunction
endclass
  int noTC;
  string TEST;
  //declaring environment instance
  environment env;
  idcode_test id_tst;
  bypass_test byp_tst;
  debug_test dbg_tst;
  mbist_test mb_tst;
  extest_test extst_tst;
  samp_prel_test sb_tst;
  rand_test rnd_tst;
  fsm_ir_test fi_tst;
  inv_ir_test ii_tst;

  initial begin
    if($value$plusargs ("noTC=%d", noTC))	
         $display("Number of transactions=%d",noTC);
    else 
      begin
          noTC=20000;
          $display("Number of transactions is not provided, so by default 30000 testcases will get run in 5min");
      end

     if($value$plusargs ("TEST=%s",TEST))	
         $display("TEST=%s",TEST);
    else 
      begin
          TEST="RANDOM";
          $display("Test is not provided, so by default RANDOM tescase will get run");     
      end
    env = new(jvi1, jvi2);
    id_tst = new();
    byp_tst = new();
    dbg_tst = new();
    mb_tst = new();
    extst_tst = new();
    sb_tst = new();
    rnd_tst = new();
    fi_tst = new();
    ii_tst = new();

    env.build();
    env.gen.NUM = noTC;
    case(TEST)
        "IDCODE": begin
            env.gen.trans = id_tst;
	          env.env_run(id_tst.tms_chain_ir_w, id_tst.tms_chain_dr_w);
        end
        "BYPASS": begin
            env.gen.trans = byp_tst;
	          env.env_run(byp_tst.tms_chain_ir_w, byp_tst.tms_chain_dr_w);
        end
        "DEBUG": begin
            env.gen.trans = dbg_tst;
	          env.env_run(dbg_tst.tms_chain_ir_w, dbg_tst.tms_chain_dr_w);
        end
        "MBIST": begin
            env.gen.trans = mb_tst;
	          env.env_run(mb_tst.tms_chain_ir_w, mb_tst.tms_chain_dr_w);
        end
        "EXTEST": begin
            env.gen.trans = extst_tst;
	          env.env_run(extst_tst.tms_chain_ir_w, extst_tst.tms_chain_dr_w);
        end
        "SAMPLE_PRELOAD": begin
            env.gen.trans = sb_tst;
	          env.env_run(sb_tst.tms_chain_ir_w, sb_tst.tms_chain_dr_w);
        end
        "FSM_IR": begin
            env.gen.trans = fi_tst;
	          env.env_run(fi_tst.tms_chain_ir_w, fi_tst.tms_chain_dr_w);
        end
        "INV_IR": begin
            env.gen.trans = ii_tst;
	          env.env_run(ii_tst.tms_chain_ir_w, ii_tst.tms_chain_dr_w);
        end
        default: begin //"RANDOM" by default
            env.gen.trans = rnd_tst;
            env.env_run(rnd_tst.tms_chain_ir_w, rnd_tst.tms_chain_dr_w);
        end
    endcase
  end
  endprogram

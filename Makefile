# Makefile
#
DUV_PATH=/home/ppurwat/common/Documents/PreSi/Project/DUV
TB_PATH=/home/ppurwat/common/Documents/PreSi/Project/TB
#DUV= $(DUV_PATH)/tap_defines.v $(DUV_PATH)/jtag.sv
#TB= $(DUV_PATH)/top.sv
DUV= DUV/tap_defines.v DUV/BScell.sv DUV/flags_calc.sv DUV/simpleALU.sv DUV/jtag.sv
TB= TB/top.sv
work= work #library name
VSIMOPT= +access +r   
VSIMBATCH= -c -do "coverage save -onexit -directive -cvg -codeAll cov; run -all; exit"
Number=1000
lib: 
	vlib $(work)

compile:
	vmap work $(work)
	vlog -coveropt 3 +cover +acc $(DUV) $(TB)
	
runsim1:
	vsim -coverage -vopt +TEST=IDCODE +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim1.log  work.top
	
runsim2:
	vsim -coverage -vopt +TEST=BYPASS +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim2.log  work.top
	
runsim3:
	vsim -coverage -vopt +TEST=DEBUG +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim3.log  work.top
	
runsim4:
	vsim -coverage -vopt +TEST=MBIST +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim4.log  work.top
	
runsim5:
	vsim -coverage -vopt +TEST=EXTEST +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim5.log  work.top
	
runsim6:
	vsim -coverage -vopt +TEST=SAMPLE_PRELOAD +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim6.log  work.top
	
runsim7:
	vsim -coverage -vopt +TEST=INV_IR +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim7.log  work.top

runsim8:
	vsim -coverage -vopt +TEST=FSM_IR +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim8.log  work.top

runsim9:
	vsim -coverage -vopt +TEST=RANDOM +noTC=$(Number) $(VSIMBATCH) $(VSIMOPT) -l result_sim9.log  work.top

runcov: 
	vcover report -html -output total_cov_html -annotate -details -assert -directive -cvg -code bcefsx cov
		
clean:
	clear

run_all: clean lib compile runsim1 runsim2 runsim3 runsim4 runsim5 runsim6 runsim7 runsim8 runsim9 runcov




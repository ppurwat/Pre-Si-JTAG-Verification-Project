module Boundary_Scanff (BS_in, shiftDR, last_cell, clockDR, updateDR, mode, next_cell, BS_op);
input logic BS_in;
input logic shiftDR;
input logic last_cell;
input logic clockDR;
input logic updateDR;
input logic mode;
output next_cell;
output BS_op;

logic capture_scan_i;
logic out_ff_i;
logic mode_mux_i;

assign capture_scan_i = shiftDR ? last_cell : BS_in;
assign BS_op = mode ? mode_mux_i : BS_in;
assign next_cell = out_ff_i;

always_ff@(posedge clockDR)
begin
out_ff_i <= capture_scan_i;
end

always_ff@(posedge updateDR)
begin
mode_mux_i <= out_ff_i;
end


endmodule

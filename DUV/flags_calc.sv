module flags_calc (inp, Z, P);
parameter OPERAND_WIDTH=8;
input logic [OPERAND_WIDTH:0] inp; //9
output Z, P; //2
//Total Pins for flag_calc = 11 Boundary Pins

assign Z = (inp == '0) ? 1'b1 : 1'b0;
assign P = ^inp;

endmodule

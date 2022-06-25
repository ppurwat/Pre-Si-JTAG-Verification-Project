`define ADDop 4'b0000;
`define SUBop 4'b0001;
`define ANDop 4'b0010;
`define ORop 4'b0011;
`define XORop 4'b0100;

module simpleALU(Ain, Bin, OPin, Resultout);

parameter OP_WIDTH=4;
parameter REGISTER_ADD_WIDTH=4;
parameter OPERAND_WIDTH=8;

input logic [OPERAND_WIDTH-1:0] Ain, Bin; //8+8=16
input logic [OP_WIDTH-1:0] OPin;	  //4
output logic [OPERAND_WIDTH:0] Resultout; //9
//Total Pins for simpleALU = 29 Boundary Pins

always_comb
begin
case(OPin)
	4'b0000 : Resultout = (Ain + Bin);
	4'b0001 : Resultout = (Ain - Bin);
	4'b0010 : Resultout = {1'b0, (Ain & Bin)};
	4'b0011:  Resultout = {1'b0, (Ain | Bin)};
	4'b0100 : Resultout = {1'b0, (Ain ^ Bin)};
	default : Resultout = Resultout;
endcase
end

endmodule

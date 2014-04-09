module LeftShift(in,out);
    input [31:0]in;
    output [31:0]out;
    reg [31:0]out;
    always@(in)
    begin
        out[31:0]={in[29:0],2'b00};
    end
endmodule 

module srcase(s,r,clk,q,qb);
    input s,r;
    input clk;
    output q,qb;
reg q,qb;
initial
  begin
       q=1'b0;
   q=1'b0;
 end
always@(posedge clk)
begin
    case({s,r})
    {1'b0,1'b0}: begin q=q; qb=qb; end
  {1'b1,1'b0}: begin q=1'b1; qb=0; end
  {1'b0,1'b1}: begin q=0; qb=1'b1; end
  default : begin q="x";qb="x"; end
  endcase
 end
endmodule
module dff(b,clk,q,q_0);
	input b, clk;
	output q,q_0;
	reg q;
	reg q_0;
	
	always@(posedge clk)
	begin
		q <= b;
		q_0 <= !b;
	end
endmodule

module register(d,clk,q,q_0);
	input wire[31:0] d;
	input clk;
	output wire[31:0] q;
	output wire[31:0] q_0;
	genvar i;
	generate
		for(i=0; i<=31; ++i) begin
			dff d (d[i],clk,q[i],q_0[i]);
			end
	endgenerate
endmodule

	
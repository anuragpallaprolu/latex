module gatedsr(r,e,s,q,q0);
	input r,e,s;
	output q, q0;
	wire w,x;
	assign w = r&e;
	assign x = s&e;
	nor(q,w,q0);
	nor(q0,q,x);
endmodule

module dec(a,d);
	input[1:0] a;
	output[3:0] d;
	wire[1:0] a;
	wire[3:0] d;
	assign d[0] = ~(a[0])&~(a[1]);
	assign d[1] = a[0]&~(a[1]);
	assign d[2] = ~a[0]&a[1];
	assign d[3] = a[0]&a[1];
endmodule

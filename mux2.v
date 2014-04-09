module mux7( select, d, q );

input[1:0] select;
input[3:0] d;
output     q;

wire       q, q1, q2, q3, q4, NOTselect0, NOTselect1;
wire[1:0]  select;
wire[3:0]  d;

not n1( NOTselect0, select[0] );
not n2( NOTselect1, select[1] );

and a1( q1, NOTselect0, NOTselect1, d[0]  );
and a2( q2,  select[0], NOTselect1, d[1]  );
and a3( q3, NOTselect0,  select[1], d[2]  );
and a4( q4,  select[0],  select[1], d[3]  );

or o1( q, q1, q2, q3, q4 );

endmodule
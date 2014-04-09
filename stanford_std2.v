// arithmetic circuits for EE108 Lecture 5
// (c) Bill Dally - 2003 - All Rights Reserved
// 1/18/2003
//---------------------------------------------------------------------

// test script
module test4 ;

  reg [15:0] in0, in1 ;
  wire [15:0] out ;
  reg cin ;
  wire cout ;

  Add16 a(in0,in1,cin,cout,out) ;

  initial begin
    in0 = 16'd12345 ; in1 = 16'd43210 ; cin=0 ;
    #100 $display("%05h + %05h  = %05h cin = %b cout = %b", 
    in0, in1, out, cin, cout) ;
    $display("p=%b g=%b c=%b pp=%b gg=%b cc=%b",
    a.p, a.g, a.c, a.pp, a.gg, {a.c[12],a.c[8],a.c[4]}) ;

    in0 = 16'd12345 ; in1 = 16'd43210 ; cin=1 ;
    #100 $display("%05h + %05h  = %05h cin = %b cout = %b", 
    in0, in1, out, cin, cout) ;
    $display("p=%b g=%b c=%b pp=%b gg=%b cc=%b",
    a.p, a.g, a.c, a.pp, a.gg, {a.c[12],a.c[8],a.c[4]}) ;

    in0 = 16'h7fff ; in1 = 16'h8000 ; cin = 0 ;
    #100 $display("%05h + %05h  = %05h cin = %b cout = %b", 
    in0, in1, out, cin, cout) ;
    $display("p=%b g=%b c=%b pp=%b gg=%b cc=%b",
    a.p, a.g, a.c, a.pp, a.gg, {a.c[12],a.c[8],a.c[4]}) ;

    in0 = 16'h7fff ; in1 = 16'h8000 ; cin = 1 ;
    #100 $display("%05h + %05h  = %05h cin = %b cout = %b", 
    in0, in1, out, cin, cout) ;
    $display("p=%b g=%b c=%b pp=%b gg=%b cc=%b",
    a.p, a.g, a.c, a.pp, a.gg, {a.c[12],a.c[8],a.c[4]}) ;
  end
endmodule
//---------------------------------------------------------------------

// test script
module test3 ;

  reg [3:0] in0, in1 ;
  wire [7:0] out ;

  Mul4 mul(in0,in1,out) ;

  initial begin
    in0 = 0 ;
    repeat (16) begin
      in1 = 0 ;
      repeat (in0+1) begin
        #100 $display("%03d * %03d = %03d",in0,in1,out) ;
        in1 = in1 + 1 ;
      end
      in0 = in0 + 1 ;
    end    
  end
endmodule
//---------------------------------------------------------------------

// test script
module test2 ;

  reg [7:0] in0, in1 ;
  wire [7:0] out ;
  reg sub ;
  wire ovf ;

  AddSub #(8) a(in0,in1,sub,out,ovf) ;

  initial begin
    in0 = 8'd87  ; in1 = 8'd40 ; sub = 0 ;
    #100 $display("%03h + %03h  = %03h ovf = %b", in0, in1, out, ovf) ;
    in0 = 8'd87  ; in1 = 8'd40 ; sub = 1 ;
    #100 $display("%03h - %03h  = %03h ovf = %b", in0, in1, out, ovf) ;
    in0 = 8'd88  ; in1 = 8'd40 ; sub = 0 ;
    #100 $display("%03h + %03h  = %03h ovf = %b", in0, in1, out, ovf) ;
    in0 = 8'he9  ; in1 = 8'h17 ; sub = 1 ; /* -23 - 23 */
    #100 $display("%03h - %03h  = %03h ovf = %b", in0, in1, out, ovf) ;
    in0 = 8'he9  ; in1 = 8'h97 ; sub = 0 ; /* -23 - 105 = -128  no ovf */
    #100 $display("%03h + %03h  = %03h ovf = %b", in0, in1, out, ovf) ;
    in0 = 8'he9  ; in1 = 8'd106 ; sub = 1 ; /* overflow */
    #100 $display("%03h - %03h  = %03h ovf = %b", in0, in1, out, ovf) ;
  end
endmodule
//---------------------------------------------------------------------

// test script
module test1 ;

  reg [7:0] in0, in1 ;
  wire [7:0] out ;
  reg cin ;
  wire cout ;

  Adder1 #(8) a(in0,in1,cin,cout,out) ;

  initial begin
    in0 = 8'd87  ; in1 = 8'd139 ; cin = 0 ;
    #100 $display("%03d + %03d + %b = %03d c = %b", in0, in1, cin, out, cout) ;
    in0 = 8'd87  ; in1 = 8'd139 ; cin = 1 ;
    #100 $display("%03d + %03d + %b = %03d c = %b", in0, in1, cin, out, cout) ;
    in0 = 8'd127  ; in1 = 8'd128 ; cin = 0 ;
    #100 $display("%03d + %03d + %b = %03d c = %b", in0, in1, cin, out, cout) ;
    in0 = 8'd127  ; in1 = 8'd128 ; cin = 1 ;
    #100 $display("%03d + %03d + %b = %03d c = %b", in0, in1, cin, out, cout) ;
    in0 = 8'd123  ; in1 = 8'd99 ; cin = 0 ;
    #100 $display("%03d + %03d + %b = %03d c = %b", in0, in1, cin, out, cout) ;
    in0 = 8'd123  ; in1 = 8'd99 ; cin = 1 ;
    #100 $display("%03d + %03d + %b = %03d c = %b", in0, in1, cin, out, cout) ;
  end
endmodule
//---------------------------------------------------------------------

module test ;

  reg [2:0] in ;
  wire [1:0] o1, o2, o3 ;

  HalfAdder ha(in[0],in[1],o1[1],o1[0]) ;
  FullAdder1 fa1(in[0],in[1],in[2],o2[1],o2[0]) ;
  FullAdder2 fa2(in[0],in[1],in[2],o3[1],o3[0]) ;

  initial begin
    in = 0 ; 
    repeat (8) begin
      #100 $display("%b %b %b %b",in,o1,o2,o3) ;
      in = in+ 1 ; 
    end 
  end
endmodule
//---------------------------------------------------------------------

// half adder
module HalfAdder(a,b,c,s) ;
  input a,b ;
  output c,s ;  // carry and sum
  wire s = a ^ b ;
  wire c = a & b ;
endmodule

//---------------------------------------------------------------------

// full adder - from half adders
module FullAdder1(a,b,cin,cout,s) ;
  input a,b,cin ;
  output cout,s ;  // carry and sum
  wire g,p ;    // generate and propagate
  wire cp ;
  HalfAdder ha1(a,b,g,p) ;
  HalfAdder ha2(cin,p,cp,s) ;
  or o1(cout,g,cp) ;
endmodule
//---------------------------------------------------------------------

// full adder - logical
module FullAdder2(a,b,cin,cout,s) ;
  input a,b,cin ;
  output cout,s ;  // carry and sum
  wire s = a ^ b ^ cin ;
  wire cout = (a & b)|(a & cin)|(b & cin) ; // majority
endmodule
//---------------------------------------------------------------------

// multi-bit adder - structural
module Adder(a,b,cin,cout,s) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n:0] c ;
  genvar i ;
  assign c[0] = cin ;
  assign cout = c[n] ;
  
  generate
    for(i=0;i<n;i=i+1) begin:bit
      FullAdder2 a(a[i],b[i],c[i],c[i+1],s[i]) ;
    end
  endgenerate
endmodule
//---------------------------------------------------------------------

// multi-bit adder - behavioral
module Adder1(a,b,cin,cout,s) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n-1:0] s;
  wire cout ;

  assign {cout, s} = a + b + cin ;
endmodule 
//---------------------------------------------------------------------

// add a+b or subtract a-b, check for overflow
module AddSub(a,b,sub,s,ovf) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input sub ;           // subtract if sub=1, otherwise add
  output [n-1:0] s ;
  output ovf ;          // 1 if overflow
  wire c1, c2 ;         // carry out of last two bits
  wire ovf = c1 ^ c2 ;  // overflow if signs don't match

  // add non sign bits
  Adder1 #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]) ;
  // add sign bits
  Adder1 #(1)   as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]) ;
endmodule
//---------------------------------------------------------------------

// 4-bit multiplier
module Mul4(a,b,p) ;
  input [3:0] a,b ;
  output [7:0] p ;
  
  // form partial products 
  wire [3:0] pp0 = a & {4{b[0]}} ; // x1
  wire [3:0] pp1 = a & {4{b[1]}} ; // x2
  wire [3:0] pp2 = a & {4{b[2]}} ; // x4
  wire [3:0] pp3 = a & {4{b[3]}} ; // x8

  // sum up partial products
  wire cout1, cout2, cout3 ;
  wire [3:0] s1, s2, s3 ;
  Adder1 #(4) a1(pp1, {1'b0,pp0[3:1]}, 1'b0, cout1, s1) ;
  Adder1 #(4) a2(pp2, {cout1,s1[3:1]}, 1'b0, cout2, s2) ;
  Adder1 #(4) a3(pp3, {cout2,s2[3:1]}, 1'b0, cout3, s3) ;

  // collect the result
  wire [7:0] p = {cout3, s3, s2[0], s1[0], pp0[0]} ;
endmodule
//---------------------------------------------------------------------

// 4:1 pg combine for fast adder carry chain
module PG4(pin,gin,pout,gout) ;
  input [3:0] pin, gin ;
  output pout, gout ;

  wire pout = &pin ;
  wire gout = gin[3] | (pin[3] & (gin[2] | (pin[2] 
                                  & (gin[1] | (pin[1] & gin[0]))))) ;
endmodule 
//---------------------------------------------------------------------

// 1:4 carry expand for fast adder carry chain
module Carry4(p,g,cin,cout) ;
  input [2:0] p, g ;
  input cin ;
  output [2:0] cout ;
  wire [2:0] cout = g | (p & {cout[1:0],cin}) ;
endmodule
//---------------------------------------------------------------------

module Add16(a,b,cin,cout,s) ;
  input [15:0] a, b ;
  input cin ;
  output cout ;
  output [15:0] s ;

  // single bit p and g
  wire [15:0] p = a^b ;
  wire [15:0] g = a&b ;

  // four bit p and g
  wire [3:0] pp, gg ;
  wire ppp, ggg ;
  PG4 pg0(p[3:0],g[3:0],pp[0],gg[0]) ;
  PG4 pg1(p[7:4],g[7:4],pp[1],gg[1]) ;
  PG4 pg2(p[11:8],g[11:8],pp[2],gg[2]) ;
  PG4 pg3(p[15:12],g[15:12],pp[3],gg[3]) ;
  PG4 pgtop(pp[3:0],gg[3:0],ppp,ggg) ;

  // four bit carry expand
  wire [15:0] c ;
  assign c[0] = cin ;
  Carry4 ctop(pp[2:0],gg[2:0],cin,{c[12],c[8],c[4]}) ;
  Carry4 c0(p[2:0],g[2:0],cin,c[3:1]) ;
  Carry4 c1(p[6:4],g[6:4],c[4],c[7:5]) ;
  Carry4 c2(p[10:8],g[10:8],c[8],c[11:9]) ;
  Carry4 c3(p[14:12],g[14:12],c[12],c[15:13]) ;

  // form sum
  wire [15:0] s = p^c ;
 
  // carry out
  assign cout = ggg | (ppp & cin) ;
endmodule
//---------------------------------------------------------------------
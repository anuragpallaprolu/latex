// building blocks for EE108 Lecture 4
// (c) Bill Dally - 2003 - All Rights Reserved
// 1/15/2003
//---------------------------------------------------------------------

// test script
module test ;
  parameter n=4 ;
  parameter m=16 ;

  reg [5:0] a ;
  wire [m-1:0] b ;
  wire [3:0] c ;
  wire [63:0] d ;
  wire [n-1:0] e,g ;
  reg [m-1:0] f ;
  wire [1:0] h ;
  wire [5:0] j ;
  wire [2:0] k ;

  Decoder #(n,m) dec(a[n-1:0], b) ;
  Dec24 d24(a[1:0],c) ;
  Dec664 d64(a,d) ;
  //Encoder #(m,n) enc(f, e) ;
  Enc164 e2(f,g) ;
  //Mux4 #(2) mx(2'd0, 2'd1, 2'd2, 2'd3, f, h) ;
  Arb #(6) arb(a,j) ;
  Encoder #(6,3) enc2(j,k) ;

  initial begin
    a = 0 ; f = 1 ;
    repeat (64) begin
      // #100 $display("%b %b %b %h",a,b,c,d) ;
      #100 $display("%b %b %d",a,j,k) ;
      a = a+ 1 ; f = f<<1;
    end 
  end
endmodule

//---------------------------------------------------------------------

// arbitrary width decoder
module Decoder(a, b) ;
  parameter n = 3 ;
  parameter m = 8 ;
  input  [n-1:0] a ;
  output [m-1:0] b ;

  reg [m-1:0] b ;
  integer i ;
  
  always @(a) begin
    for(i=0;i<m;i=i+1) begin
      b[i] = (a == i) ? 1 : 0 ;
    end
  end
 endmodule

//---------------------------------------------------------------------

// fixed width decoder
module Dec24(a, b) ;
  input  [1:0] a ;
  output [3:0] b ;
  wire   [3:0] b ;
  
  assign b[0] = !a[0] & !a[1] ;
  assign b[1] =  a[0] & !a[1] ;
  assign b[2] = !a[0] &  a[1] ;
  assign b[3] =  a[0] &  a[1] ;
endmodule 

//---------------------------------------------------------------------

// factored decoder
module Dec664(a, b) ;
  input  [5:0]  a ;
  output [63:0] b ;

  reg    [63:0] b ;
  wire   [3:0]  c, d, e ;

  integer i ;

  Dec24 d0(a[1:0],c) ;
  Dec24 d1(a[3:2],d) ;
  Dec24 d2(a[5:4],e) ;

  always @(c or d or e) begin
    for(i=0;i<64;i=i+1) begin
      b[i] = c[i & 3] & d[(i>>2) & 3] & e[(i>>4) & 3] ;
    end
  end 
endmodule

//---------------------------------------------------------------------

// encoder
module Encoder(a, b) ;
  parameter n = 8 ;
  parameter m = 3 ;
  input  [n-1:0] a ;
  output [m-1:0] b ;
  reg    [m-1:0] b ;
  integer i ;

  always @(a) begin
    for(i=0;i<n;i=i+1) begin
      if(a[i] == 1) b = i ;
    end
    if(a == 0) b = 0 ;
  end
endmodule

//---------------------------------------------------------------------

// encoder - fixed width
module Enc42(a, b) ;
  input  [3:0] a ;
  output [1:0] b ;
  wire   [1:0] b ;

  assign b[1] = a[3] | a[2] ;
  assign b[0] = a[3] | a[1] ;
endmodule
//---------------------------------------------------------------------

// encoder - fixed width - with summary output
module Enc42a(a, b, c) ;
  input  [3:0] a ;
  output [1:0] b ;
  output c ;
  wire   [1:0] b ;
  wire   c ;

  assign b[1] = a[3] | a[2] ;
  assign b[0] = a[3] | a[1] ;
  assign c = |a ;
endmodule

//---------------------------------------------------------------------

// factored encoder
module Enc164(a, b) ;
  input [15:0] a ;
  output[3:0]  b ;
  wire [3:0] b ;
  wire [7:0] c ; // intermediate result of first stage
  wire [3:0] d ; // if any set in group of four

  // four LSB encoders each include 4-bits of the input
  Enc42a e0(a[3:0],  c[1:0],d[0]) ;
  Enc42a e1(a[7:4],  c[3:2],d[1]) ;
  Enc42a e2(a[11:8], c[5:4],d[2]) ;
  Enc42a e3(a[15:12],c[7:6],d[3]) ;

  // MSB encoder takes summaries and gives msb of output
  Enc42 e4(d[3:0], b[3:2]) ;

  // two OR gates combine output of LSB encoders
  assign b[1] = c[1]|c[3]|c[5]|c[7] ;
  assign b[0] = c[0]|c[2]|c[4]|c[6] ;
endmodule
//---------------------------------------------------------------------

// two input mux with one-hot select (arbitrary width)
module Mux2(a0, a1, s, b) ;
  parameter k = 1 ;
  input [k-1:0] a0, a1 ;  // inputs
  input [1:0]   s ; // one-hot select
  output[k-1:0] b ;
  wire [k-1:0] b = ({k{s[0]}} & a0) | 
                   ({k{s[1]}} & a1) ;
endmodule

//---------------------------------------------------------------------

// four input mux with one-hot select (arbitrary width)
module Mux4(a0, a1, a2, a3, s, b) ;
  parameter k = 1 ;
  input [k-1:0] a0, a1, a2, a3 ;  // inputs
  input [3:0]   s ; // one-hot select
  output[k-1:0] b ;
  wire [k-1:0] b = ({k{s[0]}} & a0) | 
                   ({k{s[1]}} & a1) |
                   ({k{s[2]}} & a2) |
                   ({k{s[3]}} & a3) ;
endmodule

//---------------------------------------------------------------------

// five input mux with one-hot select (arbitrary width)
module Mux5(a0, a1, a2, a3, a4, s, b) ;
  parameter k = 1 ;
  input [k-1:0] a0, a1, a2, a3, a4 ;  // inputs
  input [4:0]   s ; // one-hot select
  output[k-1:0] b ;
  wire [k-1:0] b = ({k{s[0]}} & a0) | 
                   ({k{s[1]}} & a1) |
                   ({k{s[2]}} & a2) |
                   ({k{s[3]}} & a3) |
                   ({k{s[4]}} & a4) ;
endmodule
//---------------------------------------------------------------------

// eight input mux with one-hot select (arbitrary width)
module Mux8(a0, a1, a2, a3, a4, a5, a6, a7, s, b) ;
  parameter k = 1 ;
  input [k-1:0] a0, a1, a2, a3, a4, a5, a6, a7 ;  // inputs
  input [7:0]   s ; // one-hot select
  output[k-1:0] b ;
  wire [k-1:0] b = ({k{s[0]}} & a0) | 
                   ({k{s[1]}} & a1) |
                   ({k{s[2]}} & a2) |
                   ({k{s[3]}} & a3) |
                   ({k{s[4]}} & a4) |
                   ({k{s[5]}} & a5) |
                   ({k{s[6]}} & a6) |
                   ({k{s[7]}} & a7) ;
endmodule
//----------------------------------------------------------------------
// funnel shifter - takes an n-bit input and shifts it by up to n-m
// bits to generate an m-bit output
// one hot input s selects how much to shift. 
// if s[i] is high bit in[i+j] is routed to out[j].
// if s is zero, out is undefined
//---------------------------------------------------------------------

module FunnelShift(in, s, out) ;
  parameter n = 12 ;
  parameter m = 5 ;
  input [n-1:0] in ;
  input [n-m-1:0] s ;
  output [m-1:0] out ;
  reg [m-1:0] out ;
  integer i ;

  always @(in or s) begin
    for(i=0;i<(n-m);i=i+1) begin
      if(s[i] == 1) out = in>>i ;
    end 
    if(s == 0) out = {m{1'bx}} ;
  end
endmodule  
//---------------------------------------------------------------------

// mux with one-hot select (arbitrary ports - one bit wide)
module Mux(a,s,b) ;
  parameter n = 8 ;
  input [n-1:0] a, s ;
  output b ;
  wire [n-1:0] p = a & s ; // product of input and select
  wire b = |p ;
endmodule 
//---------------------------------------------------------------------

// mux with binary select (arbitrary width)
module BMux(a, s, b) ;
  parameter n = 8 ;
  parameter m = 3 ;
  input[n-1:0] a ;
  input[m-1:0] s ;
  output b ;
  wire [n-1:0] ds ; // decoded select
  
  Decoder #(m,n) dec(s, ds) ;
  Mux #(n) mux(a, ds, b) ;
endmodule
//---------------------------------------------------------------------

// arbiter (arbitrary width) - LSB is highest priority
module Arb(r, g) ;
  parameter n=8 ;
  input  [n-1:0] r ;
  output [n-1:0] g ;
  wire   [n-1:0] c = {(~r[n-2:0] & c[n-2:0]),1'b1} ;
  wire   [n-1:0] g = r & c ;
endmodule
//----------------------------------------------------------------------
// arbiter (arbitrary width) - MSB is highest priority
module RArb(r, g) ;
  parameter n=8 ;
  input  [n-1:0] r ;
  output [n-1:0] g ;
  wire   [n-1:0] c = {1'b1,(~r[n-1:1] & c[n-1:1])} ;
  wire   [n-1:0] g = r & c ;
endmodule
//---------------------------------------------------------------------

// priority encoder (arbitrary width)
module PriorityEncoder(r, b) ;
  parameter n=8 ;
  parameter m=3 ;
  input  [n-1:0] r ;
  output [m-1:0] b ;
  wire   [n-1:0] g ;
  Arb #(n) a(r, g) ;
  Encoder #(n,m) e(g, b) ;
endmodule
//---------------------------------------------------------------------
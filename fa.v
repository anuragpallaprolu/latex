module fa(a,b,cin,sum,cout);
        input a,b,cin;
        output sum, cout;

        assign sum = cin ^ a ^ b;
        assign cout = ~cin & a & b| cin & (a|b);

endmodule
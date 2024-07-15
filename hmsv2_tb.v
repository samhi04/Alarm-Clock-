module tb;
reg clk=0; always #5 clk=!clk;
reg rst=1;initial #2 rst=0;
reg mode=0,modeNBA=0; always @* modeNBA<=mode;
reg inc=0,incNBA=0; always @* incNBA<=inc;
reg dec=0,decNBA=0; always @* decNBA<=dec;
wire [4:0] hrs;
wire [5:0] min;
wire [5:0] sec;

hmsv2 JAILER (
.clk(clk),
.rst(rst),
.inc(incNBA),
.dec(decNBA),
.mode(modeNBA),
.hrs(hrs),
.min(min),
.sec(sec)
);

//`include "testcase1.txt"
`include "testcase2.txt"
//testcase3.txt
/*
initial 
   begin 
   repeat(5) @(posedge clk);
   modepulse; //HB;
   fork
      modepulse;//MB 
      incpulse;//
   join 
   repeat(5) @(posedge clk);
   $finish;
   end 
   
  
`include "tasks.txt"   
*/
endmodule 
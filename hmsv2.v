module hmsv2 (
   input clk,
   input rst,
   input mode, 
   input inc, 
   input dec, 
   output reg [4:0]hrs, 
   output reg [5:0]min, 
   output reg [5:0] sec
);

//declarations
wire [4:0] carefully_decremented_hrs, carefully_incremented_hrs;
wire [5:0] carefully_decremented_min, carefully_incremented_min;
wire [5:0] carefully_decremented_sec, carefully_incremented_sec;

enum {RUN,HB,MB,SB} state;
//parameter RUN=0;HB=1;MB=2;SB=3;
//reg [1:0] state;

always @ (posedge clk or posedge rst)
begin 
    if (rst) state <= RUN ;
	else 
	case (state)
	RUN: state<=mode?HB:RUN;
	HB: state<=mode?MB:HB;
	MB: state<=mode?SB:MB;
	SB: state<=mode?RUN:SB;
	endcase 
end 

always @(posedge clk or posedge rst)
begin 
    if (rst) sec <=0;
	else 
	case (state)
	RUN: sec <= carefully_incremented_sec;
	HB: sec<=sec;
	SB: sec<=sec;
	MB: if (inc) sec<=carefully_incremented_sec;
	    else sec<=dec?(carefully_decremented_sec):sec;
	endcase
end 


always @(posedge clk or posedge rst)
begin 
    if (rst) min <=0;
	else 
	case (state)
	RUN: if(sec==59)
	        min <=carefully_incremented_min;
		else min <= min;
	HB: min<=min;
	SB: min<=min;
	MB: if (inc) min<=carefully_incremented_min;
	    else min<=dec?(carefully_decremented_min):min;
	endcase
end 

always @(posedge clk or posedge rst)
begin 
    if (rst) hrs <=0;
	else 
	case (state)
	RUN: if ({sec,min} == {6'd59,6'd59})
	        hrs<=carefully_incremented_hrs;
		else hrs<=hrs;
	MB: hrs<=hrs;
	SB: hrs<=hrs;
	HB: `ifdef BUG 
	        if (inc) hrs<=carefully_incremented_hrs;//hrs+1;
			else hrs<=dec?carefully_decremented_hrs:hrs;
		`endif 
		`ifdef FIX 
		    if (mode) hrs<=hrs;
			else 
			case({inc,dec})
			2'b00:hrs<=hrs;
			2'b01:hrs<=carefully_decremented_hrs;
			2'b10:hrs<=carefully_incremented_hrs;
			2'b11:hrs<=hrs; //fix 
			endcase 
		`endif
	endcase 
end 

assign carefully_incremented_hrs = (hrs==23) ? 0:(hrs+1);
assign carefully_decremented_hrs = (hrs==0) ? 23:(hrs-1);
assign carefully_incremented_min = (min==59) ? 0:(min+1);
assign carefully_decremented_min = (min==0) ? 59:(min-1);
assign carefully_incremented_sec = (sec==59) ? 0:(sec+1);
assign carefully_decremented_sec = (sec==0) ? 59:(sec-1);

endmodule 


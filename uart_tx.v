
module uart_tx (sys_clk,		//clock signal, 40kHz
				sys_rst_n, 		    //reset signal, active low
				din,			//the input data which will be sent by the UART module, 8 bit width
				send_start,	    //the start enable signal, active high, the width is one clock period
				bit_out		    //the serial output data 
				);
input           sys_clk;		//clock signal, 40kHz
input			sys_rst_n;  	    //reset signal, active low
input		[7:0]	din;    		//the input data which will be sent by the UART module, 8 bit width
input			send_start;	    //the start enable signal, active high, the width is one clock period
output			bit_out;	    //the serial output data 

reg     [9:0]   din_temp;
reg             en;
reg     [16:0]   clk_cnt;
reg     [3:0]   bit_cnt;

reg             bit_out;

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    din_temp <= 10'd0;
else if(send_start)
    din_temp <= {1'b1, din, 1'b0};
else if((clk_cnt == 17'd399) && (bit_cnt == 4'd9))
    din_temp <= 10'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    en <= 1'b0;
else if(send_start)
    en <= 1'b1;
else if((clk_cnt == 17'd399) && (bit_cnt == 4'd9))
    en <= 1'b0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    clk_cnt <= 17'd0;
else if(clk_cnt == 17'd399)
    clk_cnt <= 17'd0;
else if(en)
    clk_cnt <= clk_cnt + 1'b1;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    bit_cnt <= 4'd0;
else if((clk_cnt == 17'd399) && (bit_cnt == 4'd9))
    bit_cnt <= 4'd0;
else if(clk_cnt == 17'd399)
    bit_cnt <= bit_cnt + 1'b1;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    bit_out <= 1'b1;
else if(en)
    bit_out <= din_temp[ bit_cnt ];
else
    bit_out <= 1'b1;
end

endmodule
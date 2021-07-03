module uart_rx( sys_clk,
                sys_rst_n,
                bit_in,
                dout_vld,
                dout
);

input           sys_clk;
input           sys_rst_n;
input           bit_in;
output          dout_vld;
output  [7:0]   dout;

reg             en;
reg     [16:0]   clk_cnt;
reg     [3:0]   bit_cnt;
reg     [1:0]   a;
reg     [2:0]   bit_in_dly;

reg     [7:0]   dout;
reg             dout_vld;

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    bit_in_dly <= 3'b111;
else
    bit_in_dly <= {bit_in_dly[1:0], bit_in};
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    en <= 1'b0;
else if(~bit_in_dly[1])
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
    a <= 2'd0;
else if(clk_cnt == 17'd180 || clk_cnt == 17'd200 || clk_cnt == 17'd220)
    a <= a + bit_in_dly[2];
else if(clk_cnt == 17'd240)
    a <= 2'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    dout <= 8'd0;
else if((clk_cnt == 17'd399) && (bit_cnt == 4'd9))
    dout <= 8'd0;
else if(clk_cnt == 17'd230 && 4'd1 <= bit_cnt <= 4'd8)
    dout[bit_cnt-1] <= a>=2'd2 ? 1'b1 : 1'b0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
if(~sys_rst_n)
    dout_vld <= 1'b0;
else if((clk_cnt == 17'd230) && (bit_cnt == 4'd9))
    dout_vld <= 1'b1;
else
    dout_vld <= 1'b0;
end

endmodule
`timescale 1ns/1ns

module tb_skin();
    
    reg sys_clk;
    reg sys_rst_n;
    reg data_out_ready_fy;
    reg [7:0] data_fy;
    
    wire bit_in;
    wire dout_vld;
    wire [7:0] dout;
    wire data_in_valid;
    assign data_in_valid = dout_vld;
    wire [7:0] data_in;
    assign data_in = dout;
    wire data_out_ready1;
    wire [7:0] r_data1;
    wire [7:0] g_data1;
    wire [7:0] b_data1;
    wire data_out_ready2;
    wire [7:0] r_data2;
    wire [7:0] g_data2;
    wire [7:0] b_data2;
    wire data_out_ready;
    wire [7:0] data_out;
    wire bit_out;
    
    wire dout_vld_checker;
    wire [7:0] dout_check;
    
    
    integer N = 18;
    integer i = 1;
    initial begin
        sys_clk           = 1'b1;
        sys_rst_n         = 1'b1;
        data_out_ready_fy = 1'b0;
        #500;
        sys_rst_n = 1'b0;
        #10;
        sys_rst_n = 1'b1;
        #50
        
        while(i<=N) begin
            data_out_ready_fy = 1'b1;
            data_fy           = i;
            #10
            data_out_ready_fy = 1'b0;
            #39990;
            i = i + 1;
        end
    end
    
    always #5 sys_clk = ~sys_clk;
    
    //bit_maker
    uart_tx bit_maker(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .din(data_fy),
    .send_start(data_out_ready_fy),
    .bit_out(bit_in)
    );
    
    //receive
    uart_rx ur(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .bit_in(bit_in),
    .dout_vld(dout_vld),
    .dout(dout)
    );
    
    //send
    uart_tx ut(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .din(data_out),
    .send_start(data_out_ready),
    .bit_out(bit_out)
    );
    
    
    //cheker
    uart_rx checker(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .bit_in(bit_out),
    .dout_vld(dout_vld_checker),
    .dout(dout_check)
    );
    
    whatever1
    whatever1_dut (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .r_data_out(r_data1),
    .g_data_out(g_data1),
    .b_data_out(b_data1),
    .data_out_ready(data_out_ready1)
    );
    
    process
    process_dut(
    .data_in_valid(data_out_ready1),
    .r_data_in(r_data1),
    .g_data_in(g_data1),
    .b_data_in(b_data1),
    .r_data_out(r_data2),
    .g_data_out(g_data2),
    .b_data_out(b_data2),
    .data_out_ready(data_out_ready2)
    );
    
    whatever2
    #(.COUNT1_MAX (4000))
    whatever2_dut(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .data_in_valid(data_out_ready2),
    .r_data_in(r_data1),
    .g_data_in(g_data1),
    .b_data_in(b_data1),
    .data_out(data_out),
    .data_out_ready(data_out_ready)
    );
    
endmodule

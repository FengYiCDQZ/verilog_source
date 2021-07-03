module skin(input sys_clk,
            input sys_rst_n,
            input bit_in,
            output bit_out);
    
    wire         dout_vld;
    wire  [7:0]  dout;
    
    wire data_out_ready1;
    wire [7:0] r_data1;
    wire [7:0] g_data1;
    wire [7:0] b_data1;

    wire data_out_ready2;
    wire [7:0] r_data2;
    wire [7:0] g_data2;
    wire [7:0] b_data2;
    
    wire data_in_valid;
    wire [7:0] data_in;

    wire data_out_ready;
    wire [7:0] data_out;
    
    assign data_in       = dout;
    assign data_in_valid = dout_vld;

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
    #(.COUNT1_MAX (10'd4000))
    whatever2_dut(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .data_in_valid(data_out_ready2),
    .r_data_in(r_data2),
    .g_data_in(g_data2),
    .b_data_in(b_data2),
    .data_out(data_out),
    .data_out_ready(data_out_ready)
    );
    
endmodule

module rgb2ycbcr (input wire [7:0] r_data,
                  input wire [7:0] g_data,
                  input wire [7:0] b_data,
                  output wire [7:0] y_data,
                  output wire [7:0] cb_data,
                  output wire [7:0] cr_data);
    
    wire [9:0] y_r,y_g,y_b;
    wire [9:0] cb_r,cb_g,cb_b;
    wire [9:0] cr_r,cr_g,cr_b;
    wire [11:0] y,cb,cr;
    
    assign y  = y_r+y_g+y_b+10'd64;
    assign cb = cb_r+cb_g+cb_b+10'd512;
    assign cr = cr_r+cr_g+cr_b+10'd512;
    
    assign y_data  = y[9:2];
    assign cb_data = cb[9:2];
    assign cr_data = cr[9:2];
    
    mul_y_r mul_y_r_dut (
    .a(r_data),
    .spo(y_r));
    
    mul_y_g mul_y_g_dut (
    .a(g_data),
    .spo(y_g));
    
    mul_y_b mul_y_b_dut (
    .a(b_data),
    .spo(y_b));
    
    mul_cb_r mul_cb_r_dut(
    .a(r_data),
    .spo(cb_r));
    
    mul_cb_g mul_cb_g_dut(
    .a(g_data),
    .spo(cb_g));
    
    mul_cb_b mul_cb_b_dut(
    .a(b_data),
    .spo(cb_b));
    
    mul_cr_r mul_cr_r_dut(
    .a(r_data),
    .spo(cr_r));
    
    mul_cr_g mul_cr_g_dut(
    .a(g_data),
    .spo(cr_g));
    
    mul_cr_b mul_cr_b_dut(
    .a(b_data),
    .spo(cr_b));
    
endmodule

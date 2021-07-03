module process (input wire data_in_valid,
                input wire [7:0] r_data_in,
                input wire [7:0] g_data_in,
                input wire [7:0] b_data_in,
                output reg [7:0] r_data_out,
                output reg [7:0] g_data_out,
                output reg [7:0] b_data_out,
                output wire data_out_ready);
    
    wire [7:0] y_data;
    wire [7:0] cb_data;
    wire [7:0] cr_data;
    assign data_out_ready = data_in_valid;
    
    rgb2ycbcr
    rgb2ycbcr_dut (
    .r_data (r_data_in),
    .g_data (g_data_in),
    .b_data (b_data_in),
    .y_data (y_data),
    .cb_data (cb_data),
    .cr_data  (cr_data)
    );
    
    always @(*) begin
        if (cb_data>8'd76&&cb_data<8'd128&&cr_data>8'd132&&cr_data<8'd174) begin
            r_data_out = 8'd255;
            g_data_out = 8'd255;
            b_data_out = 8'd255;
        end
        else begin
            r_data_out = 8'd0;
            g_data_out = 8'd0;
            b_data_out = 8'd0;
        end
    end
    
endmodule

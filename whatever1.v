module whatever1 (input wire sys_clk,
                  input wire sys_rst_n,
                  input wire data_in_valid,
                  input wire [7:0] data_in,
                  output reg [7:0] r_data_out,
                  output reg [7:0] g_data_out,
                  output reg [7:0] b_data_out,
                  output reg data_out_ready);
    
    reg [7:0] l_shift[1:0];
    reg [1:0] count;
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            l_shift[2] <= 8'b0;
            l_shift[1] <= 8'b0;
            l_shift[0] <= 8'b0;
        end
        else begin
            if (data_in_valid == 1'b1) begin
                l_shift[1] <= l_shift[0];
                l_shift[0] <= data_in;
            end
        end
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            count <= 2'b0;
        end
        else begin
            if (data_in_valid == 1'b1) begin
                if (count == 2'd3) begin
                    count <= 2'd1;
                end
                else begin
                    count <= count+2'd1;
                end
                
            end
        end
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            data_out_ready <= 1'b0;
        end
        else begin
            if (data_in_valid == 1'b1 && count == 2'd2) begin
                data_out_ready <= 1'b1;
            end
            else begin
                data_out_ready <= 1'b0;
            end
        end
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            r_data_out <= 8'd0;
            g_data_out <= 8'd0;
            b_data_out <= 8'd0;
        end
        else begin
            if (data_in_valid == 1'b1 && count == 2'd2) begin
                r_data_out <= l_shift[1];
                g_data_out <= l_shift[0];
                b_data_out <= data_in;
            end
        end
    end
    
endmodule

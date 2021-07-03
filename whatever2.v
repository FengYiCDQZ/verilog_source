module whatever2 (input wire sys_clk,
                  input wire sys_rst_n,
                  input wire data_in_valid,
                  input wire [7:0] r_data_in,
                  input wire [7:0] g_data_in,
                  input wire [7:0] b_data_in,
                  output reg [7:0] data_out,
                  output reg data_out_ready);
    
    parameter COUNT1_MAX = 10'd500;
    reg [9:0] count1;
    reg [1:0] count2;
    reg [7:0] r_data;
    reg [7:0] g_data;
    reg [7:0] b_data;
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            r_data <= 8'b0;
            g_data <= 8'b0;
            b_data <= 8'b0;
        end
        else begin
            if (data_in_valid == 1'b1) begin
                r_data <= r_data_in;
                g_data <= g_data_in;
                b_data <= b_data_in;
            end
        end
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            count1 <= 10'd0;
        end
        else begin
            if (data_in_valid == 1'b1) begin
                count1 <= 10'd0;
            end
            else begin
                if (count1 == COUNT1_MAX-10'd1) begin
                    count1 <= 10'd0;
                end
                else begin
                    count1 <= count1+10'd1;
                end
            end
            
        end
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            count2 <= 2'd2;
        end
        else begin
            if (data_in_valid == 1'b1) begin
                count2 <= 2'd0;
            end
            else begin
                if (count1 == COUNT1_MAX-10'd1) begin
                    if (count2 == 2'd2) begin
                        count2 <= 2'd2;
                    end
                    else begin
                        count2 <= count2+2'd1;
                    end
                end
            end
        end
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0) begin
            data_out_ready <= 1'b0;
        end
        else begin
            if (data_in_valid == 1'b1||(count1 == COUNT1_MAX-10'd1&&count2 < 2'd2)) begin
                data_out_ready <= 1'b1;
            end
            else begin
                data_out_ready <= 1'b0;
            end
        end
    end
    
    always @(*) begin
        case (count2)
            2'd0:data_out    <= r_data;
            2'd1:data_out    <= g_data;
            2'd2:data_out    <= b_data;
            default:data_out <= 8'd0;
        endcase
    end
    
endmodule

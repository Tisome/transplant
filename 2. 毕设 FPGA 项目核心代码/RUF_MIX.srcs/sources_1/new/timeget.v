`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:32:44
// Design Name: 
// Module Name: timeget
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module timeget #(
 parameter ACCW = 40   // 内部参数：际输入宽度 = ACCW-1
) (
    input  wire                     clk,         // 100MHz
    input  wire                     rst_n,

    input  wire signed [ACCW-1:0]   data_in,     // 数据输入（有符号，宽度 ACCW-1）
    input  wire                     data_valid,
    input  wire [15:0]              data_count,  //用于算时间
    
    //input  wire                     frame_start, // 帧开始（可选, 用于重置当前最大值）
    input  wire                     frame_end,   // 帧结束，模块在 frame_end 后输出 max 并脉冲 max_valid

    //input  wire                     rst_max,     // 手动复位当前最大值（如果不使用 frame_start/frame_end 可以由外部驱动此信号）

    output reg  signed [ACCW-1:0]   max_out,
    output reg         [15:0]       max_idx,
    output reg                      max_valid
);

    // 内部寄存器保存当前帧的最大值，及是否见过有效数据
    reg signed [ACCW-1:0] curr_max;
    reg                   seen_any;  //第一个数据直接保存
    reg        [15:0]     curr_idx;
    // 计算最小可表示数（two's complement 最小值）
    // e.g. for width W = ACCW-1, min = 1 << (W-1) as signed representation
    localparam integer W = ACCW;
    // build konst for minimum value: 1 followed by zeros
    wire signed [ACCW-1:0] MIN_VAL;
    assign MIN_VAL = {1'b1, {(W-1){1'b0}} };

    // synchronous logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            curr_max  <= MIN_VAL;
            seen_any  <= 1'b0;
            max_out   <= MIN_VAL;
            max_valid <= 1'b0;
            curr_idx  <= 16'd0;
        end else begin
            // default
            max_valid <= 1'b0;

            // reset current max on frame_start or rst_max
//            if (frame_start || rst_max) begin
//                curr_max <= MIN_VAL;
//                seen_any <= 1'b0;
//                curr_idx <= 16'd0;
//            end

            // 当 data_valid 时更新 curr_max（有符号比较）
            if (data_valid) begin
                if (!seen_any) begin
                    curr_max <= data_in;
                    seen_any <= 1'b1;
                    curr_idx <= data_count;
                end else begin
                    // 直接比较 signed
                    if (data_in > curr_max) begin
                        curr_max <= data_in;
                        curr_idx <= data_count;
                    end
                end
            end

            // 当 frame_end 时，输出本帧最大值并在下一周期脉冲 max_valid
            if (frame_end) begin
                // 如果本帧没有任何有效数据，输出 MIN_VAL（或可按需改为 0 / last）
                max_out   <= curr_max;
                max_valid <= 1'b1;
                max_idx   <= curr_idx;
                // 同时为下一帧重置 curr_max 与 seen_any（可在 frame_start 做）
                curr_max  <= MIN_VAL;
                seen_any  <= 1'b0;
                curr_idx <= 16'd0;
            end
        end
    end
endmodule


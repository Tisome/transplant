`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:57:19
// Design Name: 
// Module Name: timeget_tb
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


module timeget_tb;
    // 参数
    localparam ACCW = 42;
    localparam CLK_PERIOD = 10; // 100MHz -> 10ns
    localparam DATA_LEN = 650;   // 每帧的数据个数

    // DUT 信号
    reg                     clk;
    reg                     rst_n;
    reg  signed [ACCW-1:0]   data_in;
    reg                     data_valid;
    reg  [15:0]              data_count;
    reg                     frame_start;
    reg                     frame_end;
    reg                     rst_max;
    wire signed [ACCW-1:0]   max_out;
    wire [15:0]              max_idx;
    wire                    max_valid;

    // 生成时钟
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // 实例化 DUT
    timeget #(
        .ACCW(ACCW)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_valid(data_valid),
        .data_count(data_count),
       // .frame_start(frame_start),
        .frame_end(frame_end),
       //.rst_max(rst_max),
        .max_out(max_out),
        .max_idx(max_idx),
        .max_valid(max_valid)
    );

    // 驱动任务：一帧数据
    task send_frame(input integer N);
        integer i;
        begin
            frame_start = 1;
            @(posedge clk);
            frame_start = 0;

            for (i = 0; i < N; i = i + 1) begin
                data_in     = $random % 1000;  // 模拟有符号数
                data_valid  = 1;
                data_count  = i;           
                @(posedge clk);
                data_valid = 0;
                // 10MHz 数据 -> 间隔 10 * 100MHz 时钟周期
                repeat (9) @(posedge clk);
            end

            // 发出 frame_end
            frame_end = 1;
            @(posedge clk);
            frame_end = 0;
        end
    endtask

    // 初始化与刺激
    initial begin
        // 初始化
        rst_n       = 0;
        data_in     = 0;
        data_valid  = 0;
        data_count  = 0;
        frame_start = 0;
        frame_end   = 0;
        rst_max     = 0;

        // 复位
        #(5*CLK_PERIOD);
        rst_n = 1;
        @(posedge clk);

        // 第一帧
        send_frame(DATA_LEN);

        // 等待 1ms -> 100MHz 时钟下 1ms = 100000 个周期
        repeat (100000) @(posedge clk);

        // 第二帧
        send_frame(DATA_LEN);

        // 等待 1ms -> 100MHz 时钟下 1ms = 100000 个周期
        repeat (100000) @(posedge clk);

        // 第二帧
        send_frame(DATA_LEN);

        // 等待 1ms -> 100MHz 时钟下 1ms = 100000 个周期
        repeat (100000) @(posedge clk);

        // 第二帧
        send_frame(DATA_LEN);

        // 等待 1ms -> 100MHz 时钟下 1ms = 100000 个周期
        repeat (100000) @(posedge clk);

        // 第二帧
        send_frame(DATA_LEN);

        // 再等一会，结束仿真
        repeat (1000) @(posedge clk);
        //$stop;
    end

    // 打印结果
    always @(posedge clk) begin
        if (max_valid) begin
            $display("[%0t ns] Frame Max = %0d, Index = %0d", $time, max_out, max_idx);
        end
    end
endmodule
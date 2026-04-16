`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:58:37
// Design Name: 
// Module Name: al_tb
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


module al_tb;
    // --------------------------
    // 参数配置
    // --------------------------
    localparam DATAW    = 16;
    localparam COEFFW   = 16;
    localparam TAPS     = 150;
    localparam P        = 5;
    localparam ACCW     = DATAW + COEFFW + 10;
    localparam DATA_LEN = 2000;

    // --------------------------
    // 接口信号
    // --------------------------
    reg  clk;
    reg  clk_10m;
    reg  rst_n;
    reg  signed [DATAW-1:0] sample_in;
    reg  sample_valid;
    wire busy;
    wire out_valid;
    wire signed [ACCW-1:0] conv_out;
    wire [15:0] produced_cnt;

    // --------------------------
    // DUT 实例化
    // --------------------------
    algorithm #(
        .DATAW(DATAW),
        .COEFFW(COEFFW),
        .TAPS(TAPS),
        .P(P),
        .ACCW(ACCW),
        .DATA_LEN(DATA_LEN)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .sample_in(sample_in),
        .sample_valid(sample_valid),
        .busy(busy),
        .out_valid_reg(out_valid),
        .conv_out(conv_out),
        .produced_cnt_reg(produced_cnt)
    );

    // --------------------------
    // 时钟：100MHz → 周期 10ns
    // --------------------------
    initial clk = 0;
    always #5 clk = ~clk;  // 100MHz
    //always #500 clk_10m = ~clk_10m;  // 10MHz
    // --------------------------
    // 复位
    // --------------------------
    initial begin
        rst_n = 0;
        sample_in = 0;
        sample_valid = 0;
        #100;
        rst_n = 1;
    end

    // --------------------------
    // 输入数据：10MHz 输入速率
    // 每 10 个 100MHz 周期送 1 个数据
    // --------------------------
//    integer i;
//    integer k;
//    integer sample_period;
//    initial begin
//        sample_period = 12; // 10 个 100MHz 周期 = 1 个 10MHz 采样周期
//        @(posedge rst_n);
//        @(posedge clk);
//        for (i = 1; i <= DATA_LEN; i = i + 1) begin
//            sample_in = i;
//            sample_valid = 1;
//            @(posedge clk);
//            sample_valid = 0;
//            // 空闲 9 个周期，保证输入速率 10MHz
//            repeat (sample_period-1) @(posedge clk);
//        end
//    end
//    initial begin
//      # 1000000;
//      sample_period = 20; // 10 个 100MHz 周期 = 1 个 10MHz 采样周期
////      k=1;
//        @(posedge rst_n);
//        @(posedge clk);
//        for (k = 1; k <= DATA_LEN; k = k + 1) begin
//            sample_in = k;
//            sample_valid = 1;
//            @(posedge clk);
//            sample_valid = 0;
//            // 空闲 9 个周期，保证输入速率 10MHz
//            repeat (sample_period-1) @(posedge clk);
//        end
//    end

integer i;
integer sample_period;

task send_sequence;
    integer k;
    begin
        for (k = 0; k <=DATA_LEN; k = k + 1) begin
            sample_in    = k;
            sample_valid = 1;
            @(posedge clk);
            sample_valid = 0;
            // 空闲 9 个周期，保证输入速率 10MHz
            repeat (sample_period-1) @(posedge clk);
        end
    end
endtask

initial begin
    sample_period = 50; // 每50个100MHz周期 = 1个2MHz采样周期
    sample_in     = 0;
    sample_valid  = 0;

    // 等待复位结束
    @(posedge rst_n);
    @(posedge clk);

    // 第一次发送
    send_sequence();

    // 等待1ms
    #(500000);  // 如果 timescale 是 1ns, 这就是1ms

    // 第二次发送
    send_sequence();

       // 等待1ms
    #(500000);  // 如果 timescale 是 1ns, 这就是1ms

    // 第3次发送
    send_sequence();
           // 等待1ms
    #(500000);  // 如果 timescale 是 1ns, 这就是1ms

    // 第3次发送
    send_sequence();
           // 等待1ms
    #(500000);  // 如果 timescale 是 1ns, 这就是1ms

    // 第3次发送
    send_sequence();
end
//always @(posedge clk_10m)     
//if(!rst_n) begin
//      sample_in <= 16'd0;
//      sample_valid <= 1'b0;
//end else 
//      sample_in <= sample_in + 16'd1;
//      sample_valid <= 1'b1;
//end      
    // --------------------------
    // 输出监控
    // --------------------------
    always @(posedge clk) begin
        if (out_valid) begin
            $display("Time=%0t, Output[%0d] = %0d", $time, produced_cnt, conv_out);
        end
    end

    // --------------------------
    // 仿真时间控制
    // --------------------------
    initial begin
        #11000000; // 5ms 仿真，按需求可调整
        $finish;
    end

endmodule

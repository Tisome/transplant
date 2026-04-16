`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/05 22:32:57
// Design Name: 
// Module Name: AD2_tb
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

module AD2_tb();
//=============================
    // 仿真参数
    //=============================
    reg         adc_clk;       // 65 MHz
    reg         al_clk;        // 5 MHz
    reg         rst_n;
    reg         ad_start;
    reg  [11:0] adc_data;
    wire        adc_buf_en;
    wire [15:0] adc_buf_data;

    //=============================
    // DUT 实例化
    //=============================
    AD uut (
        .adc_clk(adc_clk),
        .al_clk(al_clk),
        .rst_n(rst_n),
        .ad_start(ad_start),
        .adc_data(adc_data),
        .adc_buf_en(adc_buf_en),
        .adc_buf_data(adc_buf_data)
    );

    //=============================
    // 时钟生成
    //=============================
    // 65 MHz -> 周期 ≈ 15.384 ns
    initial adc_clk = 0;
    always #7.692 adc_clk = ~adc_clk;

    // 5 MHz -> 周期 200 ns
    initial al_clk = 0;
    always #5 al_clk = ~al_clk;

    //=============================
    // 复位 & 启动
    //=============================
    initial begin
        rst_n   = 0;
        ad_start = 0;
        adc_data = 12'd0;
        #200;              // 200ns 后释放复位
        rst_n = 1;

        // 延时一段时间后启动采集
        #500;
        ad_start = 1;
        #30;               // 只保持一个周期的高电平
        ad_start = 0;
    end

    //=============================
    // 输入数据产生
    //=============================
    integer i;
    initial begin
        wait(rst_n == 1);
        wait(ad_start == 1);
        wait(ad_start == 0);

        // 从 ad_start 之后，提供 20000 个数据
        for (i = 0; i < 20000; i = i + 1) begin
            @(posedge adc_clk);
            adc_data <= i[11:0];   // 输入数据模式：循环计数
        end

        // 数据输入结束
        @(posedge adc_clk);
        adc_data <= 12'd0;

        // 再等待一段时间
        #10000000;
        ad_start = 1;
        #30;               // 只保持一个周期的高电平
        ad_start = 0;
         for (i = 0; i < 20000; i = i + 1) begin
            @(posedge adc_clk);
            adc_data <= i[11:0];   // 输入数据模式：循环计数
        end
        //$finish;
    end

    //=============================
    // 输出监视
    //=============================
    always @(posedge al_clk) begin
        if (adc_buf_en)
            $display("[%t] Output Data = %d", $time, adc_buf_data);
    end



endmodule


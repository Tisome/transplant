`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 23:57:45
// Design Name: 
// Module Name: ai_corr_tb
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

//`timescale 1ns/1ps

//module ai_corr_tb;

//  //==================================================
//  // 参数：控制节拍
//  //==================================================
//  localparam integer AD_LEN            = 2000;
//  localparam integer SAMPLE_PERIOD_CYC = 50;     // 每N个clk一个样本
//  localparam integer FRAME_GAP_CYC     = 20000;  // A-B间隔

//  //==================================================
//  // 时钟 & 复位
//  //==================================================
//  reg clk_100M = 1'b0;
//  always #5 clk_100M = ~clk_100M; // 100MHz

//  reg rst_n = 1'b0;

//  initial begin
//    rst_n = 1'b0;
//    repeat(20) @(posedge clk_100M);
//    rst_n = 1'b1;
//  end

//  //==================================================
//  // 输入信号
//  //==================================================
//  reg  signed [15:0] sample_in;
//  reg                sample_valid;
//  reg                channel_seg;

//  //==================================================
//  // DUT
//  //==================================================
//  corr dut (
//    .clk_100M      (clk_100M),
//    .rst_n         (rst_n),
//    .sample_in     (sample_in),
//    .sample_valid  (sample_valid),
//    .channel_seg   (channel_seg),
//    .out_valid_reg (),
//    .conv_out_y1   (),
//    .conv_out_y2   (),
//    .conv_out_y3   ()
//  );

//  //==================================================
//  // 发送一帧任务（1..2000）
//  //==================================================
//  task automatic send_frame(input reg ch);
//    integer i;
//    begin
//      channel_seg  = ch;
//      sample_valid = 1'b0;

//      @(posedge clk_100M);

//      for(i = 1; i <= AD_LEN; i = i + 1) begin

//        // 数据切换 + valid打一拍
//        sample_in    = i[15:0];
//        sample_valid = 1'b1;
//        @(posedge clk_100M);

//        // valid拉低
//        sample_valid = 1'b0;

//        // 等待 N-1 拍
//        repeat(SAMPLE_PERIOD_CYC-1)
//          @(posedge clk_100M);
//      end
//    end
//  endtask

//  //==================================================
//  // 主流程
//  //==================================================
//  initial begin

//    // init
//    sample_in    = 16'sd0;
//    sample_valid = 1'b0;
//    channel_seg  = 1'b0;

//    @(posedge rst_n);
//    repeat(50) @(posedge clk_100M);

//    // Frame A (顺流)
//    send_frame(1'b1);

//    // 间隔
//    repeat(FRAME_GAP_CYC) @(posedge clk_100M);

//    // Frame B (逆流)
//    send_frame(1'b0);

//    // 再跑一会观察波形
//    repeat(100000) @(posedge clk_100M);

//    $finish;
//  end

//endmodule

module ai_corr_tb;

  //==================================================
  // 参数：控制节拍/间隔（长度固定2000）
  //==================================================
  localparam integer AD_LEN            = 2000;
  localparam integer SAMPLE_PERIOD_CYC = 50;     // 每N个clk一个样本（valid打一拍）
  localparam integer FRAME_GAP_CYC     = 20000;  // A-B间隔（clk周期数）

  //==================================================
  // 时钟 & 复位
  //==================================================
  reg clk_100M = 1'b0;
  always #5 clk_100M = ~clk_100M; // 100MHz

  reg rst_n = 1'b0;
  initial begin
    rst_n = 1'b0;
    repeat(20) @(posedge clk_100M);
    rst_n = 1'b1;
  end

  //==================================================
  // 输入信号
  //==================================================
  reg  signed [15:0] sample_in;
  reg                sample_valid;
  reg                channel_seg;

  //==================================================
  // DUT 输出
  //==================================================
  wire               out_valid_reg;
  wire signed [47:0] conv_out_y1;
  wire signed [47:0] conv_out_y2;
  wire signed [47:0] conv_out_y3;

  //==================================================
  // DUT
  //==================================================
  corr dut (
    .clk_100M      (clk_100M),
    .rst_n         (rst_n),
    .sample_in     (sample_in),
    .sample_valid  (sample_valid),
    .channel_seg   (channel_seg),
    .out_valid_reg (out_valid_reg),
    .conv_out_y1   (conv_out_y1),
    .conv_out_y2   (conv_out_y2),
    .conv_out_y3   (conv_out_y3)
  );

  //==================================================
  // 发送一帧任务（1..2000）
  //==================================================
  task automatic send_frame(input reg ch);
    integer i;
    begin
      channel_seg  = ch;
      sample_valid = 1'b0;

      @(posedge clk_100M);

      for(i = 1; i <= AD_LEN; i = i + 1) begin
        // 数据切换 + valid打一拍
        sample_in    = i[15:0];
        sample_valid = 1'b1;
        @(posedge clk_100M);

        sample_valid = 1'b0;

        // 等待 N-1 拍
        repeat(SAMPLE_PERIOD_CYC-1) @(posedge clk_100M);
      end
    end
  endtask

  //==================================================
  // 期望值（64位）计算：A_i = i+1, B_i = i+1
  // y2 = Σ A[i]*B[i]
  // y3 = Σ A[i]*B[i+1], B[2000]=0
  // y1 = Σ A[i]*B[i-1], B[-1]=0
  //==================================================
  integer i;
  reg signed [63:0] exp_y1, exp_y2, exp_y3;
  reg signed [47:0] exp_y1_48, exp_y2_48, exp_y3_48;

  task automatic calc_expected;
    reg signed [63:0] a, b;
    begin
      exp_y1 = 0;
      exp_y2 = 0;
      exp_y3 = 0;

      for(i=0; i<AD_LEN; i=i+1) begin
        // A[i] = i+1
        a = i + 1;

        // y2: B[i] = i+1
        b = i + 1;
        exp_y2 = exp_y2 + a*b;

        // y3: B[i+1]，最后一项B[2000]=0
        if(i == AD_LEN-1) b = 0;
        else              b = (i + 2);
        exp_y3 = exp_y3 + a*b;

        // y1: B[i-1]，第一项B[-1]=0
        if(i == 0) b = 0;
        else       b = i;
        exp_y1 = exp_y1 + a*b;
      end

      exp_y1_48 = exp_y1[47:0];
      exp_y2_48 = exp_y2[47:0];
      exp_y3_48 = exp_y3[47:0];
    end
  endtask

  //==================================================
  // 主流程
  //==================================================
  initial begin
    sample_in    = 16'sd0;
    sample_valid = 1'b0;
    channel_seg  = 1'b0;

    @(posedge rst_n);
    repeat(50) @(posedge clk_100M);

    // 先算期望
    calc_expected;
    $display("Expected(64b): y1=%0d y2=%0d y3=%0d", exp_y1, exp_y2, exp_y3);
    $display("Expected(48b): y1=%0d y2=%0d y3=%0d", exp_y1_48, exp_y2_48, exp_y3_48);

    // Frame A：channel_seg=1
    $display("[%0t] Send Frame A (channel_seg=1)", $time);
    send_frame(1'b1);

    // 间隔
    $display("[%0t] Gap %0d cycles", $time, FRAME_GAP_CYC);
    repeat(FRAME_GAP_CYC) @(posedge clk_100M);

    // Frame B：channel_seg=0
    $display("[%0t] Send Frame B (channel_seg=0)", $time);
    send_frame(1'b0);

    // 等待结果
    $display("[%0t] Waiting out_valid_reg...", $time);
    wait(out_valid_reg === 1'b1);

    // 在 out_valid_reg 当拍或下一拍读都行，这里下一拍更稳
    @(posedge clk_100M);

    $display("[%0t] DUT OUT (48b signed): y1=%0d y2=%0d y3=%0d",
             $time, conv_out_y1, conv_out_y2, conv_out_y3);

    // 简单校验（只比48位）
    if(conv_out_y1 !== exp_y1_48) begin
      $display("ERROR y1 mismatch: got=%0d exp=%0d", conv_out_y1, exp_y1_48);
      $stop;
    end
    if(conv_out_y2 !== exp_y2_48) begin
      $display("ERROR y2 mismatch: got=%0d exp=%0d", conv_out_y2, exp_y2_48);
      $stop;
    end
    if(conv_out_y3 !== exp_y3_48) begin
      $display("ERROR y3 mismatch: got=%0d exp=%0d", conv_out_y3, exp_y3_48);
      $stop;
    end

    $display("PASS: corr outputs match expected (48-bit).");
    #1000;
    $finish;
  end

  //==================================================
  // 超时保护
  //==================================================
  initial begin
    #100_000_000; // 100ms
    $display("TIMEOUT");
    $finish;
  end

endmodule


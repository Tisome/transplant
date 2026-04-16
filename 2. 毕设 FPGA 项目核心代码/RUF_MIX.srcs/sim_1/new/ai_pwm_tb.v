`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 18:54:05
// Design Name: 
// Module Name: ai_pwm_tb
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


`timescale 1ns/1ps

module ai_pwm_tb;

  // -------------------------
  // clocks & reset
  // -------------------------
  reg clk_100M = 1'b0;
  reg clk_200M = 1'b0;
  reg rst_n    = 1'b0;

  // outputs
  wire ad_tog;
  wire pwm_p, pwm_n, pwm2_p, pwm2_n;
  wire channel_sel;

  // -------------------------
  // clock gen
  // 100MHz => 10ns period
  // 200MHz => 5ns period
  // -------------------------
  always #5  clk_100M = ~clk_100M;
  always #2.5 clk_200M = ~clk_200M;

  // -------------------------
  // DUT
  // 为了加快仿真，把 cycle 从 200000 缩小到 2000（即：周期缩小100倍）
  // 这样：2*cycle=4000 个 100MHz 周期 => 4000*10ns=40us 一次"4ms等效周期"
  // -------------------------
  pwm #(
    .cycle(2000)
  ) dut (
    .clk_100M    (clk_100M),
    .clk_200M    (clk_200M),
    .rst_n       (rst_n),
    .ad_tog      (ad_tog),
    .pwm_p       (pwm_p),
    .pwm_n       (pwm_n),
    .pwm2_p      (pwm2_p),
    .pwm2_n      (pwm2_n),
    .channel_sel (channel_sel)
  );

  // -------------------------
  // reset sequence
  // -------------------------
  initial begin
    rst_n = 1'b0;
    #100;          // 100ns 复位保持
    rst_n = 1'b1;
  end

  // -------------------------
  // monitor / checks
  // -------------------------
  integer ad_cnt = 0;
  time    last_ad_time = 0;

  // 观察通道翻转
  always @(posedge channel_sel or negedge channel_sel) begin
    $display("[%0t ns] channel_sel toggled -> %0b", $time, channel_sel);
  end

  // 仿真结束
  initial begin
    // 跑一段时间：比如 50us（在 cycle=200 的缩放下，足够看到多个"周期"和通道翻转）
    #50000;
    $display("Simulation done. ad_start count=%0d", ad_cnt);
    $finish;
  end

endmodule


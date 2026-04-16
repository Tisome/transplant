`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 20:50:30
// Design Name: 
// Module Name: ai_AD_tb
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

module ai_AD_tb;

  //============================
  // 参数缩放：加快仿真
  //============================
  localparam integer AD_LEN_TB = 2000;
  localparam integer CNT_TB    = 50;

  //============================
  // 时钟/复位
  //============================
  reg adc_clk = 1'b0;   // 65MHz
  reg al_clk  = 1'b0;   // 100MHz
  reg rst_n   = 1'b0;

  // 65MHz => period ~15.384615ns, half ~7.692307ns
  // 仿真里用小数延时是可以的（大多数仿真器支持）
  always #7.692 adc_clk = ~adc_clk;

  // 100MHz => period 10ns
  always #5 al_clk = ~al_clk;

  //============================
  // DUT IO
  //============================
  reg        ad_tog   = 1'b0;
reg [11:0] adc_data = 12'd0;

always @(posedge adc_clk or negedge rst_n) begin
  if(!rst_n)
    adc_data <= 12'd0;
  else
    adc_data <= adc_data + 1'd1;
end


  wire       adc_buf_en;
  wire [15:0] adc_buf_data;

  //============================
  // DUT 实例
  //============================
  AD #(
    .AD_LEN(AD_LEN_TB),
    .CNT(CNT_TB)
  ) dut (
    .adc_clk     (adc_clk),
    .al_clk      (al_clk),
    .rst_n       (rst_n),
    .ad_tog      (ad_tog),
    .adc_data    (adc_data),
    .adc_buf_en  (adc_buf_en),
    .adc_buf_data(adc_buf_data)
  );

  //============================
  // 复位序列
  //============================
  initial begin
    rst_n = 1'b0;
    #100;
    rst_n = 1'b1;
  end

  //============================
  // 产生一次采样触发：翻转 ad_tog
  //============================
  initial begin
    // 等复位释放稳定一会
    @(posedge rst_n);
    repeat(10) @(posedge adc_clk);

    $display("[%0t ns] Trigger capture: toggle ad_tog", $time);
    ad_tog <= ~ad_tog;
  end


endmodule


////============================================================
//// 如果你的工程仿真已经包含 AD_RAM 的IP仿真模型，请删除下面这个模型
//// 否则仿真器会提示找不到 AD_RAM 模块。
//// 这是一个简单的双口RAM行为模型：
//// - Port A: adc_clk 写
//// - Port B: al_clk 读（同步读，1拍延迟输出）
////============================================================
//module AD_RAM (
//  input  wire        clka,
//  input  wire        ena,
//  input  wire        wea,
//  input  wire [12:0] addra,
//  input  wire [15:0] dina,

//  input  wire        clkb,
//  input  wire        enb,
//  input  wire [12:0] addrb,
//  output reg  [15:0] doutb
//);
//  // 给够大一点的深度（TB里只用到前几十个）
//  reg [15:0] mem [0:8191];

//  // 写口
//  always @(posedge clka) begin
//    if (ena && wea) begin
//      mem[addra] <= dina;
//    end
//  end

//  // 读口：同步读，1拍延迟
//  reg [12:0] addrb_q;
//  always @(posedge clkb) begin
//    if (enb) begin
//      addrb_q <= addrb;
//      doutb   <= mem[addrb_q];
//    end
//  end
//endmodule

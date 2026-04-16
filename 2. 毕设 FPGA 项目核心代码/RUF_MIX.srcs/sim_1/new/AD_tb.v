`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/09 14:28:59
// Design Name: 
// Module Name: AD_tb
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


module AD_tb();
//输入
reg adc_clk;
reg al_clk;
reg rst_n;
reg ad_start;
reg [11:0] adc_data;
//输出
wire adc_buf_en;
wire [15:0] adc_buf_data;

initial begin
adc_clk = 1'b0;
al_clk = 1'b0;
rst_n = 1'b0;
ad_start = 1'b0;
adc_data = 12'd10;
#100 
rst_n = 1'b1;
#300
ad_start = 1'b1;
#15
ad_start = 1'b0;
#200000
ad_start = 1'b1;
#15
ad_start = 1'b0;
end

always #7.5 adc_clk = ~adc_clk;
always #100   al_clk = ~al_clk;



AD AD(
.adc_clk (adc_clk),         //65MHz
.al_clk  (al_clk),          //100MHz
.rst_n   (rst_n),      
.ad_start(ad_start),       //同步采集标志位
.adc_data(adc_data),
.adc_buf_en  (adc_buf_en),
.adc_buf_data(adc_buf_data)
);

endmodule

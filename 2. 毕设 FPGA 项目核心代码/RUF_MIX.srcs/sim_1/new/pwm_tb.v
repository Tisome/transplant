`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/05 22:01:03
// Design Name: 
// Module Name: pwm_tb
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


module pwm_tb();
// ‰»Î
reg clk;
reg rst_n;
reg start;
// ‰≥ˆ
wire pwm_p;
wire pwm_n;
wire pwm2_p;
wire pwm2_n;
wire channel_sel;
wire ad_start;

initial begin
clk = 1'b0;
rst_n = 1'b0;
start = 1'b0;
#100 
rst_n = 1'b1;
#100
start = 1'b1;
end

always #10 clk = ~clk;

 pwm pwm(
.clk_50M(clk),
.rst_n(rst_n),
.start(start),

.ad_start(ad_start),
.pwm_p(pwm_p),
.pwm_n(pwm_n),
.pwm2_p(pwm2_p),
.pwm2_n(pwm2_n),
.channel_sel(channel_sel)
    );
endmodule

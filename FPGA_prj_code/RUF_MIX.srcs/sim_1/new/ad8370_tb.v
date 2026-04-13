`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:58:15
// Design Name: 
// Module Name: ad8370_tb
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


module ad8370_tb( );
// ‰»Î
reg clk;
reg rst_n;
reg wr_en;
reg [7:0] wr_dat;
// ‰≥ˆ
wire wr_fin;
wire sclk;
wire ltch;
wire mosi;

initial begin
clk = 1'b1;
rst_n = 1'b0;
wr_en = 1'b0;
#100 
rst_n = 1'b1;
#200
wr_en = 1'b1;
wr_dat = 8'b11111010;
#20
wr_en = 1'b0;
wr_dat = 8'b11111010;
end

always #10 clk = ~clk;

SPI8370 AD8370(
.clk(clk),
.rst_n(rst_n),

.wr_en(wr_en),         
.wr_dat(wr_dat),  
.wr_fin(wr_fin),        

.sclk(sclk),
.ltch(ltch),         
.mosi(mosi)            
    );

endmodule
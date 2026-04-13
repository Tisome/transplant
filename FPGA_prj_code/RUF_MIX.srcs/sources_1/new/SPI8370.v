`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/05 22:53:34
// Design Name: 
// Module Name: SPI8370
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


module SPI8370 #(parameter DIV = 10)(
input wire  clk,
input wire  rst_n,

input wire  wr_en,          //写使能，外部给数据和使能
input wire  [7:0] wr_dat,   //外部数据用于增益控制
output reg  wr_fin,         //写完成标志位

output   sclk,           //SPI时钟
output   ltch,           //串行数据锁存引脚。当 LTCH 为低电平时，串行数据通过 DATA 引脚锁存到移位寄存器。移位寄存器中的数据在下一个上升沿锁存。
output   mosi            //串行数据
    );

reg [9:0] cnt;
reg [7:0] dat;
reg [2:0] dnt;
reg       req;             //请求，缓存wr_en
reg       sclk_reg; 
reg       ltch_reg;
   
wire      clr;     
wire      hlf;      
assign    clr = (cnt == DIV   -1'b1);               //DIV倍的分频，时钟下降沿标识
assign    hlf = (cnt == DIV/2 -1'b1);               //时钟上升沿标识
assign    mosi = ltch == 1'b0 ? dat[7-dnt] : 1'b0;  //拉低时数据输出，SPI时序
assign    sclk = sclk_reg;
assign    ltch = ltch_reg;


// 分频使得sclk的频率为sys_clk的1/DIV
// ----------------------------------------
always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sclk_reg <= 1'b0;
    end else if(hlf) begin
        sclk_reg <= 1'b1;       
    end else if(clr) begin
        sclk_reg <= 1'b0;
    end
end

always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 10'd0;
    end else if(clr) begin
        cnt <= 10'd0;       
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// ----------------------------------------

always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        req <= 1'b0;
        dat <= 8'd0;
    end else if(wr_fin) begin
        req <= 1'b0;    
        dat <= dat;   
    end else if(wr_en) begin
        req <= 1'b1;
        dat <= wr_dat;
    end
end

always@ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        dnt    <= 3'd0;
        ltch_reg   <= 1'd1;
        wr_fin <= 1'b0;
    end else if(req && clr && (!wr_fin)) begin    //逻辑时钟，用来触发时序
        if(&dnt) begin                            //相当于if（cnt==3'd7）
            dnt    <= 3'd0;
            ltch_reg   <= 1'd1;
            wr_fin <= 1'b1;   
        end else begin      
            ltch_reg   <= 1'd0;                         //核心逻辑就是拉低LTCH
            if(!ltch)
                dnt <= dnt + 1'b1;
        end      
    end else if(wr_fin) begin
        wr_fin <= 1'b0;
    end
end

endmodule

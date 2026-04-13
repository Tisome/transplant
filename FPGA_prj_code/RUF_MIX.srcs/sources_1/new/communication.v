`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:33:43
// Design Name: 
// Module Name: communication
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


module communication(
    input        clk,          // 系统时钟
    input        rst_n,        // 低电平复位
    input        start,        // 开始传输信号
    input      [15:0] tx_data,     // 要发送的数据
    output reg [15:0] rx_data, // 接收的数据
    output        spi_sclk,         // SPI 时钟
    output        spi_mosi,         // 主设备输出
    input         spi_miso,         // 从设备输出
    output        spi_cs_n,         // 片选信号
    output reg   done          // 传输完成标志
);

    reg [4:0] bit_cnt;      // 计数 0-15
    reg [15:0] tx_shift;    // 发送移位寄存器
    reg [15:0] rx_shift;    // 接收移位寄存器
    reg        busy;        // 忙标志
    reg        sclk_en;     // 控制时钟翻转


//---------------reg 型---------------//
reg   spi_sclk_reg;         // SPI 时钟
reg   spi_mosi_reg;         // 主设备输出
reg   spi_cs_n_reg;         // 
    // 状态机控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spi_cs_n_reg     <= 1'b1;
            spi_sclk_reg     <= 1'b0;
            spi_mosi_reg     <= 1'b0;
            bit_cnt  <= 5'd0;
            tx_shift <= 16'd0;
            rx_shift <= 16'd0;
            rx_data  <= 16'd0;
            busy     <= 1'b0;
            done     <= 1'b0;
            sclk_en  <= 1'b0;
        end else begin
            if (start && !busy) begin
                // 启动传输
                busy     <= 1'b1;
                spi_cs_n_reg     <= 1'b0;
                tx_shift <= tx_data;
                bit_cnt  <= 5'd15;
                sclk_en  <= 1'b1;
                done     <= 1'b0;
            end else if (busy) begin
                // 产生时钟并发送数据
                spi_sclk_reg <= ~spi_sclk_reg;
                if (spi_sclk_reg) begin
                    // 下降沿采样数据
                    rx_shift[bit_cnt] <= spi_miso;
                    if (bit_cnt == 0) begin
                        busy    <= 1'b0;
                        spi_cs_n_reg    <= 1'b1;
                        done    <= 1'b1;
                        rx_data <= rx_shift;
                        sclk_en <= 1'b0;
                        spi_sclk_reg    <= 1'b0;
                    end else begin
                        bit_cnt <= bit_cnt - 1'b1;
                    end
                end else begin
                    // 上升沿输出数据
                    spi_mosi_reg <= tx_shift[bit_cnt];
                end
            end
        end
    end

    // outputs
    assign spi_cs_n = spi_cs_n_reg;
    assign spi_sclk = spi_sclk_reg;
    assign spi_mosi = spi_mosi_reg;

endmodule

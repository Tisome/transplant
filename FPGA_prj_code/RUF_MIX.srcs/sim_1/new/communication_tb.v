`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:56:31
// Design Name: 
// Module Name: communication_tb
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


module communication_tb;
    // 仿真友好参数（比真实慢很多）
    localparam CLK_PERIOD = 10;    // 100 MHz 时钟仿真 (10 ns)
    localparam TIMER_COUNT_SIM = 200000; // 很短的周期用于仿真（真实用200000）
    localparam SCLK_DIV_SIM = 5;     // 将SCLK设为 clk/(2*2)=25 MHz for sim convenience

    reg clk;
    reg rst_n;
    reg data_valid_in;
    reg [62:0] data_in;

    wire spi_cs_n;
    wire spi_sclk;
    wire spi_mosi;
    wire spi_miso;

    // Instantiate DUT with sim parameters
    communication #(
        .CLK_FREQ_HZ(100_000_000),
        .TIMER_COUNT(TIMER_COUNT_SIM),
        .SCLK_DIV(SCLK_DIV_SIM)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid_in(data_valid_in),
        .data_in(data_in),
        .spi_cs_n(spi_cs_n),
        .spi_sclk(spi_sclk),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso)
    );

    // Clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Stimulus: 提供不同 data_in 和 data_valid
    initial begin
        // init
        rst_n = 0;
        data_valid_in = 0;
        data_in = 63'h0;
        # (CLK_PERIOD * 20);
        rst_n = 1;
        # (CLK_PERIOD * 10);

        // Set some data before the 1st transfer
        data_in = 63'h1234_5678_9ABC_DEF; // 63-bit example
        data_valid_in = 1;
        // hold valid for a few cycles
        # (CLK_PERIOD * 1);
        data_valid_in = 0;

        // Wait long enough看到几次传输
        # (CLK_PERIOD * 500000);

        // change data again
        data_in = 63'h0FED_CBA9_8765_432;
        data_valid_in = 1;
        # (CLK_PERIOD * 1);
        data_valid_in = 0;

        # (CLK_PERIOD * 5000);
        //$finish;
    end

    // waveform prints for debug


    // optionally print when CS toggles
    always @(posedge clk) begin
        if (!rst_n) ;
        else begin
            if (spi_cs_n == 0 && $time > 0) begin
                $display("[%0t] CS asserted, starting SPI transfer", $time);
            end
        end
    end

endmodule

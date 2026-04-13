`timescale 1ns / 1ps

module spi_comm_test_top #(
    parameter integer INTER_PULSE_GAP_CYCLES = 16,
    parameter integer DATA_PERIOD_CYCLES     = 400000
)(
    input  wire        sys_clk,
    input  wire        rst_n,
    input  wire        mcu_start,

    output wire        fpga_int,

    input  wire        spi_cs_n,
    input  wire        spi_sclk,
    output wire        spi_miso,

    output wire [1:0]  dbg_led
);

    wire [15:0]       max_idx;
    wire              max_valid;
    wire              channel_sel;
    wire              corr_valid;
    wire signed [47:0] conv_out_y1;
    wire signed [47:0] conv_out_y2;
    wire signed [47:0] conv_out_y3;
    wire [7:0]        packet_id_dbg;
    wire [3:0]        state_dbg;

    spi_comm_test_gen #(
        .INTER_PULSE_GAP_CYCLES (INTER_PULSE_GAP_CYCLES),
        .DATA_PERIOD_CYCLES     (DATA_PERIOD_CYCLES)
    ) u_gen (
        .clk           (sys_clk),
        .rst_n         (rst_n),
        .test_start    (mcu_start),
        .fpga_int      (fpga_int),
        .max_idx       (max_idx),
        .max_valid     (max_valid),
        .channel_sel   (channel_sel),
        .corr_valid    (corr_valid),
        .conv_out_y1   (conv_out_y1),
        .conv_out_y2   (conv_out_y2),
        .conv_out_y3   (conv_out_y3),
        .packet_id_dbg (packet_id_dbg),
        .state_dbg     (state_dbg)
    );

    comm_spi_slave_test #(
        .IDXW(16)
    ) u_comm_spi_slave (
        .clk_100M     (sys_clk),
        .rst_n        (rst_n),
        .max_idx      (max_idx),
        .max_valid    (max_valid),
        .channel_sel  (channel_sel),
        .corr_valid   (corr_valid),
        .conv_out_y1  (conv_out_y1),
        .conv_out_y2  (conv_out_y2),
        .conv_out_y3  (conv_out_y3),
        .fpga_int     (fpga_int),
        .spi_cs_n     (spi_cs_n),
        .spi_sclk     (spi_sclk),
        .spi_mosi     (1'b0),
        .spi_miso     (spi_miso)
    );

    assign dbg_led[0] = fpga_int;
    assign dbg_led[1] = packet_id_dbg[0];

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/02/07 17:34:26
// Design Name:
// Module Name: comm_spi_slave
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   MCU is SPI master, FPGA is SPI slave.
//   Communication flow matches the verified bring-up sequence:
//   1. MCU keeps start high while it is ready for the next packet.
//   2. FPGA stages one packet when the measurement pipeline produces a new result.
//   3. Only when `mcu_start=1` does FPGA assert `fpga_int`.
//   4. MCU sees the interrupt, drives start low, then reads the 22-byte packet.
//   5. When CS rises, FPGA clears `fpga_int` and waits for the next staged packet.
//
//////////////////////////////////////////////////////////////////////////////////

module comm_spi_slave #(
    parameter integer IDXW = 16
)(
    input  wire               clk_100M,
    input  wire               rst_n,

    // ========== From MCU ==========
    input  wire               mcu_start,

    // ========== From timeget ==========
    input  wire [IDXW-1:0]    max_idx,
    input  wire               max_valid,
    input  wire               channel_sel,

    // ========== From corr ==========
    input  wire               corr_valid,
    input  wire signed [47:0] conv_out_y1,
    input  wire signed [47:0] conv_out_y2,
    input  wire signed [47:0] conv_out_y3,

    // ========== FPGA -> MCU interrupt ==========
    output reg                fpga_int,

    // ========== SPI (MCU master, FPGA slave, Mode 0, MSB first) ==========
    input  wire               spi_cs_n,
    input  wire               spi_sclk,
    input  wire               spi_mosi,
    output wire               spi_miso
);

    localparam integer PKT_BYTES = 22;
    localparam integer PKT_BITS  = PKT_BYTES * 8;

    reg [IDXW-1:0] idx_a_reg;
    reg [IDXW-1:0] idx_b_reg;
    reg            idx_a_ready;
    reg            idx_b_ready;
    reg            max_valid_d;

    reg [PKT_BITS-1:0] packet_buf;
    reg                packet_pending;
    reg                packet_ready;

    reg [2:0] cs_sync;
    reg [2:0] sclk_sync;
    reg [2:0] mosi_sync;

    reg                spi_active;
    reg [PKT_BITS-1:0] shift_reg;
    reg [8:0]          bit_cnt;
    reg                spi_miso_r;

    wire spi_cs_n_s    = cs_sync[2];
    wire spi_cs_fall   = (cs_sync[2:1] == 2'b10);
    wire spi_cs_rise   = (cs_sync[2:1] == 2'b01);
    wire spi_sclk_fall = (sclk_sync[2:1] == 2'b10);

    wire unused_spi_mosi = mosi_sync[2];

    assign spi_miso = spi_miso_r;

    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n) begin
            idx_a_reg      <= {IDXW{1'b0}};
            idx_b_reg      <= {IDXW{1'b0}};
            idx_a_ready    <= 1'b0;
            idx_b_ready    <= 1'b0;
            max_valid_d    <= 1'b0;

            packet_buf     <= {PKT_BITS{1'b0}};
            packet_pending <= 1'b0;
            packet_ready   <= 1'b0;
            fpga_int       <= 1'b0;

            cs_sync        <= 3'b111;
            sclk_sync      <= 3'b000;
            mosi_sync      <= 3'b000;

            spi_active     <= 1'b0;
            shift_reg      <= {PKT_BITS{1'b0}};
            bit_cnt        <= 9'd0;
            spi_miso_r     <= 1'b0;
        end else begin
            cs_sync     <= {cs_sync[1:0], spi_cs_n};
            sclk_sync   <= {sclk_sync[1:0], spi_sclk};
            mosi_sync   <= {mosi_sync[1:0], spi_mosi};
            max_valid_d <= max_valid;

            if (max_valid && !max_valid_d) begin
                if (channel_sel) begin
                    idx_a_reg   <= max_idx;
                    idx_a_ready <= 1'b1;
                end else begin
                    idx_b_reg   <= max_idx;
                    idx_b_ready <= 1'b1;
                end
            end

            // A full measurement result is ready here. We stage it first, then
            // only expose it to MCU when mcu_start stays high.
            if (corr_valid && idx_a_ready && idx_b_ready && !packet_pending && !packet_ready) begin
                packet_buf <= {
                    idx_a_reg[15:8], idx_a_reg[7:0],
                    idx_b_reg[15:8], idx_b_reg[7:0],
                    conv_out_y1[47:40], conv_out_y1[39:32], conv_out_y1[31:24], conv_out_y1[23:16], conv_out_y1[15:8], conv_out_y1[7:0],
                    conv_out_y2[47:40], conv_out_y2[39:32], conv_out_y2[31:24], conv_out_y2[23:16], conv_out_y2[15:8], conv_out_y2[7:0],
                    conv_out_y3[47:40], conv_out_y3[39:32], conv_out_y3[31:24], conv_out_y3[23:16], conv_out_y3[15:8], conv_out_y3[7:0]
                };
                packet_pending <= 1'b1;
                idx_a_ready    <= 1'b0;
                idx_b_ready    <= 1'b0;
            end

            if (packet_pending && mcu_start && !packet_ready && !spi_active) begin
                packet_ready   <= 1'b1;
                packet_pending <= 1'b0;
                fpga_int       <= 1'b1;
            end

            if (spi_cs_fall) begin
                spi_active <= 1'b1;
                bit_cnt    <= 9'd0;

                if (packet_ready) begin
                    shift_reg  <= packet_buf;
                    spi_miso_r <= packet_buf[PKT_BITS-1];
                end else begin
                    shift_reg  <= {PKT_BITS{1'b0}};
                    spi_miso_r <= 1'b0;
                end
            end else if (spi_active && !spi_cs_n_s && spi_sclk_fall) begin
                if (bit_cnt < PKT_BITS-1) begin
                    shift_reg  <= {shift_reg[PKT_BITS-2:0], 1'b0};
                    bit_cnt    <= bit_cnt + 1'b1;
                    spi_miso_r <= shift_reg[PKT_BITS-2];
                end else begin
                    bit_cnt    <= bit_cnt + 1'b1;
                    spi_miso_r <= 1'b0;
                end
            end

            if (spi_cs_rise && spi_active) begin
                spi_active <= 1'b0;
                bit_cnt    <= 9'd0;
                spi_miso_r <= 1'b0;

                if (packet_ready) begin
                    packet_ready <= 1'b0;
                    fpga_int     <= 1'b0;
                end
            end
        end
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/07 23:51:04
// Design Name: 
// Module Name: ai_comm_tb
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



module ai_comm_tb;

  localparam integer IDXW      = 16;
  localparam integer PKT_BYTES = 22;
  localparam integer PKT_BITS  = PKT_BYTES * 8;

  //==================================================
  // clk_100M
  //==================================================
  reg clk_100M = 1'b0;
  always #5 clk_100M = ~clk_100M;  // 100MHz

  //==================================================
  // reset
  //==================================================
  reg rst_n = 1'b0;
  initial begin
    rst_n = 1'b0;
    repeat(30) @(posedge clk_100M);
    rst_n = 1'b1;
  end

  //==================================================
  // DUT inputs
  //==================================================
  reg  [IDXW-1:0]    max_idx;
  reg                max_valid;
  reg                channel_sel;

  reg                corr_valid;
  reg  signed [47:0] conv_out_y1;
  reg  signed [47:0] conv_out_y2;
  reg  signed [47:0] conv_out_y3;

  //==================================================
  // SPI (MCU master, mode0)
  //==================================================
  reg  spi_cs_n;
  reg  spi_sclk;
  reg  spi_mosi;
  wire spi_miso;

  wire fpga_int;

  //==================================================
  // DUT
  //==================================================
  comm_spi_slave #(
    .IDXW(IDXW)
  ) dut (
    .clk_100M     (clk_100M),
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
    .spi_mosi     (spi_mosi),
    .spi_miso     (spi_miso)
  );

  //==================================================
  // tasks
  //==================================================
  task automatic pulse_max(input [IDXW-1:0] idx, input ch);
    begin
      $display("[%0t] TB pulse_max: ch=%0d idx=0x%04h", $time, ch, idx);
      channel_sel = ch;
      max_idx     = idx;
      max_valid   = 1'b1;
      @(posedge clk_100M);
      max_valid   = 1'b0;
    end
  endtask

  task automatic pulse_corr(input signed [47:0] y1, input signed [47:0] y2, input signed [47:0] y3);
    begin
      $display("[%0t] TB pulse_corr: y1=%0d y2=%0d y3=%0d", $time, y1, y2, y3);
      conv_out_y1 = y1;
      conv_out_y2 = y2;
      conv_out_y3 = y3;
      corr_valid  = 1'b1;
      @(posedge clk_100M);
      corr_valid  = 1'b0;
    end
  endtask

  // SPI master read 22 bytes, mode0, MSB first
  task automatic spi_read_22bytes(output reg [8*PKT_BYTES-1:0] rx_flat);
    integer bit_i;
    reg bit_val;
    begin
      rx_flat = {8*PKT_BYTES{1'b0}};
      spi_sclk = 1'b0;

      spi_cs_n = 1'b0;
      #50; // 给从机装载首bit

      for (bit_i = 0; bit_i < PKT_BITS; bit_i = bit_i + 1) begin
        #50;
        spi_sclk = 1'b1;  // 上升沿采样
        #10;
        bit_val = spi_miso;
        rx_flat[8*PKT_BYTES-1 - bit_i] = bit_val;
        #40;
        spi_sclk = 1'b0;  // 下降沿让从机更新下一位
      end

      #100;
      spi_cs_n = 1'b1;
      #100;
    end
  endtask

  //==================================================
  // main
  //==================================================
  reg [8*PKT_BYTES-1:0] rx_pkt;

  reg [15:0]        exp_idxA, exp_idxB;
  reg signed [47:0] exp_y1, exp_y2, exp_y3;

  integer cyc;

  initial begin
    // init inputs
    max_idx      = 0;
    max_valid    = 0;
    channel_sel  = 0;

    corr_valid   = 0;
    conv_out_y1  = 0;
    conv_out_y2  = 0;
    conv_out_y3  = 0;

    spi_cs_n     = 1'b1;
    spi_sclk     = 1'b0;
    spi_mosi     = 1'b0;

    @(posedge rst_n);
    repeat(50) @(posedge clk_100M);

    // expected
    exp_idxA = 16'h0123;
    exp_idxB = 16'h0456;
    exp_y1   = 48'sd2666666000;
    exp_y2   = 48'sd2668667000;
    exp_y3   = 48'sd2666666000;

    //==================================================
    // 用"周期数"模拟你的大时序（更稳）
    // 100MHz -> 1clk = 10ns
    // 1ms  = 100000 clk
    // 4ms  = 400000 clk
    // 60us = 6000 clk
    //==================================================

    $display("[%0t] wait 1ms", $time);
    repeat(100000) @(posedge clk_100M);   // 1ms
    pulse_max(exp_idxA, 1'b1);

    $display("[%0t] wait 4ms", $time);
    repeat(400000) @(posedge clk_100M);   // 4ms -> total 5ms
    pulse_max(exp_idxB, 1'b0);

    $display("[%0t] wait 60us", $time);
    repeat(6000) @(posedge clk_100M);     // 60us -> total 5.06ms
    pulse_corr(exp_y1, exp_y2, exp_y3);

    // wait fpga_int
    $display("[%0t] waiting fpga_int...", $time);
    wait(fpga_int === 1'b1);
    $display("[%0t] fpga_int=1, start SPI read 22B", $time);

    // SPI read
    spi_read_22bytes(rx_pkt);

    //==================================================
    // parse/check
    //==================================================
    begin : CHECK
      reg [15:0]        idxA, idxB;
      reg signed [47:0] y1, y2, y3;

      idxA = { rx_pkt[8*PKT_BYTES-1  -: 8], rx_pkt[8*PKT_BYTES-9  -: 8] };
      idxB = { rx_pkt[8*PKT_BYTES-17 -: 8], rx_pkt[8*PKT_BYTES-25 -: 8] };

      y1 = { rx_pkt[8*PKT_BYTES-33 -: 8],
             rx_pkt[8*PKT_BYTES-41 -: 8],
             rx_pkt[8*PKT_BYTES-49 -: 8],
             rx_pkt[8*PKT_BYTES-57 -: 8],
             rx_pkt[8*PKT_BYTES-65 -: 8],
             rx_pkt[8*PKT_BYTES-73 -: 8] };

      y2 = { rx_pkt[8*PKT_BYTES-81  -: 8],
             rx_pkt[8*PKT_BYTES-89  -: 8],
             rx_pkt[8*PKT_BYTES-97  -: 8],
             rx_pkt[8*PKT_BYTES-105 -: 8],
             rx_pkt[8*PKT_BYTES-113 -: 8],
             rx_pkt[8*PKT_BYTES-121 -: 8] };

      y3 = { rx_pkt[8*PKT_BYTES-129 -: 8],
             rx_pkt[8*PKT_BYTES-137 -: 8],
             rx_pkt[8*PKT_BYTES-145 -: 8],
             rx_pkt[8*PKT_BYTES-153 -: 8],
             rx_pkt[8*PKT_BYTES-161 -: 8],
             rx_pkt[8*PKT_BYTES-169 -: 8] };

      $display("RX idxA=0x%04h idxB=0x%04h y1=%0d y2=%0d y3=%0d",
               idxA, idxB, y1, y2, y3);

      if (idxA !== exp_idxA) begin
        $display("ERROR: idxA mismatch got=0x%04h exp=0x%04h", idxA, exp_idxA);
        $stop;
      end
      if (idxB !== exp_idxB) begin
        $display("ERROR: idxB mismatch got=0x%04h exp=0x%04h", idxB, exp_idxB);
        $stop;
      end
      if (y1 !== exp_y1) begin
        $display("ERROR: y1 mismatch got=%0d exp=%0d", y1, exp_y1);
        $stop;
      end
      if (y2 !== exp_y2) begin
        $display("ERROR: y2 mismatch got=%0d exp=%0d", y2, exp_y2);
        $stop;
      end
      if (y3 !== exp_y3) begin
        $display("ERROR: y3 mismatch got=%0d exp=%0d", y3, exp_y3);
        $stop;
      end
    end

    // 检查 fpga_int 会被清掉
    repeat(500) @(posedge clk_100M);
    if (fpga_int !== 1'b0) begin
      $display("ERROR: fpga_int not cleared after SPI read");
      $stop;
    end

    $display("PASS: comm_spi_slave(22B) TB OK.");
    #1000;
    $finish;
  end

  //==================================================
  // timeout
  //==================================================
  initial begin
    // 10ms 足够：我们5.06ms就应该拉起 fpga_int
    #10_000_000;
    $display("TIMEOUT");
    $finish;
  end

endmodule

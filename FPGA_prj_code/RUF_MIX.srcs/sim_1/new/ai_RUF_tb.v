`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/08 00:32:57
// Design Name: 
// Module Name: ai_RUF_tb
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


module ai_RUF_tb;

  //==================================================
  // 时钟/复位
  //==================================================
  reg sys_clk = 1'b0;
  always #10 sys_clk = ~sys_clk;   // 50MHz -> 20ns

  reg rst_n = 1'b0;
  initial begin
    rst_n = 1'b0;
    repeat(50) @(posedge sys_clk);
    rst_n = 1'b1;
  end

  //==================================================
  // RUF 输入
  //==================================================
  reg [11:0] adc_data;
  reg        start;

  // SPI（MCU主机，FPGA从机，Mode0）
  reg  spi_cs_n;
  reg  spi_sclk;
  reg  spi_mosi;
  wire spi_miso;

  //==================================================
  // RUF 输出（有些不用也要接出来）
  //==================================================
  wire adc_clk;

  wire pwm_p, pwm_n, pwm2_p, pwm2_n;
  wire channel_sel;

  wire fpga_int;

  wire PGA_en;
  wire sclk;
  wire ltch;
  wire mosi;

  //==================================================
  // DUT: RUF
  //==================================================
  RUF dut (
    .sys_clk     (sys_clk),
    .rst_n       (rst_n),
    .adc_data    (adc_data),
    .adc_clk     (adc_clk),

    .start       (start),
    .pwm_p       (pwm_p),
    .pwm_n       (pwm_n),
    .pwm2_p      (pwm2_p),
    .pwm2_n      (pwm2_n),
    .channel_sel (channel_sel),

    .fpga_int    (fpga_int),
    .spi_cs_n    (spi_cs_n),
    .spi_sclk    (spi_sclk),
    .spi_mosi    (spi_mosi),
    .spi_miso    (spi_miso),

    .PGA_en      (PGA_en),
    .sclk        (sclk),
    .ltch        (ltch),
    .mosi        (mosi)
  );

  //==================================================
  // 常量输入要求
  // adc_data 恒为 1，start 恒为 0
  //==================================================
  initial begin
    adc_data = 12'd2050;
    start    = 1'b0;
  end

  //==================================================
  // SPI Master：读取 22 字节（Mode0, MSB first）
  // 与 comm_spi_slave 的时序匹配：
  // - 从机在 SCLK 下降沿更新MISO
  // - 主机在 SCLK 上升沿采样MISO
  //==================================================
  localparam integer PKT_BYTES = 22;
  localparam integer PKT_BITS  = PKT_BYTES * 8;

  task automatic spi_read_22bytes(output reg [8*PKT_BYTES-1:0] rx_flat);
    integer bit_i;
    reg bit_val;
    begin
      rx_flat = {8*PKT_BYTES{1'b0}};

      // Mode0: idle low
      spi_sclk = 1'b0;

      // CS 拉低开始事务
      spi_cs_n = 1'b0;

      // 给从机装载 shift_reg 的时间（CS下降沿装载并放出首bit）
      #100;

      // 读 176 bit
      for (bit_i = 0; bit_i < PKT_BITS; bit_i = bit_i + 1) begin
        // 上升沿：采样
        #100;
        spi_sclk = 1'b1;
        #20;
        bit_val = spi_miso;

        // MSB first：第一个采样到的bit放在最高位
        rx_flat[8*PKT_BYTES-1 - bit_i] = bit_val;

        // 下降沿：让从机更新下一位
        #80;
        spi_sclk = 1'b0;
      end

      // 结束
      #100;
      spi_cs_n = 1'b1;
      #200;
    end
  endtask

  //==================================================
  // 解析 22B：idxA/idxB/y1/y2/y3
  // byte0..1  idxA
  // byte2..3  idxB
  // byte4..9  y1
  // byte10..15 y2
  // byte16..21 y3
  //==================================================
  task automatic parse_and_print(input [8*PKT_BYTES-1:0] pkt);
    reg [15:0]        idxA, idxB;
    reg signed [47:0] y1, y2, y3;
    begin
      idxA = { pkt[8*PKT_BYTES-1  -: 8], pkt[8*PKT_BYTES-9  -: 8] };
      idxB = { pkt[8*PKT_BYTES-17 -: 8], pkt[8*PKT_BYTES-25 -: 8] };

      y1 = { pkt[8*PKT_BYTES-33 -: 8],
             pkt[8*PKT_BYTES-41 -: 8],
             pkt[8*PKT_BYTES-49 -: 8],
             pkt[8*PKT_BYTES-57 -: 8],
             pkt[8*PKT_BYTES-65 -: 8],
             pkt[8*PKT_BYTES-73 -: 8] };

      y2 = { pkt[8*PKT_BYTES-81  -: 8],
             pkt[8*PKT_BYTES-89  -: 8],
             pkt[8*PKT_BYTES-97  -: 8],
             pkt[8*PKT_BYTES-105 -: 8],
             pkt[8*PKT_BYTES-113 -: 8],
             pkt[8*PKT_BYTES-121 -: 8] };

      y3 = { pkt[8*PKT_BYTES-129 -: 8],
             pkt[8*PKT_BYTES-137 -: 8],
             pkt[8*PKT_BYTES-145 -: 8],
             pkt[8*PKT_BYTES-153 -: 8],
             pkt[8*PKT_BYTES-161 -: 8],
             pkt[8*PKT_BYTES-169 -: 8] };

      $display("[%0t] MCU RX: idxA=%0d(0x%04h) idxB=%0d(0x%04h) y1=%0d y2=%0d y3=%0d",
               $time, idxA, idxA, idxB, idxB, y1, y2, y3);
    end
  endtask

  //==================================================
  // 主流程：等 fpga_int -> 读包 -> 打印
  // 连续读两包（你可以改成更多）
  //==================================================
  reg [8*PKT_BYTES-1:0] rx_pkt;
  integer pkt_count;

  initial begin
    // SPI初值
    spi_cs_n = 1'b1;
    spi_sclk = 1'b0;
    spi_mosi = 1'b0;

    pkt_count = 0;

    @(posedge rst_n);
    $display("[%0t] rst released, start running...", $time);

    // 连续接收2包
    while (pkt_count < 2) begin
      $display("[%0t] waiting fpga_int...", $time);
      wait (fpga_int === 1'b1);

      $display("[%0t] fpga_int=1, do SPI read 22 bytes...", $time);
      spi_read_22bytes(rx_pkt);

      parse_and_print(rx_pkt);

      pkt_count = pkt_count + 1;

      // 等待 fpga_int 被清掉（代表FPGA认为"读完了"）
      wait (fpga_int === 1'b0);
      $display("[%0t] fpga_int cleared, ready for next packet", $time);
    end

    $display("PASS: RUF system TB received %0d packets.", pkt_count);
    #1000;
    $finish;
  end

  //==================================================
  // 超时保护：给足够长时间（比如 100ms）
  //==================================================
  initial begin
    #100_000_000; // 100ms
    $display("TIMEOUT: did not receive expected packets.");
    $finish;
  end

endmodule


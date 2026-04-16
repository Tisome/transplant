`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/07 16:18:41
// Design Name: 
// Module Name: RUF
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


module RUF(
input        sys_clk,    //系统时钟50MHz
input        rst_n,      //低电平复位
input [11:0] adc_data,   //adc并行数据
output       adc_clk,    //adc时钟65m

input        start,  // MCU ready/start handshake input
output       pwm_p,  //输出驱动+
output       pwm_n,  //输出驱动-
output       pwm2_p,  //输出驱动+
output       pwm2_n,  //输出驱动-
output       channel_sel,  //通道切换

// 和MCU的通信中，MCU是主机，FPGA是从机，mode0
output          fpga_int,       // 拉高通知MCU来读
input           spi_cs_n,    // 片选 (低有效)
input           spi_sclk,    // SPI 时钟 (CPOL=0, CPHA=0)
input           spi_mosi,     // MOSI
output          spi_miso,     // MISO
  
output       PGA_en,
output       sclk,      //SPI时钟
output       ltch,      //串行数据锁存引脚。当 LTCH 为低电平时，串行数据通过 DATA 引脚锁存到移位寄存器。移位寄存器中的数据在下一个上升沿锁存。
output       mosi       //串行数据
    );
wire    clk_200M;
wire    clk_100M;
wire    clk_65M;
wire    locked;

wire rst_n_100M = rst_n & locked;

clk_wiz_sys clk_wiz(
.clk_out1(clk_200M), //200mhz  用于发射驱动
.clk_out2(clk_100M), //100mhz  用于算法模块
.reset(!rst_n),
.locked(locked),
.clk_in1(sys_clk)
);

clk_wiz_2 clk_wiz_65M(
.clk_out1(clk_65M), //65mhz   用于AD驱动
.reset(!rst_n),
.locked(),
.clk_in1(sys_clk)
);

assign adc_clk = clk_65M; 


//-----------发射模块-----------//
wire ad_tog;

localparam cycle = 200000;

pwm #(
    .cycle(cycle)
)pwm_2m(
.clk_100M(clk_100M),
.clk_200M(clk_200M),
.rst_n(rst_n_100M),     //低电平复位
.start(1'b0),      //系统同步使能信号

.ad_tog(ad_tog),            //---AD同步采集标志位---//
.pwm_p(pwm_p),              //输出驱动+                                      
.pwm_n(pwm_n),              //输出驱动-                                    
.pwm2_p(pwm2_p),            //通道2输出驱动+                               
.pwm2_n(pwm2_n),            //通道2输出驱动-                                 
.channel_sel(channel_sel)   //通道切换位    
);

//-----------增益驱动-----------//
assign PGA_en = 1'b1;
wire wr_fin;
SPI8370 SPI(
.clk(sys_clk),
.rst_n(rst_n),

.wr_en(1'b1),           //写使能，外部给数据和使能
.wr_dat(8'd99),         //外部数据用于增益控制
.wr_fin(wr_fin),        //写完成标志位

.sclk(sclk),            //SPI时钟
.ltch(ltch),            //串行数据锁存引脚。当 LTCH 为低电平时，串行数据通过 DATA 引脚锁存到移位寄存器。移位寄存器中的数据在下一个上升沿锁存。
.mosi(mosi)             //串行数据
);


//-----------AD驱动-----------//
wire            adc_buf_en;
wire    [15:0]  adc_buf_data;
localparam AD_LEN   = 2000;     // 采样数据长度
localparam CNT      = 50;       // AD输出分频

AD #(
    .AD_LEN(AD_LEN),
    .CNT(CNT)
)AD9235(
.adc_clk(clk_65M),              //65MHz PLL生成的时钟有误差，若有问题请关注
.al_clk(clk_100M),              //AD的ram数据输出频率为5MHz 时钟为100MHz 
.rst_n(rst_n_100M),
.ad_tog(ad_tog),                //---由发射模块驱动 发射结束后开始AD采样---//
.adc_data(adc_data),            //12位的并行采样值
.adc_buf_en(adc_buf_en),        //数据输出有效位
.adc_buf_data(adc_buf_data)     //16位的数据输出 用于算法部分
);

//-----------并行卷积计算-----------//
    // 参数配置
    // --------------------------
    localparam DATAW    = 16;    //采样数据位宽
    localparam COEFFW   = 16;    //参考信号数据位宽
    localparam TAPS     = 150;   //参考信号长度
    localparam P        = 5;    //一个周期DSP运作数量
    localparam ACCW     = DATAW + COEFFW + 10;  //卷积结果的位宽
    localparam DATA_LEN = 2000;  //采样数据长度
    // --------------------------
wire                   busy;
wire                   out_valid;
wire signed [ACCW-1:0] conv_out;
wire        [15:0]     produced_cnt;
wire                   frame_end;

algorithm #(
    .DATAW(DATAW),          //参数例化
    .COEFFW(COEFFW),
    .TAPS(TAPS),
    .P(P),
    .ACCW(ACCW),
    .DATA_LEN(DATA_LEN)
) al(
    .clk(clk_100M),                 //100MHz 
    .rst_n(rst_n_100M),
    .sample_in(adc_buf_data),       //AD采样数据输入 根据输入总量DATA_LEN参数来控制这个模块的进程 可能存在鲁棒性问题
    .sample_valid(adc_buf_en),      //AD采样数据有效位
    .busy(busy),                    //处于卷积计算状态位
    .out_valid_reg(out_valid),      //输出有效位
    .conv_out(conv_out),            //输出卷积结果  
    .frame_end(frame_end),          //给timeget模块提供帧结束位，用于还原初始状态
    .produced_cnt_reg(produced_cnt) //输出当前已卷积个数
 );

//-----------timeget 模块-----------//
//-----------根据卷积结果获取时间-----------//  

wire  [ACCW-1:0] max_out;
(* keep = "true" *) wire  [15:0]     max_idx;
(* keep = "true" *) wire             max_valid;
    timeget #(
        .ACCW(ACCW)
    ) dut (
        .clk(clk_100M),               //100MHz用于最大值判断逻辑
        .rst_n(rst_n_100M),
        .data_in(conv_out),           //卷积结果输入
        .data_valid(out_valid),       //卷积结果有效位
        .data_count(produced_cnt),    //卷积结果索引值输入，通过该数据进行时间估计
       // .frame_start(frame_start),  //帧开始位，暂时没有合适的标志位，不影响程序进行
        .frame_end(frame_end),        //帧结果位，状态复位
       //.rst_max(rst_max),           //手动复位信号，暂时没有，不影响程序进行
        .max_out(max_out),            //最大值输出 
        .max_idx(max_idx),            //最大值对应的索引输出，通过该数据进行时间估计
        .max_valid(max_valid)         //索引输出有效位
    );

//-----------互相关模块-----------//
wire [47:0] conv_out_y1;
wire [47:0] conv_out_y2;
wire [47:0] conv_out_y3;
wire        out_valid_reg;

corr #(
    .DATAW(DATAW),
    .AD_LEN(AD_LEN)
)CORR_UNIT(
    .clk_100M(clk_100M),
    .rst_n(rst_n_100M),
    .sample_in(adc_buf_data),
    .sample_valid(adc_buf_en),
    .channel_seg(channel_sel),
    
    .out_valid_reg(out_valid_reg),
    .conv_out_y1(conv_out_y1),
    .conv_out_y2(conv_out_y2),
    .conv_out_y3(conv_out_y3)
);

//----------- MCU通信：SPI从机（22字节：idxA/idxB/y1/y2/y3） -----------//
localparam IDXW = 16;

comm_spi_slave #(
    .IDXW(IDXW)
) COMM_MCU_SPI (
    .clk_100M     (clk_100M),
    .rst_n        (rst_n_100M),

    // From MCU: start high means next packet is allowed
    .mcu_start    (start),

    // 来自 timeget：max_idx / max_valid（用 channel_sel 区分A/B）
    .max_idx      (max_idx),
    .max_valid    (max_valid),
    .channel_sel  (channel_sel),

    // 来自 corr：互相关输出 + out_valid_reg 作为触发
    .corr_valid   (out_valid_reg),
    .conv_out_y1  (conv_out_y1),
    .conv_out_y2  (conv_out_y2),
    .conv_out_y3  (conv_out_y3),

    // 中断线：通知MCU来读
    .fpga_int     (fpga_int),

    // SPI接口：MCU主机，FPGA从机，Mode0
    .spi_cs_n     (spi_cs_n),
    .spi_sclk     (spi_sclk),
    .spi_mosi     (spi_mosi),
    .spi_miso     (spi_miso)
);


endmodule

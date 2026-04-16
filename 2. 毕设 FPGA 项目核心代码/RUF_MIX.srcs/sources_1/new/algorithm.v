`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/05 23:20:01
// Design Name: 
// Module Name: algorithm
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


(*use_dsp = "yes"*)module algorithm #(
  parameter integer DATAW    = 16,  //采样数据位宽
  parameter integer COEFFW   = 16,  //参考数据位宽
  parameter integer TAPS     = 150, //参考数据长度
  parameter integer P        = 30,    // 同时运作的DSP数量
  parameter integer ACCW     = (DATAW + COEFFW + 10), // 累加值的位宽
  parameter integer DATA_LEN = 2000   //采样数据长度 对应100us*65MHz
)(
  input  wire                      clk, //算法模块时钟，100MHz或者200MHz
  input  wire                      rst_n,

  // input stream
  input  wire signed [DATAW-1:0]   sample_in,    //输入数据流 
  input  wire                      sample_valid, //数据有效信号

  // control / status
  output reg                       busy,         // 处于卷积计算状态
   (* MARK_DEBUG="true" *)output reg                       out_valid_reg,    // 输出数据有效位
   (* MARK_DEBUG="true" *)output reg signed [ACCW-1:0]     conv_out,     // 输出的计算结果
  output reg                       frame_end,    // 一帧结束标志位 
  output reg [15:0]                produced_cnt_reg  // 输出个数累计，用于debug
);

         reg [15:0] produced_cnt;  
  // -----------------------    -----------------------//
  // helper: clog2 function 用于参数计算，不额外消耗逻辑资源
  // -----------------------    -----------------------//
  function integer clog2;
    input integer value;
    integer i;
    begin
      clog2 = 0;
      for (i = value-1; i > 0; i = i >> 1) clog2 = clog2 + 1;
    end
  endfunction

  localparam integer ROUNDS = (TAPS + P - 1) / P; // 一次卷积需要几个周期
  localparam integer IDXW   = clog2(TAPS);        // 索引地址位宽
  localparam integer RNDW   = clog2(ROUNDS);      // 轮数计数器的位宽
  localparam integer NUM    = DATA_LEN - TAPS + 1;      // 轮数计数器的位宽
  // -----------------------
  // 滑动窗口 
  // window[0] = 最新采样值, window[TAPS-1] = 最早采样值
  // -----------------------
  reg signed [DATAW-1:0] window [0:TAPS-1];
  integer i;
  always @(posedge clk) begin
    if (!rst_n) begin
      for (i = 0; i < TAPS; i = i + 1) window[i] <= {DATAW{1'b0}};
    end else if(produced_cnt >= NUM) begin
      for (i = 0; i < TAPS; i = i + 1) window[i] <= {DATAW{1'b0}};
    end else if (sample_valid) begin
      // 移位寄存器
      for (i = TAPS-1; i > 0; i = i - 1) window[i] <= window[i-1];
      window[0] <= sample_in;
    end
  end

  // -----------------------
  // Coefficient ROM 
  // coeff[0] 对应 window[299]) 这与移位寄存器方向有关
  // -----------------------
  //参考信号输出
reg  [7:0]   addra_ref;
wire  [15:0]  coe_ref;
blk_mem_gen_2 rom_ref(
.clka(clk),
.ena(1'b1),
.addra(addra_ref),
.douta(coe_ref)
);
reg [31:0] idx_ref;
reg        ref_valid;
reg        ref_valid_buf;

 always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    addra_ref <= 8'd0;
  else if (addra_ref == 8'd149)
    addra_ref <= 8'd149;
  else if (ref_valid)
    addra_ref <= addra_ref + 1'b1;
    
 always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    ref_valid <= 1'b0;
  else if (addra_ref == 8'd149)
    ref_valid <= 1'b0; 
  else 
    ref_valid <= 1'b1;    
    
 always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    ref_valid_buf <= 1'b0;
  else 
    ref_valid_buf <= ref_valid; 

  always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    idx_ref <= 32'd0;
  else if (addra_ref == 8'd149)
    idx_ref <= 32'd149;
  else if (ref_valid_buf)
    idx_ref <= idx_ref + 1'b1;
  //-------$readmemh用于仿真，此处可替换为ROM输出
  reg signed [COEFFW-1:0] coeff [0:TAPS-1];
//      initial begin
//        // 从十六进制文件加载数据
//        $readmemh("lut_data.hex", coeff);
//    end
  
  always @(posedge clk or negedge rst_n) 
  if (!rst_n) begin
    for(i = 0; i <= 149; i = i + 1) begin  
        coeff[i] <= 16'd0;
    end
 end
  else if(ref_valid_buf)
    coeff[idx_ref] <= coe_ref;
//  //----------仿真测试用----------//
//  genvar b;
//  generate
//    for (b = 0; b < TAPS; b = b + 1) begin : init_coeff
//        always @(posedge clk) begin
//            coeff[b] = coe_ref;  // 每个系数全为 1
//        end
//    end
//  endgenerate

  // -----------------------
  // 控制 FSM（安排 ROUNDS 个周期来计算一个卷积输出）
  // 当 sample_valid 到达时，我们将开始计算窗口是否已被填满
  // busy 表示计算正在进行中；out_valid 在最终累积完成后一个周期置位（流水线）
  // -----------------------
  reg [RNDW-1:0] round_cnt;
  reg [15:0]     sample_received; // 计算接收到的样本数量以了解窗口何时已满 最后需要的也是这个索引
  reg            start_conv;      // 开始卷积标志位
  reg [ACCW-1:0] accum;           // 卷积累计量的输出
  reg            acc_clear;       // 卷积累计量的清零
  reg            out_valid;
// 状态和控制信号更新
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sample_received <= 0;
        round_cnt       <= 0;
        busy            <= 1'b0;
        out_valid       <= 1'b0;
        produced_cnt    <= 0;
    end else if(produced_cnt >= NUM) begin
        sample_received <= 0;
        round_cnt       <= 0;
        busy            <= 1'b0;
        out_valid       <= 1'b0;
        produced_cnt    <= 0;
    end else begin
        // 样本计数
        if (sample_valid && sample_received < DATA_LEN)
            sample_received <= sample_received + 1;

        // 卷积控制
        if (sample_valid && !busy && sample_received >= TAPS-1) begin
            busy       <= 1'b1;
            round_cnt  <= 0;
        end else if (busy) begin
            if (round_cnt < ROUNDS)
                round_cnt <= round_cnt + 1;
            if (round_cnt == ROUNDS-1) begin
                busy      <= 1'b0;
                out_valid <= 1'b1;
                produced_cnt <= produced_cnt + 1;
            end
        end else begin
            out_valid <= 1'b0;
        end
    end
end

  // -----------------------
  // 并行乘法 & 每周期部分和
  // 在每个周期繁忙时，计算 P 个乘法：索引 idx = round_cnt*P + k
  // 如果 idx >= TAPS，则将乘法视为零
  // 我们将这 P 个乘积相加到 cycle_partial 中，并添加到 accum 中
  // -----------------------
 (*use_dsp = "yes"*) wire signed [DATAW+COEFFW-1:0] mult_product [0:P-1];
(* mark_debug = "true" *) wire signed [DATAW-1:0]   mul_a [0:P-1];
(* mark_debug = "true" *) wire signed [COEFFW-1:0]  mul_b [0:P-1];
  genvar k;
  generate
    for (k = 0; k < P; k = k + 1) begin : MULTS
      // 地址索引
      wire [IDXW-1:0] idx;
      wire [31:0] idx_full;
      assign idx_full = round_cnt * P + k;     //round_cnt 是一次卷积内当前第几次分组卷积
      // 如果 idx_full >= TAPS，则必须避免越界；使用条件多路复用器，仅在越界时合成索引
      wire in_bounds = (idx_full < TAPS) ? 1'b1 : 1'b0; //防止除不尽的情况，余数部分

      // 创建被乘数和乘数
    // (* mark_debug = "true" *) wire signed [DATAW-1:0]   mul_a [0:P-1];
    // (* mark_debug = "true" *) wire signed [COEFFW-1:0]  mul_b [0:P-1];

      // 防止索引超出，因此TAPS与P成整数倍关系
      assign mul_a [k] = in_bounds ? window[TAPS-idx_full-1] : {DATAW{1'b0}};
      assign mul_b [k] = in_bounds ? coeff[idx_full]  : {COEFFW{1'b0}};
     // assign mul_b [k] = in_bounds ? 16'd2 : {COEFFW{1'b0}};
      // 乘法
      mult_gen_0 mul(
        .CLK(clk),
        .A(mul_a[k]),
        .B(mul_b[k]),
        .P(mult_product[k])
        );  
     // (*use_dsp = "yes"*) assign mult_product[k] = mul_a[k] * mul_b[k]; // 位宽 DATAW+COEFFW
    end
  endgenerate

  // 加法器树：将 mult_product[0..P-1] 相加，存入 cycle_partial
  // 实现简单的归约（组合） - Vivado 将实现查找表树；对于较大的 P，这很繁重。
  // 如果 P 较大（例如 > 64），请考虑构建分层流水线加法器树。
  reg signed [DATAW+COEFFW+clog2(P)-1:0] cycle_partial;
  integer a;
always @(*) begin
 //always @(posedge clk or negedge rst_n)
    cycle_partial = { (DATAW+COEFFW+clog2(P)){1'b0} };
    for (a = 0; a < P; a = a + 1) begin
      cycle_partial = cycle_partial + mult_product[a];
    end
  end

  // busy 时将 cycle_partial 累加到 accum 中（每轮一个周期）
  // 对齐宽度：将 cycle_partial 扩展到 ACCW
  wire signed [ACCW-1:0] cycle_ext;
  assign cycle_ext = {{(ACCW - (DATAW+COEFFW+clog2(P))){cycle_partial[DATAW+COEFFW+clog2(P)-1]}}, cycle_partial};


 //分组加法的时序对齐
 reg busy_reg;
 always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    busy_reg <= 1'b0;
  else
    busy_reg <= busy;
    
  //卷积值输出有效信号时序对齐
 always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    out_valid_reg <= 1'b0;
  else
    out_valid_reg <= out_valid;
    
  //卷积值对应索引输出时序对齐
 always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    produced_cnt_reg <= 16'b0;
  else
    produced_cnt_reg <= produced_cnt;  
  
  
  always @(posedge clk or negedge rst_n) 
    if (!rst_n) begin
      conv_out <= {ACCW{1'b0}};
    end else begin
      // 仅在 busy 状态有效时进行加法运算（处于计算周期中）
      // 注意：累加操作与计算 cycle_partial 的周期相同；round_cnt 在控制有限状态机 (FSM) 中递增
      if (busy_reg) begin
        conv_out <= conv_out + cycle_ext;
      end else
        conv_out <= {ACCW{1'b0}};
    end 

 // 输出帧结束位，用于后续的最大值检索复位
   always @(posedge clk or negedge rst_n) 
    if (!rst_n) 
        frame_end <= 1'b0;
    else if(produced_cnt_reg >= NUM) 
        frame_end <= 1'b1;
    else 
        frame_end <= 1'b0;    
           
endmodule

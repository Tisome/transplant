`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 09:34:31
// Design Name: 
// Module Name: DeltaT
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


module DeltaT #(
  parameter integer DATAW    = 16,  //采样数据位宽
  parameter integer DATA_LEN = 2048   //采样数据长度 对应100us*65MHz
)(
  input  wire                      clk,   //算法模块时钟，100MHz或者200MHz
  input  wire                      rst_n,

  // input stream
  input  wire signed [DATAW-1:0]   sample_in,    //输入数据流 
  input  wire                      sample_valid, //数据有效信号

  // control / status
  output reg                       multi_flag,         // 处于卷积计算状态
   (* MARK_DEBUG="true" *)output  reg              out_valid_reg,    // 输出数据有效位
   (* MARK_DEBUG="true" *)output  signed [49:0]     conv_out_y1,     // 输出计算结果y1
   (* MARK_DEBUG="true" *)output  signed [49:0]     conv_out_y2,     // 输出计算结果y2
   (* MARK_DEBUG="true" *)output  signed [49:0]     conv_out_y3      // 输出计算结果y3
);

  function integer clog2;
    input integer value;
    integer i;
    begin
      clog2 = 0;
      for (i = value-1; i > 0; i = i >> 1) clog2 = clog2 + 1;
    end
  endfunction
localparam integer RAMW   = clog2(DATA_LEN);      // 轮数计数器的位宽

reg [RAMW:0] addra;
reg [RAMW-1:0] addrb;
wire [15:0] dout;
reg [15:0] dout_buf;
reg        full;         //一帧数据存储结束标志
//reg        multi_flag;   //乘法器运行标志
reg        trans_flag;   //ram读取时的上下区切换标志
always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    addra <= 0;
//  else if (addra == 2*DATA_LEN-1 && sample_valid)
//    addra <= 0;
  else if (sample_valid)
    addra <= addra + 1'd1;

always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    full <= 1'd0;
  else if (addra == 2*DATA_LEN-1 && sample_valid)
    full <= 1'd1;
  else 
    full <= 1'd0;

always @(posedge clk or negedge rst_n) 
  if (!rst_n) 
    multi_flag <= 1'd0;
  else if ({trans_flag,addrb} == 2*DATA_LEN-1)             //计算结束
    multi_flag <= 1'd0;  
  else if (full == 1'd1)
    multi_flag <= 1'd1;
  else 
    multi_flag <= multi_flag;

always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    trans_flag <= 1'd0;
  else if (multi_flag)
    trans_flag <= trans_flag + 1'd1;
  else 
    trans_flag <= 1'd0;

always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    addrb <= 0;
  else if ({trans_flag,addrb} == 2*DATA_LEN-1)
    addrb <= 0;
  else if (trans_flag)
    addrb <= addrb + 1'd1;

always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    dout_buf <= 16'd0;
  else 
    dout_buf <= dout;

reg [15:0] data_A;
reg [15:0] data_B;
reg  [15:0] data_A_buf;
reg  [15:0] data_A_buf2;
reg  [15:0] data_A_buf3;
reg  [15:0] data_B_buf;
wire  signed [31:0] y1;
wire  signed [31:0] y2;
wire  signed [31:0] y3;

always @(posedge clk or negedge rst_n) 
  if (!rst_n) begin
    data_A <= 16'd0;
    data_B <= 16'd0;
  end
  else if(trans_flag) begin
    data_A <= dout;
    data_B <= data_B;
  end
  else if(!trans_flag) begin
    data_A <= data_A;
    data_B <= dout;
  end

always @(posedge clk or negedge rst_n) 
  if (!rst_n) begin
    data_A_buf <= 16'd0;
    data_B_buf <= 16'd0;
  end
  else begin
    data_A_buf <= data_A;
    data_B_buf <= data_B;
  end
 
always @(posedge clk or negedge rst_n) 
  if (!rst_n) begin
    data_A_buf2 <= 16'd0;
    data_A_buf3 <= 16'd0;
  end
  else begin
    data_A_buf2 <= data_A_buf;
    data_A_buf3 <= data_A_buf2;
  end
    
blk_mem_gen_3 multi_ram_1 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(sample_valid),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [11 : 0] addra
  .dina(sample_in),    // input wire [15 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(multi_flag),      // input wire enb
  .addrb({trans_flag,addrb}),  // input wire [11 : 0] addrb
  .doutb(dout)  // output wire [15 : 0] doutb
);

mult_gen_1 multi_y1 (
  .CLK(clk),  // input wire CLK
  .A(data_A),      // input wire [15 : 0] A
  .B(data_B_buf),      // input wire [15 : 0] B
  .P(y1)      // output wire [31 : 0] P
);

mult_gen_1 multi_y2 (
  .CLK(clk),  // input wire CLK
  .A(data_A_buf),      // input wire [15 : 0] A
  .B(data_B),      // input wire [15 : 0] B
  .P(y2)      // output wire [31 : 0] P
);

mult_gen_1 multi_y3 (
  .CLK(clk),  // input wire CLK
  .A(data_A_buf3),      // input wire [15 : 0] A
  .B(data_B),      // input wire [15 : 0] B
  .P(y3)      // output wire [31 : 0] P
); 
  
reg multi_valid;
reg multi_valid_buf1;
reg multi_valid_buf2;
reg multi_valid_buf3;
wire y1_valid;
wire y2_valid;    
wire y3_valid;  
  
always @(posedge clk or negedge rst_n) 
  if (!rst_n) begin
    multi_valid       <= 1'd0;
    multi_valid_buf1  <= 1'd0;
    multi_valid_buf2  <= 1'd0;
    multi_valid_buf3  <= 1'd0;
  end
  else begin
    multi_valid       <= trans_flag;
    multi_valid_buf1  <= multi_valid;
    multi_valid_buf2  <= multi_valid_buf1;
    multi_valid_buf3  <= multi_valid_buf2;
  end    

assign  y1_valid = multi_valid_buf2;
assign  y2_valid = multi_valid_buf2;
assign  y3_valid = multi_valid_buf2;

reg signed [49:0] y1_sum;
reg signed [49:0] y2_sum;
reg signed [49:0] y3_sum;

always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    y1_sum  <= 50'd0;
  else if (full)
    y1_sum  <= 50'd0;
  else if (y1_valid)
    y1_sum  <= y1_sum + y1;    

always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    y2_sum  <= 50'd0;
  else if (full)
    y2_sum  <= 50'd0;
  else if (y2_valid)
    y2_sum  <= y2_sum + y2;    
    
always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    y3_sum  <= 50'd0;
  else if (full)
    y3_sum  <= 50'd0;
  else if (y3_valid)
    y3_sum  <= y3_sum + y3;        
    
assign conv_out_y1 = y1_sum;
assign conv_out_y2 = y2_sum;
assign conv_out_y3 = y3_sum;
    
reg [15:0] sum_cnt;
reg        out_valid;
always @(posedge clk or negedge rst_n) 
  if (!rst_n)
    sum_cnt  <= 16'd0;
  else if (full)
    sum_cnt  <= 16'd0;   
  else if (y2_valid)     
    sum_cnt  <= sum_cnt + 1'd1;
         
 always @(posedge clk or negedge rst_n) 
  if (!rst_n) begin
    out_valid      <= 16'd0;
    out_valid_reg  <= 16'd0;
  end
  else if (sum_cnt == DATA_LEN -1) begin
    out_valid      <= 16'd1;
    out_valid_reg  <= out_valid;
  end
  else begin
    out_valid      <= 16'd0;
    out_valid_reg  <= out_valid;
  end
 
 delta_ila delta_ila (
	.clk(clk), // input wire clk
	.probe0(out_valid_reg), // input wire [0:0]  probe0  
	.probe1(conv_out_y1), // input wire [49:0]  probe1 
	.probe2(conv_out_y2), // input wire [49:0]  probe2 
	.probe3(conv_out_y3), // input wire [49:0]  probe3
	.probe4(addra), // input wire [49:0]  probe1 
	.probe5(sample_in), // input wire [49:0]  probe2 
    .probe6(sample_valid), // input wire [49:0]  probe3
	.probe7(full), // input wire [49:0]  probe1 
	.probe8(multi_flag), // input wire [49:0]  probe2 
	.probe9(sum_cnt) // input wire [49:0]  probe3
);
endmodule


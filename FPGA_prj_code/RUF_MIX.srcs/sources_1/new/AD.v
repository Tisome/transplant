`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/05 22:19:40
// Design Name: 
// Module Name: AD
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


//module AD#(
//  parameter integer AD_LEN = 2000,
//  parameter integer CNT    = 50 
//)(
//         input                       adc_clk,         //65MHz
//         input                       al_clk,          //100MHz
//         input                       rst_n,      
//         input                       ad_tog,       //同步采集标志位
//        // output                      ram_full,       //同步卷积开始标志
//         (* MARK_DEBUG="true" *)input      [11:0]           adc_data,
//         (* MARK_DEBUG="true" *)output                      adc_buf_en,
//         (* MARK_DEBUG="true" *)output     [15:0]           adc_buf_data
         
//       );


//// -----------   tog -> start_pluse  ------------
//reg ad_tog_sync1, ad_tog_sync2;

//always @(posedge adc_clk or negedge rst_n) begin
//    if(!rst_n) begin
//        ad_tog_sync1 <= 1'b0;
//        ad_tog_sync2 <= 1'b0;
//    end else begin
//        ad_tog_sync1 <= ad_tog;
//        ad_tog_sync2 <= ad_tog_sync1;
//    end
//end

//wire ad_start_pulse = ad_tog_sync1 ^ ad_tog_sync2; // 翻转检测 => 1拍脉冲

//// -----------   tog -> start_pluse  ------------


////------同步采集标志位跨时钟域的上升沿触发------//
//reg [12:0] addra;
//reg ad_en;


//always@(posedge adc_clk or negedge rst_n)
//if(!rst_n)
//    ad_en <= 1'd0;
//else if(ad_start_pulse == 1'b1)
//    ad_en <= 1'd1;
//else if(addra == AD_LEN-1)  
//    ad_en <= 1'd0;   
//else
//    ad_en <= ad_en;  

////------AD驱动------// 
//// 外部输入的adc_data为偏移二进制码，其范围为0-4095
//// 0 代表负最大电压，2048 代表中间零点，4095 代表正最大电压。
//// 要进行数学运算，只需要将其最高位翻转
//// 从这里的代码来看,adc_data_d0表示adc_data转为12位补码的二进制数值
//// adc_data_wide表示adc_data_d0扩展高位4位数值至16位补码的二进制数值
//// 因为倒了两次，所以相比于输入的真实数据，其实是打了两拍的

//reg [11:0] adc_data_d0;
//always@(posedge adc_clk or negedge rst_n)
//begin
//	if(!rst_n)
//		adc_data_d0 <= 12'd0;
//	else
//		adc_data_d0 <= {~adc_data[11],adc_data[10:0]};
//end

//reg [15:0] adc_data_wide;
//always@(posedge adc_clk or negedge rst_n)
//  begin
//    if(!rst_n)
//      adc_data_wide <= 16'd0;
//    else
//      adc_data_wide <= {{4{adc_data_d0[11]}}, adc_data_d0[11:0]};
//  end

////assign adc_buf_data = adc_data_wide;

////------RAM存储的输入------//   
//always@(posedge adc_clk or negedge rst_n)
//if(!rst_n)
//	addra <= 13'd0;
//else if(addra == AD_LEN-1)	
//    addra <= 13'd0;
//else if(ad_en)
//	addra <= addra + 1'd1;
//else
//    addra <= addra;
    
    
    

////------RAM存储的输出------//  
//reg [12:0] addrb;
//reg enb;
//reg trans_flag;   //用来标志输出过程
//reg [7:0] clk_cnt;

//always@(posedge al_clk or negedge rst_n)
//if(!rst_n)
//	clk_cnt <= 8'd0;
//else if(clk_cnt == CNT-1)	
//    clk_cnt <= 8'd0;
//else if(trans_flag)
//	clk_cnt <= clk_cnt + 1'd1;
//else
//    clk_cnt <= 8'd0;
    
//always@(posedge al_clk or negedge rst_n)
//if(!rst_n)
//	trans_flag <= 1'd0;
//else if(addra == AD_LEN-1)	
//    trans_flag <= 1'd1;
//else if(addrb == AD_LEN-1 && clk_cnt == CNT-1)	   // 
//	trans_flag <= 1'd0;
//else 
//    trans_flag <= trans_flag;	
	
	
//always@(posedge al_clk or negedge rst_n)
//if(!rst_n)
//	enb <= 1'd0;
//else if(clk_cnt == CNT-1)	
//    enb <= 1'd1;
//else 
//	enb <= 1'd0;

//always@(posedge al_clk or negedge rst_n) begin
//if(!rst_n)
//	addrb <= 13'd0;
//else if(addrb == AD_LEN)	//此处的条件需要时addra满地址+1
//    addrb <= 13'd0;
//else if(enb)
//	addrb <= addrb + 1'd1;
//else
//    addrb <= addrb;
//end



//AD_RAM AD_RAM(
//.clka   (adc_clk),
//.ena    (1'b1),
//.wea    (ad_en),
//.addra  (addra),
//.dina   (adc_data_wide),//(adc_data_wide)实际用,(data_test)测试用
//.clkb   (al_clk),         //100MHz 数据输出用于算法
//.enb    (enb),            //
//.addrb (addrb),
//.doutb (adc_buf_data)
//);

//reg adc_buf_en_reg;
//always@(posedge al_clk or negedge rst_n)
//if(!rst_n)
//    adc_buf_en_reg <= 1'b0;
//else 
//    adc_buf_en_reg <= enb;
    
//assign adc_buf_en = adc_buf_en_reg;

//endmodule

module AD#(
  parameter integer AD_LEN = 2000,
  parameter integer CNT    = 50
)(
  input                    adc_clk,   // 65MHz
  input                    al_clk,    // 100MHz
  input                    rst_n,
  input                    ad_tog,    // 来自PWM的toggle事件
  (* MARK_DEBUG="true" *)  input  [11:0] adc_data,
  (* MARK_DEBUG="true" *)  output        adc_buf_en,
  (* MARK_DEBUG="true" *)  output [15:0] adc_buf_data
);

  //========================================================
  // 1) ad_tog -> ad_start_pulse (adc_clk域)
  //========================================================
  reg ad_tog_sync1, ad_tog_sync2;
  always @(posedge adc_clk or negedge rst_n) begin
    if(!rst_n) begin
      ad_tog_sync1 <= 1'b0;
      ad_tog_sync2 <= 1'b0;
    end else begin
      ad_tog_sync1 <= ad_tog;
      ad_tog_sync2 <= ad_tog_sync1;
    end
  end
  wire ad_start_pulse = ad_tog_sync1 ^ ad_tog_sync2; // 65MHz域1拍启动脉冲


  //========================================================
  // 2) 写RAM：adc_clk域，写满 AD_LEN 点
  //========================================================
  reg        ad_en;
  reg [12:0] addra;

  always @(posedge adc_clk or negedge rst_n) begin
    if(!rst_n)
      ad_en <= 1'b0;
    else if(ad_start_pulse)
      ad_en <= 1'b1;
    else if(ad_en && addra == AD_LEN-1)
      ad_en <= 1'b0;
  end

  // 写地址：启动时清零，写满清零
  always @(posedge adc_clk or negedge rst_n) begin
    if(!rst_n)
      addra <= 13'd0;
    else if(ad_start_pulse)
      addra <= 13'd0;
    else if(ad_en) begin
      if(addra == AD_LEN-1)
        addra <= 13'd0;
      else
        addra <= addra + 1'd1;
    end
  end

  // ADC offset-binary -> 12bit signed -> 16bit signed
  reg [11:0] adc_data_d0;
  always @(posedge adc_clk or negedge rst_n) begin
    if(!rst_n)
      adc_data_d0 <= 12'd0;
    else
      adc_data_d0 <= {~adc_data[11], adc_data[10:0]};
  end

  reg [15:0] adc_data_wide;
  always @(posedge adc_clk or negedge rst_n) begin
    if(!rst_n)
      adc_data_wide <= 16'd0;
    else
      adc_data_wide <= {{4{adc_data_d0[11]}}, adc_data_d0[11:0]};
  end


  //========================================================
  // 3) 关键修复：写满事件跨域（adc_clk -> al_clk）
  //    用 toggle 表示"本帧写满"
  //========================================================
  reg frame_done_tog;
  always @(posedge adc_clk or negedge rst_n) begin
    if(!rst_n)
      frame_done_tog <= 1'b0;
    else if(ad_en && addra == AD_LEN-1)
      frame_done_tog <= ~frame_done_tog;
  end

  // al_clk域同步 + 翻转检测得到 start_read（1拍）
  reg fd_sync1, fd_sync2;
  always @(posedge al_clk or negedge rst_n) begin
    if(!rst_n) begin
      fd_sync1 <= 1'b0;
      fd_sync2 <= 1'b0;
    end else begin
      fd_sync1 <= frame_done_tog;
      fd_sync2 <= fd_sync1;
    end
  end
  wire start_read = fd_sync1 ^ fd_sync2; // 100MHz域1拍：开始读出本帧


  //========================================================
  // 4) 读RAM：al_clk域，按 CNT 分频输出 AD_LEN 点
  //========================================================
  reg [7:0]  clk_cnt;
  reg        enb;
  reg        trans_flag;
  reg [12:0] addrb;

  // trans_flag：收到 start_read 开始；读完最后一点后停止
  always @(posedge al_clk or negedge rst_n) begin
    if(!rst_n)
      trans_flag <= 1'b0;
    else if(start_read)
      trans_flag <= 1'b1;
    else if(trans_flag && (addrb == AD_LEN-1) && (clk_cnt == CNT-1))
      trans_flag <= 1'b0;
  end

  // clk_cnt：仅在 trans_flag 期间计数，用于产生 enb
  always @(posedge al_clk or negedge rst_n) begin
    if(!rst_n)
      clk_cnt <= 8'd0;
    else if(start_read)
      clk_cnt <= 8'd0;
    else if(trans_flag) begin
      if(clk_cnt == CNT-1)
        clk_cnt <= 8'd0;
      else
        clk_cnt <= clk_cnt + 1'd1;
    end else
      clk_cnt <= 8'd0;
  end

  // enb：每 CNT 拍给1拍（只在 trans_flag 期间有效）
  always @(posedge al_clk or negedge rst_n) begin
    if(!rst_n)
      enb <= 1'b0;
    else
      enb <= (trans_flag && (clk_cnt == CNT-1));
  end

  // 读地址：start_read 清零；每次 enb 递增；到末尾保持（由trans_flag停掉）
  always @(posedge al_clk or negedge rst_n) begin
    if(!rst_n)
      addrb <= 13'd0;
    else if(start_read)
      addrb <= 13'd0;
    else if(enb) begin
      if(addrb == AD_LEN-1)
        addrb <= addrb;         // 保持在末尾
      else
        addrb <= addrb + 1'd1;
    end
  end


  //========================================================
  // 5) 双口RAM：adc_clk写、al_clk读
  //========================================================
  AD_RAM AD_RAM (
    .clka  (adc_clk),
    .ena   (1'b1),
    .wea   (ad_en),
    .addra (addra),
    .dina  (adc_data_wide),

    .clkb  (al_clk),
    .enb   (enb),
    .addrb (addrb),
    .doutb (adc_buf_data)
  );

  // 同步读一般有1拍延迟：valid 延迟1拍对齐 doutb
  reg adc_buf_en_reg;
  always @(posedge al_clk or negedge rst_n) begin
    if(!rst_n)
      adc_buf_en_reg <= 1'b0;
    else
      adc_buf_en_reg <= enb;
  end
  assign adc_buf_en = adc_buf_en_reg;

endmodule



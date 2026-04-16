`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/05 21:30:10
// Design Name: 
// Module Name: pwm
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


//module pwm(
//input clk_50M, //系统时钟50MHz
//input clk_100M,
//input clk_200M,
//input rst_n,   //低电平复位
//input start,   //发射启动 测试用


//output ad_start, //AD开始采样标志位 同步作用
//output pwm_p,   //输出驱动+
//output pwm_n,   //输出驱动-
//output pwm2_p,  //通道2输出驱动+
//output pwm2_n,  //通道2输出驱动-
//output channel_sel   //通道切换
//    );
    

////---------------------------------//   
////---4ms间隔---//
//reg [19:0] cnt_4ms;
//always@(posedge clk_100M or negedge rst_n)
//if(!rst_n)
//    cnt_4ms <= 20'd0;
//else if(cnt_4ms == 20'd400000)   
//    cnt_4ms <= 20'd0;
//else 
//    cnt_4ms <= cnt_4ms + 1'b1;
    
////---在4ms周期内，到达2ms时触发一次通道转换---//
//reg channel_sel_reg;
//always@(posedge clk_100M or negedge rst_n)
//if(!rst_n)
//    channel_sel_reg <= 1'd1;
//else if(cnt_4ms == 20'd200000)   
//    channel_sel_reg <= ~channel_sel_reg;
//else 
//    channel_sel_reg <= channel_sel_reg;

////---由触发信号转变为有效信号---//
//reg pwm_en;
//reg [8:0] addra;

//always@(posedge clk_200M or negedge rst_n)
//if(!rst_n)
//    pwm_en <= 1'b0;
//else if(addra == 9'd499)   
//    pwm_en <= 1'b0;
//else if(cnt_4ms == 20'd1)
//    pwm_en <= 1'b1;    
//else 
//    pwm_en <= pwm_en;

     
////ram 读取
//reg fre1_p;
//reg fre1_n;
//reg fre2_p;
//reg fre2_n;
//wire dout_1;
//wire dout_2;
////----------addra----------//
//always@(posedge clk_200M or negedge rst_n)
//if(!rst_n)begin
//    addra <= 9'd0;
//    end
//else if(addra == 9'd499) begin
//    addra <= 9'd0;
//    end
//else if(pwm_en) begin
//    addra <= addra + 1'b1;
//    end
////----------channel1----------//
//always@(posedge clk_200M or negedge rst_n)
//if(!rst_n)begin
//    fre1_p <=1'b0;
//    fre1_n <=1'b0;
//    end
//else if(addra == 9'd499) begin
//    fre1_p <=1'b0;
//    fre1_n <=1'b0;
//    end
//else if(pwm_en &  channel_sel_reg) begin
//    fre1_p <= dout_1;
//    fre1_n <= dout_2;
//    end
////----------channel2----------//
//always@(posedge clk_200M or negedge rst_n)
//if(!rst_n)begin
//    fre2_p <=1'b0;
//    fre2_n <=1'b0;
//    end
//else if(addra == 9'd499) begin
//    fre2_p <=1'b0;
//    fre2_n <=1'b0;
//    end
//else if(pwm_en & ~channel_sel_reg) begin
//    fre2_p <= dout_1;
//    fre2_n <= dout_2;
//    end

//blk_mem_gen_0 mem_pwm_1 (
//.clka   (clk_200M),
//.addra  (addra),
//.douta  (dout_1)
//);

//blk_mem_gen_1 mem_pwm_2 (
//.clka   (clk_200M),
//.addra  (addra),
//.douta  (dout_2)
//);

////----------同步采样标志位----------//
//reg ad_start_reg;
//reg ad_start_reg2;
//reg ad_start_reg3;

//always@(posedge clk_200M or negedge rst_n)
//if(!rst_n)begin
//    ad_start_reg <=1'b0;
//end
//else if(addra == 9'd499) begin
//    ad_start_reg <= 1'b1;
//end    
//else begin
//    ad_start_reg <=1'b0;
//end     

//always@(posedge clk_200M or negedge rst_n)
//if(!rst_n)begin
//    ad_start_reg2 <=1'b0;
//    ad_start_reg3 <=1'b0;
//end
//else begin
//    ad_start_reg2 <= ad_start_reg;
//    ad_start_reg3 <= ad_start_reg2;
//end
////----------输出----------//
//assign ad_start = ad_start_reg|ad_start_reg2|ad_start_reg3; //跨时钟域，脉冲信号扩宽到15ns
//assign pwm_p = fre1_p;
//assign pwm_n = fre1_n;
//assign pwm2_p = fre2_p;
//assign pwm2_n = fre2_n;
//assign channel_sel = channel_sel_reg;
  
//endmodule

module pwm#(
  parameter integer cycle = 200000
)(
    input  clk_100M,
    input  clk_200M,
    input  rst_n,
    input  start,

    output ad_tog,
    output pwm_p,
    output pwm_n,
    output pwm2_p,
    output pwm2_n,
    output channel_sel
);

    //========================================================
    // 1) 100MHz 域：产生4ms节拍 + 通道翻转 + 发射触发脉冲
    //========================================================
    // 4ms = 100MHz * 4ms = 400000 cycles
    reg [18:0] cnt_4ms; // 需要能数到 399999 (19bit足够)
    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n)
            cnt_4ms <= 19'd0;
        else if (cnt_4ms == 2 * cycle - 1)
            cnt_4ms <= 19'd0;
        else
            cnt_4ms <= cnt_4ms + 1'b1;
    end

    // 通道选择：在 2ms 时刻翻转一次（200000 cycles）
    reg channel_sel_100m;
    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n)
            channel_sel_100m <= 1'b1;
        else if (cnt_4ms == cycle)
            channel_sel_100m <= ~channel_sel_100m;
    end

    // 发射触发脉冲：每个 4ms 周期开始时给 1 拍脉冲
    // 用 cnt==0 或 cnt==1 都行；用 cnt==0 更直观
    reg tx_pulse_100m;
    always @(posedge clk_100M or negedge rst_n) begin
        if (!rst_n)
            tx_pulse_100m <= 1'b0;
        else
            tx_pulse_100m <= (cnt_4ms == 19'd0);
    end

    //========================================================
    // 2) CDC：把 100MHz 的 tx_pulse 同步到 200MHz 并做边沿检测
    //========================================================
    reg tx_sync1_200m, tx_sync2_200m;
    always @(posedge clk_200M or negedge rst_n) begin
        if (!rst_n) begin
            tx_sync1_200m <= 1'b0;
            tx_sync2_200m <= 1'b0;
        end else begin
            tx_sync1_200m <= tx_pulse_100m;
            tx_sync2_200m <= tx_sync1_200m;
        end
    end
    wire tx_start_200m = tx_sync1_200m & ~tx_sync2_200m; // 上升沿检测（1个200M周期脉冲）

    // CDC：把通道选择电平同步到 200MHz
    reg ch_sync1_200m, ch_sync2_200m;
    always @(posedge clk_200M or negedge rst_n) begin
        if (!rst_n) begin
            ch_sync1_200m <= 1'b1;
            ch_sync2_200m <= 1'b1;
        end else begin
            ch_sync1_200m <= channel_sel_100m;
            ch_sync2_200m <= ch_sync1_200m;
        end
    end
    wire channel_sel_200m = ch_sync2_200m;

    //========================================================
    // 3) 200MHz 域：读 ROM 输出 burst（500点=2.5us）到对应通道
    //========================================================
    reg pwm_en;
    reg [8:0] addra;

    always @(posedge clk_200M or negedge rst_n) begin
        if (!rst_n)
            pwm_en <= 1'b0;
        else if (tx_start_200m)
            pwm_en <= 1'b1;
        else if (pwm_en && addra == 9'd499)
            pwm_en <= 1'b0;
    end

    always @(posedge clk_200M or negedge rst_n) begin
        if (!rst_n)
            addra <= 9'd0;
        else if (!pwm_en)
            addra <= 9'd0;
        else if (addra == 9'd499)
            addra <= 9'd0;
        else
            addra <= addra + 1'b1;
    end

    // ROM 输出
    wire dout_1;
    wire dout_2;

    blk_mem_gen_0 mem_pwm_1 (
        .clka  (clk_200M),
        .addra (addra),
        .douta (dout_1)
    );

    blk_mem_gen_1 mem_pwm_2 (
        .clka  (clk_200M),
        .addra (addra),
        .douta (dout_2)
    );

    // 两路驱动
    reg fre1_p, fre1_n, fre2_p, fre2_n;

    always @(posedge clk_200M or negedge rst_n) begin
        if (!rst_n) begin
            fre1_p <= 1'b0; fre1_n <= 1'b0;
            fre2_p <= 1'b0; fre2_n <= 1'b0;
        end else if (!pwm_en) begin
            fre1_p <= 1'b0; fre1_n <= 1'b0;
            fre2_p <= 1'b0; fre2_n <= 1'b0;
        end else begin
            // 只在当前选中的通道输出波形，另一通道保持0
            if (channel_sel_200m) begin
                fre1_p <= dout_1; fre1_n <= dout_2;
                fre2_p <= 1'b0;   fre2_n <= 1'b0;
            end else begin
                fre2_p <= dout_1; fre2_n <= dout_2;
                fre1_p <= 1'b0;   fre1_n <= 1'b0;
            end
        end
    end

    //========================================================
    // 4) ad_tog：在 burst 结束时产生（仍然在200M域）翻转
    //========================================================
    reg ad_tog_reg;

    always @(posedge clk_200M or negedge rst_n) begin
        if(!rst_n)
            ad_tog_reg <= 1'b0;
        else if (pwm_en && addra == 9'd499)   // burst最后一个点
            ad_tog_reg <= ~ad_tog_reg;        // 翻转一次 = 触发事件
    end

    assign ad_tog = ad_tog_reg;


    //========================================================
    // 输出
    //========================================================
    assign pwm_p  = fre1_p;
    assign pwm_n  = fre1_n;
    assign pwm2_p = fre2_p;
    assign pwm2_n = fre2_n;

    // 对外导出通道选择，建议导出 100MHz 域的（更"逻辑层"）
    assign channel_sel = channel_sel_100m;

endmodule


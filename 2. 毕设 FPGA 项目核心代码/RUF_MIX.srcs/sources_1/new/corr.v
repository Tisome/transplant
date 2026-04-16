`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 22:45:23
// Design Name: 
// Module Name: corr
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


module corr #(
  parameter integer DATAW  = 16,
  parameter integer AD_LEN = 2000
)(
  input  wire                    clk_100M,
  input  wire                    rst_n,

  input  wire signed [DATAW-1:0] sample_in,
  input  wire                    sample_valid,
  input  wire                    channel_seg,   // 1=A, 0=B

  output reg                     out_valid_reg,
  output reg signed [47:0]       conv_out_y1,
  output reg signed [47:0]       conv_out_y2,
  output reg signed [47:0]       conv_out_y3
);

  //==========================================================
  // 地址宽度：2000点需要11bit
  //==========================================================
  localparam integer ADDRW = 11;

  localparam [ADDRW-1:0] N_Y1 = AD_LEN - 1; // 1999项
  localparam [ADDRW-1:0] N_Y2 = AD_LEN;     // 2000项
  localparam [ADDRW-1:0] N_Y3 = AD_LEN - 1; // 1999项

  //==========================================================
  // RAM A / RAM B（Simple Dual Port）
  // A口写，B口读（读延迟=1clk）
  //==========================================================
  reg                   ramA_ena, ramA_wea;
  reg  [ADDRW-1:0]      ramA_addra;
  reg  [DATAW-1:0]      ramA_dina;

  reg                   ramB_ena, ramB_wea;
  reg  [ADDRW-1:0]      ramB_addra;
  reg  [DATAW-1:0]      ramB_dina;

  reg                   ramA_enb;
  reg  [ADDRW-1:0]      ramA_addrb;
  wire [DATAW-1:0]      ramA_doutb;

  reg                   ramB_enb;
  reg  [ADDRW-1:0]      ramB_addrb;
  wire [DATAW-1:0]      ramB_doutb;

  CORR_RAM RAM_A (
    .clka (clk_100M),
    .ena  (ramA_ena),
    .wea  (ramA_wea),
    .addra(ramA_addra),
    .dina (ramA_dina),
    .clkb (clk_100M),
    .enb  (ramA_enb),
    .addrb(ramA_addrb),
    .doutb(ramA_doutb)
  );

  CORR_RAM RAM_B (
    .clka (clk_100M),
    .ena  (ramB_ena),
    .wea  (ramB_wea),
    .addra(ramB_addra),
    .dina (ramB_dina),
    .clkb (clk_100M),
    .enb  (ramB_enb),
    .addrb(ramB_addrb),
    .doutb(ramB_doutb)
  );

  //==========================================================
  // CORR_MULT：Signed 16x16 -> 32，pipeline=2
  //
  // 方案A：把 CORR_MULT 的输入直接接 RAM doutb（signed转换）
  // 这样从 issue_v 到 mult_p 的总延迟 = RAM(1) + MULT(2) = 3拍
  //==========================================================
  wire signed [DATAW-1:0] mult_a_w = $signed(ramA_doutb);
  wire signed [DATAW-1:0] mult_b_w = $signed(ramB_doutb);
  wire signed [31:0]      mult_p;

  CORR_MULT u_corr_mult (
    .CLK(clk_100M),
    .A  (mult_a_w),
    .B  (mult_b_w),
    .P  (mult_p)
  );

  wire signed [47:0] mult_p_48 = {{16{mult_p[31]}}, mult_p};

  //==========================================================
  // 写入计数 & 满标志
  //==========================================================
  reg [ADDRW-1:0] wrA, wrB;
  reg             fullA, fullB;

  //==========================================================
  // FSM
  //==========================================================
  localparam [2:0] S_CAP  = 3'd0;
  localparam [2:0] S_Y1   = 3'd1;
  localparam [2:0] S_Y2   = 3'd2;
  localparam [2:0] S_Y3   = 3'd3;
  localparam [2:0] S_DONE = 3'd4;

  reg [2:0] state;

  reg [ADDRW-1:0] issue_cnt; // 发起读请求计数
  reg [ADDRW-1:0] done_cnt;  // 已经完成累加的项数

  // 本拍是否发起读请求（enb=1且给addr）
  reg issue_v;

  // 延迟链：RAM读1拍 + MULT 2拍 = 3拍
  reg v1, v2, v3;

  // （可选）为了看波形，把 RAM doutb 打一拍寄存下来
  // 注意：这些寄存不再用于乘法，只用于观察
  reg signed [DATAW-1:0] a_q, b_q;

  // 48位累加器
  reg signed [47:0] acc;

  //==========================================================
  // 写RAM：仅 S_CAP 状态写入
  //==========================================================
  always @(posedge clk_100M) begin
    if (!rst_n) begin
      wrA   <= {ADDRW{1'b0}};
      wrB   <= {ADDRW{1'b0}};
      fullA <= 1'b0;
      fullB <= 1'b0;

      ramA_ena <= 1'b0; ramA_wea <= 1'b0; ramA_addra <= {ADDRW{1'b0}}; ramA_dina <= {DATAW{1'b0}};
      ramB_ena <= 1'b0; ramB_wea <= 1'b0; ramB_addra <= {ADDRW{1'b0}}; ramB_dina <= {DATAW{1'b0}};
    end else begin
      ramA_ena <= 1'b0; ramA_wea <= 1'b0;
      ramB_ena <= 1'b0; ramB_wea <= 1'b0;

      if (state == S_CAP) begin
        if (sample_valid) begin
          if (channel_seg) begin
            if (!fullA) begin
              ramA_ena   <= 1'b1;
              ramA_wea   <= 1'b1;
              ramA_addra <= wrA;
              ramA_dina  <= sample_in[DATAW-1:0];

              if (wrA == AD_LEN-1) fullA <= 1'b1;
              else                 wrA   <= wrA + 1'b1;
            end
          end else begin
            if (!fullB) begin
              ramB_ena   <= 1'b1;
              ramB_wea   <= 1'b1;
              ramB_addra <= wrB;
              ramB_dina  <= sample_in[DATAW-1:0];

              if (wrB == AD_LEN-1) fullB <= 1'b1;
              else                 wrB   <= wrB + 1'b1;
            end
          end
        end
      end
    end
  end

  //==========================================================
  // 读RAM + MULT + 累加 + FSM
  //==========================================================
  always @(posedge clk_100M) begin
    if (!rst_n) begin
      state         <= S_CAP;
      out_valid_reg <= 1'b0;

      conv_out_y1   <= 48'd0;
      conv_out_y2   <= 48'd0;
      conv_out_y3   <= 48'd0;

      ramA_enb      <= 1'b0;
      ramB_enb      <= 1'b0;
      ramA_addrb    <= {ADDRW{1'b0}};
      ramB_addrb    <= {ADDRW{1'b0}};

      issue_cnt     <= {ADDRW{1'b0}};
      done_cnt      <= {ADDRW{1'b0}};
      issue_v       <= 1'b0;

      v1            <= 1'b0;
      v2            <= 1'b0;
      v3            <= 1'b0;

      a_q           <= {DATAW{1'b0}};
      b_q           <= {DATAW{1'b0}};

      acc           <= 48'd0;
    end else begin
      // 默认输出无效脉冲
      out_valid_reg <= 1'b0;

      // 默认不读
      ramA_enb <= 1'b0;
      ramB_enb <= 1'b0;

      // 默认本拍不发起读
      issue_v  <= 1'b0;

      // valid 延迟链：对齐 RAM(1拍) + MULT(2拍)
      v1 <= issue_v;
      v2 <= v1;
      v3 <= v2;

      // 仅用于观察波形：把 doutb 打一拍
      a_q <= $signed(ramA_doutb);
      b_q <= $signed(ramB_doutb);

      // v3为1时，mult_p 对应的是那次读请求的乘积，可以累加
      if (v3) begin
        acc      <= acc + mult_p_48;
        done_cnt <= done_cnt + 1'b1;
      end

      case (state)
        //====================================================
        // 采集：等 A/B 都写满
        //====================================================
        S_CAP: begin
          if (fullA && fullB) begin
            state     <= S_Y1;
            issue_cnt <= {ADDRW{1'b0}};
            done_cnt  <= {ADDRW{1'b0}};
            acc       <= 48'd0;
          end
        end

        //====================================================
        // y1：A[1..1999] * B[0..1998] 共1999项
        //====================================================
        S_Y1: begin
          if (issue_cnt < N_Y1) begin
            ramA_enb   <= 1'b1;
            ramB_enb   <= 1'b1;
            ramA_addrb <= issue_cnt + 1'b1;
            ramB_addrb <= issue_cnt;
            issue_cnt  <= issue_cnt + 1'b1;
            issue_v    <= 1'b1;
          end

          // 当本拍正在累加最后一项
          if (v3 && (done_cnt == (N_Y1-1))) begin
            conv_out_y1 <= acc + mult_p_48;
            state       <= S_Y2;
            issue_cnt   <= {ADDRW{1'b0}};
            done_cnt    <= {ADDRW{1'b0}};
            acc         <= 48'd0;
          end
        end

        //====================================================
        // y2：A[0..1999] * B[0..1999] 共2000项
        //====================================================
        S_Y2: begin
          if (issue_cnt < N_Y2) begin
            ramA_enb   <= 1'b1;
            ramB_enb   <= 1'b1;
            ramA_addrb <= issue_cnt;
            ramB_addrb <= issue_cnt;
            issue_cnt  <= issue_cnt + 1'b1;
            issue_v    <= 1'b1;
          end

          if (v3 && (done_cnt == (N_Y2-1))) begin
            conv_out_y2 <= acc + mult_p_48;
            state       <= S_Y3;
            issue_cnt   <= {ADDRW{1'b0}};
            done_cnt    <= {ADDRW{1'b0}};
            acc         <= 48'd0;
          end
        end

        //====================================================
        // y3：A[0..1998] * B[1..1999] 共1999项
        //====================================================
        S_Y3: begin
          if (issue_cnt < N_Y3) begin
            ramA_enb   <= 1'b1;
            ramB_enb   <= 1'b1;
            ramA_addrb <= issue_cnt;
            ramB_addrb <= issue_cnt + 1'b1;
            issue_cnt  <= issue_cnt + 1'b1;
            issue_v    <= 1'b1;
          end

          if (v3 && (done_cnt == (N_Y3-1))) begin
            conv_out_y3 <= acc + mult_p_48;
            state       <= S_DONE;
          end
        end

        //====================================================
        // DONE：打一拍 out_valid，然后清空采集状态
        //====================================================
        S_DONE: begin
          out_valid_reg <= 1'b1;
          state <= S_CAP;

          wrA   <= {ADDRW{1'b0}};
          wrB   <= {ADDRW{1'b0}};
          fullA <= 1'b0;
          fullB <= 1'b0;
        end

        default: state <= S_CAP;
      endcase
    end
  end

endmodule

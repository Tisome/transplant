`timescale 1ns / 1ps

module spi_comm_test_gen #(
    parameter integer INTER_PULSE_GAP_CYCLES = 16,
    parameter integer DATA_PERIOD_CYCLES     = 400000
)(
    input  wire               clk,
    input  wire               rst_n,
    input  wire               test_start,
    input  wire               fpga_int,

    output reg  [15:0]        max_idx,
    output reg                max_valid,
    output reg                channel_sel,

    output reg                corr_valid,
    output reg signed [47:0]  conv_out_y1,
    output reg signed [47:0]  conv_out_y2,
    output reg signed [47:0]  conv_out_y3,

    output reg  [7:0]         packet_id_dbg,
    output reg  [3:0]         state_dbg
);

    localparam [3:0] S_IDLE        = 4'd0;
    localparam [3:0] S_LOAD        = 4'd1;
    localparam [3:0] S_SET_A       = 4'd2;
    localparam [3:0] S_PULSE_A     = 4'd3;
    localparam [3:0] S_GAP_A       = 4'd4;
    localparam [3:0] S_SET_B       = 4'd5;
    localparam [3:0] S_PULSE_B     = 4'd6;
    localparam [3:0] S_GAP_B       = 4'd7;
    localparam [3:0] S_PULSE_CORR  = 4'd8;
    localparam [3:0] S_WAIT_INT_HI = 4'd9;
    localparam [3:0] S_WAIT_INT_LO = 4'd10;

    reg [3:0]  state;
    reg [31:0] wait_cnt;
    reg [31:0] period_cnt;
    reg [7:0]  packet_id;
    reg        sample_due;

    reg [15:0]       idx_a_data;
    reg [15:0]       idx_b_data;
    reg signed [47:0] y1_data;
    reg signed [47:0] y2_data;
    reg signed [47:0] y3_data;

    always @(posedge clk) begin
        if (!rst_n) begin
            state         <= S_IDLE;
            wait_cnt      <= 32'd0;
            period_cnt    <= 32'd0;
            packet_id     <= 8'd0;
            packet_id_dbg <= 8'd0;
            state_dbg     <= S_IDLE;
            sample_due    <= 1'b0;

            idx_a_data    <= 16'd0;
            idx_b_data    <= 16'd0;
            y1_data       <= 48'sd0;
            y2_data       <= 48'sd0;
            y3_data       <= 48'sd0;

            max_idx       <= 16'd0;
            max_valid     <= 1'b0;
            channel_sel   <= 1'b0;

            corr_valid    <= 1'b0;
            conv_out_y1   <= 48'sd0;
            conv_out_y2   <= 48'sd0;
            conv_out_y3   <= 48'sd0;
        end else begin
            max_valid     <= 1'b0;
            corr_valid    <= 1'b0;
            packet_id_dbg <= packet_id;
            state_dbg     <= state;

            if (period_cnt >= (DATA_PERIOD_CYCLES - 1)) begin
                period_cnt <= 32'd0;
                sample_due <= 1'b1;
            end else begin
                period_cnt <= period_cnt + 1'b1;
            end

            case (state)
                S_IDLE: begin
                    wait_cnt    <= 32'd0;
                    channel_sel <= 1'b0;
                    max_idx     <= 16'd0;
                    if (sample_due && test_start) begin
                        sample_due <= 1'b0;
                        state <= S_LOAD;
                    end
                end

                S_LOAD: begin
                    // This fixed packet mirrors a "good" fake-data frame:
                    // dt ~= 20.52 ns, v ~= 1.0 m/s, q ~= 1.13 m^3/h
                    idx_a_data  <= 16'd3000;
                    idx_b_data  <= 16'd3001;
                    y1_data     <= 48'sd955618630;
                    y2_data     <= 48'sd988857318;
                    y3_data     <= 48'sd822096006;

                    max_idx     <= 16'd0;
                    channel_sel <= 1'b0;
                    wait_cnt    <= 32'd0;
                    state       <= S_SET_A;
                end

                S_SET_A: begin
                    channel_sel <= 1'b1;
                    max_idx     <= idx_a_data;
                    conv_out_y1 <= y1_data;
                    conv_out_y2 <= y2_data;
                    conv_out_y3 <= y3_data;
                    state       <= S_PULSE_A;
                end

                S_PULSE_A: begin
                    channel_sel <= 1'b1;
                    max_idx     <= idx_a_data;
                    max_valid   <= 1'b1;
                    wait_cnt    <= 32'd0;
                    state       <= S_GAP_A;
                end

                S_GAP_A: begin
                    channel_sel <= 1'b1;
                    max_idx     <= idx_a_data;
                    if (wait_cnt >= (INTER_PULSE_GAP_CYCLES - 1)) begin
                        wait_cnt <= 32'd0;
                        state    <= S_SET_B;
                    end else begin
                        wait_cnt <= wait_cnt + 1'b1;
                    end
                end

                S_SET_B: begin
                    channel_sel <= 1'b0;
                    max_idx     <= idx_b_data;
                    state       <= S_PULSE_B;
                end

                S_PULSE_B: begin
                    channel_sel <= 1'b0;
                    max_idx     <= idx_b_data;
                    max_valid   <= 1'b1;
                    wait_cnt    <= 32'd0;
                    state       <= S_GAP_B;
                end

                S_GAP_B: begin
                    channel_sel <= 1'b0;
                    max_idx     <= idx_b_data;
                    if (wait_cnt >= (INTER_PULSE_GAP_CYCLES - 1)) begin
                        wait_cnt    <= 32'd0;
                        conv_out_y1 <= y1_data;
                        conv_out_y2 <= y2_data;
                        conv_out_y3 <= y3_data;
                        state       <= S_PULSE_CORR;
                    end else begin
                        wait_cnt <= wait_cnt + 1'b1;
                    end
                end

                S_PULSE_CORR: begin
                    corr_valid <= 1'b1;
                    state      <= S_WAIT_INT_HI;
                end

                S_WAIT_INT_HI: begin
                    if (fpga_int) begin
                        state <= S_WAIT_INT_LO;
                    end
                end

                S_WAIT_INT_LO: begin
                    if (!fpga_int) begin
                        packet_id <= packet_id + 1'b1;
                        wait_cnt  <= 32'd0;
                        state     <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule

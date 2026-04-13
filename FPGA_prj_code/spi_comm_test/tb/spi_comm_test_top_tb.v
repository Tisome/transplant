`timescale 1ns / 1ps

module spi_comm_test_top_tb;

    localparam integer PKT_BYTES = 22;
    localparam integer PKT_BITS  = PKT_BYTES * 8;

    localparam signed [47:0] BASE_Y1 = 48'sd955618630;
    localparam signed [47:0] BASE_Y2 = 48'sd988857318;
    localparam signed [47:0] BASE_Y3 = 48'sd822096006;

    reg sys_clk = 1'b0;
    reg rst_n   = 1'b0;

    reg spi_cs_n = 1'b1;
    reg spi_sclk = 1'b0;
    reg mcu_start = 1'b0;

    wire fpga_int;
    wire spi_miso;
    wire [1:0] dbg_led;

    integer packet_num;
    reg [PKT_BITS-1:0] rx_pkt;
    reg [15:0] idxA;
    reg [15:0] idxB;
    reg [15:0] exp_idxA;
    reg [15:0] exp_idxB;
    reg signed [47:0] exp_y1;
    reg signed [47:0] exp_y2;
    reg signed [47:0] exp_y3;
    reg signed [47:0] y1;
    reg signed [47:0] y2;
    reg signed [47:0] y3;

    spi_comm_test_top #(
        .INTER_PULSE_GAP_CYCLES (4),
        .DATA_PERIOD_CYCLES     (64)
    ) dut (
        .sys_clk  (sys_clk),
        .rst_n    (rst_n),
        .mcu_start(mcu_start),
        .fpga_int (fpga_int),
        .spi_cs_n (spi_cs_n),
        .spi_sclk (spi_sclk),
        .spi_miso (spi_miso),
        .dbg_led  (dbg_led)
    );

    always #10 sys_clk = ~sys_clk;

    initial begin
        rst_n = 1'b0;
        repeat (10) @(posedge sys_clk);
        rst_n = 1'b1;
    end

    task automatic spi_read_packet(output reg [PKT_BITS-1:0] rx_flat);
        integer bit_i;
        begin
            rx_flat  = {PKT_BITS{1'b0}};
            spi_sclk = 1'b0;
            spi_cs_n = 1'b0;
            #60;

            for (bit_i = 0; bit_i < PKT_BITS; bit_i = bit_i + 1) begin
                #40;
                spi_sclk = 1'b1;
                #10;
                rx_flat[PKT_BITS-1-bit_i] = spi_miso;
                #40;
                spi_sclk = 1'b0;
            end

            #40;
            spi_cs_n = 1'b1;
            #40;
        end
    endtask

    task automatic mcu_allow_next_packet;
        begin
            mcu_start = 1'b1;
        end
    endtask

    task automatic mcu_holdoff_packet;
        begin
            mcu_start = 1'b0;
        end
    endtask

    initial begin
        packet_num = 0;
        mcu_start  = 1'b0;

        @(posedge rst_n);
        repeat (4) @(posedge sys_clk);
        mcu_allow_next_packet();

        repeat (3) begin
            wait (fpga_int === 1'b1);
            mcu_holdoff_packet();
            spi_read_packet(rx_pkt);
            mcu_allow_next_packet();

            idxA = {rx_pkt[PKT_BITS-1  -: 8], rx_pkt[PKT_BITS-9   -: 8]};
            idxB = {rx_pkt[PKT_BITS-17 -: 8], rx_pkt[PKT_BITS-25  -: 8]};
            y1   = {rx_pkt[PKT_BITS-33  -: 8], rx_pkt[PKT_BITS-41  -: 8],
                    rx_pkt[PKT_BITS-49  -: 8], rx_pkt[PKT_BITS-57  -: 8],
                    rx_pkt[PKT_BITS-65  -: 8], rx_pkt[PKT_BITS-73  -: 8]};
            y2   = {rx_pkt[PKT_BITS-81  -: 8], rx_pkt[PKT_BITS-89  -: 8],
                    rx_pkt[PKT_BITS-97  -: 8], rx_pkt[PKT_BITS-105 -: 8],
                    rx_pkt[PKT_BITS-113 -: 8], rx_pkt[PKT_BITS-121 -: 8]};
            y3   = {rx_pkt[PKT_BITS-129 -: 8], rx_pkt[PKT_BITS-137 -: 8],
                    rx_pkt[PKT_BITS-145 -: 8], rx_pkt[PKT_BITS-153 -: 8],
                    rx_pkt[PKT_BITS-161 -: 8], rx_pkt[PKT_BITS-169 -: 8]};

            exp_idxA   = 16'd3000;
            exp_idxB   = 16'd3001;
            exp_y1     = BASE_Y1;
            exp_y2     = BASE_Y2;
            exp_y3     = BASE_Y3;

            if (idxA !== exp_idxA) begin
                $display("ERROR: idxA mismatch, got=0x%04h exp=0x%04h", idxA, exp_idxA);
                $finish;
            end

            if (idxB !== exp_idxB) begin
                $display("ERROR: idxB mismatch, got=0x%04h exp=0x%04h", idxB, exp_idxB);
                $finish;
            end

            if (y1 !== exp_y1) begin
                $display("ERROR: y1 mismatch, got=%0d exp=%0d", y1, exp_y1);
                $finish;
            end

            if (y2 !== exp_y2) begin
                $display("ERROR: y2 mismatch, got=%0d exp=%0d", y2, exp_y2);
                $finish;
            end

            if (y3 !== exp_y3) begin
                $display("ERROR: y3 mismatch, got=%0d exp=%0d", y3, exp_y3);
                $finish;
            end

            wait (fpga_int === 1'b0);
            packet_num = packet_num + 1;
        end

        $display("PASS: spi_comm_test_top_tb received %0d packets.", packet_num);
        #200;
        $finish;
    end

    initial begin
        #500000;
        $display("TIMEOUT");
        $finish;
    end

endmodule

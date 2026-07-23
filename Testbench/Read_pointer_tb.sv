`timescale 1ns/1ps

module read_pointer_tb;

    parameter DEPTH = 8;

    logic clk;
    logic reset;
    logic rd_en;
    logic empty;

    logic [$clog2(DEPTH):0] read_ptr;

    // DUT
    read_pointer #(
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .rd_en(rd_en),
        .empty(empty),
        .read_ptr(read_ptr)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | reset=%b | rd_en=%b | empty=%b | read_ptr=%b",
                 $time, reset, rd_en, empty, read_ptr);
    end

    // Test Sequence
    initial begin

        reset = 1;
        rd_en = 0;
        empty = 0;

        #10;

        reset = 0;
        rd_en = 1;

        repeat (8)
            #10;

        empty = 1;
        #20;

        rd_en = 0;
        empty = 0;
        #20;

        $finish;

    end

    // Waveform
    initial begin
        $dumpfile("read_pointer_tb.vcd");
        $dumpvars(0, read_pointer_tb);
    end

endmodule

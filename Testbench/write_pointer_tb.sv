`timescale 1ns/1ps

module write_pointer_tb;

    parameter DEPTH = 8;

    logic clk;
    logic reset;
    logic wr_en;
    logic full;

    logic [$clog2(DEPTH):0] write_ptr;

    // DUT
    write_pointer #(
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .full(full),
        .write_ptr(write_ptr)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | reset=%b | wr_en=%b | full=%b | write_ptr=%b",
                 $time, reset, wr_en, full, write_ptr);
    end

    // Test Sequence
    initial begin

        reset = 1;
        wr_en = 0;
        full  = 0;

        #10;

        reset = 0;
        wr_en = 1;

        repeat (8)
            #10;

        full = 1;
        #20;

        wr_en = 0;
        full  = 0;
        #20;

        $finish;

    end

    // Waveform
    initial begin
        $dumpfile("write_pointer_tb.vcd");
        $dumpvars(0, write_pointer_tb);
    end

endmodule

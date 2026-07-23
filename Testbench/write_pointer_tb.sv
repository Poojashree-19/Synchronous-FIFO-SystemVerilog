`timescale 1ns/1ps

module write_pointer_tb;

    parameter DEPTH = 8;

    logic clk;
    logic reset;
    logic wr_en;
    logic full;
    logic [$clog2(DEPTH)-1:0] write_ptr;

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
        $monitor("Time=%0t | reset=%b | wr_en=%b | full=%b | write_ptr=%0d",
                  $time, reset, wr_en, full, write_ptr);
    end

    // Test Sequence
    initial begin

        // Initialize
        reset = 1;
        wr_en = 0;
        full  = 0;

        #10;

        // Release Reset
        reset = 0;

        // Increment pointer
        wr_en = 1;

        repeat (8)
            #10;

        // FIFO Full (Pointer should not increment)
        full = 1;
        #20;

        // Disable write
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

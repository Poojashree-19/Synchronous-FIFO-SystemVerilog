`timescale 1ns/1ps

module fifo_control_tb;

    parameter DEPTH = 8;

    logic [$clog2(DEPTH):0] write_ptr;
    logic [$clog2(DEPTH):0] read_ptr;

    logic full;
    logic empty;

    // DUT
    fifo_control #(
        .DEPTH(DEPTH)
    ) dut (
        .write_ptr(write_ptr),
        .read_ptr(read_ptr),
        .full(full),
        .empty(empty)
    );

    initial begin

        $monitor("Time=%0t | write_ptr=%b | read_ptr=%b | full=%b | empty=%b",
                 $time, write_ptr, read_ptr, full, empty);

        // Test 1 : Empty
        write_ptr = 4'b0000;
        read_ptr  = 4'b0000;
        #10;

        // Test 2 : Not Empty
        write_ptr = 4'b0011;
        read_ptr  = 4'b0001;
        #10;

        // Test 3 : Full
        write_ptr = 4'b1000;
        read_ptr  = 4'b0000;
        #10;

        // Test 4 : Neither Full nor Empty
        write_ptr = 4'b0110;
        read_ptr  = 4'b0010;
        #10;

        $finish;

    end

    initial begin
        $dumpfile("fifo_control_tb.vcd");
        $dumpvars(0, fifo_control_tb);
    end

endmodule

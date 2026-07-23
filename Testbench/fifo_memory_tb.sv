`timescale 1ns/1ps

module fifo_memory_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8;

    // Testbench Signals
    logic clk;
    logic wr_en;
    logic rd_en;
    logic [$clog2(DEPTH)-1:0] write_addr;
    logic [$clog2(DEPTH)-1:0] read_addr;
    logic [DATA_WIDTH-1:0] write_data;
    logic [DATA_WIDTH-1:0] read_data;

    // DUT (Device Under Test)
    fifo_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .write_addr(write_addr),
        .read_addr(read_addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock Generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor Signals
    initial begin
        $monitor("Time=%0t | wr_en=%b | rd_en=%b | WAddr=%0d | RAddr=%0d | WData=%0d | RData=%0d",
                  $time, wr_en, rd_en, write_addr, read_addr, write_data, read_data);
    end

    // Test Sequence
    initial begin

        // Initialize Inputs
        wr_en      = 0;
        rd_en      = 0;
        write_addr = 0;
        read_addr  = 0;
        write_data = 0;

        #10;

        // -----------------------------
        // Write 10 into Address 0
        // -----------------------------
        wr_en      = 1;
        write_addr = 0;
        write_data = 8'd10;
        #10;

        // Write 20 into Address 1
        write_addr = 1;
        write_data = 8'd20;
        #10;

        // Write 30 into Address 2
        write_addr = 2;
        write_data = 8'd30;
        #10;

        // Disable Write
        wr_en = 0;

        // -----------------------------
        // Read Address 0
        // -----------------------------
        rd_en     = 1;
        read_addr = 0;
        #10;

        // Read Address 1
        read_addr = 1;
        #10;

        // Read Address 2
        read_addr = 2;
        #10;

        // Disable Read
        rd_en = 0;
        #10;

        $finish;

    end

    // Waveform Dump
    initial begin
        $dumpfile("fifo_memory_tb.vcd");
        $dumpvars(0, fifo_memory_tb);
    end

endmodule

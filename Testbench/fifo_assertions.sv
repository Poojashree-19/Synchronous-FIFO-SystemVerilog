`timescale 1ns/1ps

module fifo_assertions #(
    parameter DEPTH = 8
)(
    input logic clk,
    input logic reset,

    input logic wr_en,
    input logic rd_en,

    input logic full,
    input logic empty,

    input logic [$clog2(DEPTH):0] write_ptr,
    input logic [$clog2(DEPTH):0] read_ptr
);

    //=========================================================
    // Property 1 : Write pointer must not change when FIFO is FULL
    //=========================================================
    property no_write_when_full;
        @(posedge clk)
        disable iff (reset)
        (full && wr_en) |=> $stable(write_ptr);
    endproperty

    assert property(no_write_when_full)
        else
            $error("ASSERTION FAILED: Write pointer changed while FIFO was FULL.");

    //=========================================================
    // Property 2 : Read pointer must not change when FIFO is EMPTY
    //=========================================================
    property no_read_when_empty;
        @(posedge clk)
        disable iff (reset)
        (empty && rd_en) |=> $stable(read_ptr);
    endproperty

    assert property(no_read_when_empty)
        else
            $error("ASSERTION FAILED: Read pointer changed while FIFO was EMPTY.");

    //=========================================================
    // Property 3 : FIFO cannot be FULL and EMPTY simultaneously
    //=========================================================
    property full_empty_mutually_exclusive;
        @(posedge clk)
        disable iff (reset)
        !(full && empty);
    endproperty

    assert property(full_empty_mutually_exclusive)
        else
            $error("ASSERTION FAILED: FIFO is FULL and EMPTY at the same time.");

    //=========================================================
    // Property 4 : Reset initializes FIFO to EMPTY
    //=========================================================
    property reset_initializes_fifo;
        @(posedge clk)
        reset |=> (empty && !full);
    endproperty

    assert property(reset_initializes_fifo)
        else
            $error("ASSERTION FAILED: FIFO not initialized correctly after reset.");

    //=========================================================
    // Property 5 : Write pointer increments on a valid write
    //=========================================================
    property write_pointer_increment;
        @(posedge clk)
        disable iff (reset)
        (wr_en && !full) |=> (write_ptr == $past(write_ptr) + 1);
    endproperty

    assert property(write_pointer_increment)
        else
            $error("ASSERTION FAILED: Write pointer did not increment correctly.");

    //=========================================================
    // Property 6 : Read pointer increments on a valid read
    //=========================================================
    property read_pointer_increment;
        @(posedge clk)
        disable iff (reset)
        (rd_en && !empty) |=> (read_ptr == $past(read_ptr) + 1);
    endproperty

    assert property(read_pointer_increment)
        else
            $error("ASSERTION FAILED: Read pointer did not increment correctly.");

endmodule

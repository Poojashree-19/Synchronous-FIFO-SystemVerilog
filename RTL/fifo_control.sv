
module fifo_control #(
    parameter DEPTH = 8
)(
    input  logic [$clog2(DEPTH):0] write_ptr,
    input  logic [$clog2(DEPTH):0] read_ptr,

    output logic full,
    output logic empty
);

always_comb begin

    // Empty Condition
    empty = (write_ptr == read_ptr);

    // Full Condition
    full = (write_ptr[$clog2(DEPTH)] != read_ptr[$clog2(DEPTH)]) &&
           (write_ptr[$clog2(DEPTH)-1:0] == read_ptr[$clog2(DEPTH)-1:0]);

end

endmodule

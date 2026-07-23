module write_pointer #(
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic wr_en,
    input  logic full,

    output logic [$clog2(DEPTH)-1:0] write_ptr
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        write_ptr <= 0;
    else if (wr_en && !full)
        write_ptr <= write_ptr + 1;
end

endmodule

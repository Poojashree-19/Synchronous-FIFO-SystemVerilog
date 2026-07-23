module read_pointer #(
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic rd_en,
    input  logic empty,

    output logic [$clog2(DEPTH)-1:0] read_ptr
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        read_ptr <= 0;
    else if (rd_en && !empty)
        read_ptr <= read_ptr + 1;
end

endmodule

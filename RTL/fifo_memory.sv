module fifo_memory #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    input  logic                     clk,
    input  logic                     wr_en,
    input  logic                     rd_en,
    input  logic [$clog2(DEPTH)-1:0] write_addr,
    input  logic [$clog2(DEPTH)-1:0] read_addr,
    input  logic [DATA_WIDTH-1:0]    write_data,
    output logic [DATA_WIDTH-1:0]    read_data
);

logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];

// Write
always_ff @(posedge clk) begin
    if (wr_en)
        memory[write_addr] <= write_data;
end

// Read
always_comb begin
    if (rd_en)
        read_data = memory[read_addr];
    else
        read_data = '0;
end

endmodule

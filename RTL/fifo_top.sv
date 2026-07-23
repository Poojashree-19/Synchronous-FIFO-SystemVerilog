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

`timescale 1ns/1ps

module write_pointer #(
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic wr_en,
    input  logic full,

    output logic [$clog2(DEPTH):0] write_ptr
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        write_ptr <= 0;
    else if (wr_en && !full)
        write_ptr <= write_ptr + 1;
end

endmodule
`timescale 1ns/1ps

module read_pointer #(
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic rd_en,
    input  logic empty,

    output logic [$clog2(DEPTH):0] read_ptr
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        read_ptr <= 0;
    else if (rd_en && !empty)
        read_ptr <= read_ptr + 1;
end

endmodule


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


`timescale 1ns/1ps

module fifo_top #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic wr_en,
    input  logic rd_en,
    input  logic [DATA_WIDTH-1:0] write_data,

    output logic [DATA_WIDTH-1:0] read_data,
    output logic full,
    output logic empty
);

logic [$clog2(DEPTH):0] write_ptr;
logic [$clog2(DEPTH):0] read_ptr;

fifo_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
) memory (

    .clk(clk),
    .wr_en(wr_en),
    .rd_en(rd_en),

    .write_addr(write_ptr[$clog2(DEPTH)-1:0]),
    .read_addr(read_ptr[$clog2(DEPTH)-1:0]),

    .write_data(write_data),
    .read_data(read_data)
);

write_pointer #(
    .DEPTH(DEPTH)
) write_ptr_inst (

    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .full(full),

    .write_ptr(write_ptr)
);

read_pointer #(
    .DEPTH(DEPTH)
) read_ptr_inst (

    .clk(clk),
    .reset(reset),
    .rd_en(rd_en),
    .empty(empty),

    .read_ptr(read_ptr)
);

fifo_control #(
    .DEPTH(DEPTH)
) fifo_control_inst (

    .write_ptr(write_ptr),
    .read_ptr(read_ptr),

    .full(full),
    .empty(empty)
);

endmodule

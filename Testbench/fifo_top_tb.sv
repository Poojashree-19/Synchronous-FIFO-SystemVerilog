`timescale 1ns/1ps

module fifo_top_tb;

parameter DATA_WIDTH = 8;
parameter DEPTH = 8;

//=====================================================
// Testbench Signals
//=====================================================

logic clk;
logic reset;
logic wr_en;
logic rd_en;
logic [DATA_WIDTH-1:0] write_data;

logic [DATA_WIDTH-1:0] read_data;
logic full;
logic empty;

//=====================================================
// Self-Checking Variables
//=====================================================

byte expected_queue[$];
byte expected_data;

integer pass_count = 0;
integer fail_count = 0;

//=====================================================
// DUT
//=====================================================

fifo_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
) dut (

    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .write_data(write_data),

    .read_data(read_data),
    .full(full),
    .empty(empty)
);



//=====================================================
// Clock Generation
//=====================================================

always #5 clk = ~clk;

//=====================================================
// VCD Dump
//=====================================================

initial begin
    $dumpfile("fifo_top_tb.vcd");
    $dumpvars(0, fifo_top_tb);
end;

//=====================================================
// Monitor
//=====================================================

initial begin
    $monitor(
        "Time=%0t Reset=%b WR=%b RD=%b WD=%0d RDATA=%0d FULL=%b EMPTY=%b",
        $time,
        reset,
        wr_en,
        rd_en,
        write_data,
        read_data,
        full,
        empty
    );
end;

//=====================================================
// Main Test
//=====================================================

initial begin

    clk = 0;
    reset = 1;
    wr_en = 0;
    rd_en = 0;
    write_data = 0;

    // Reset
    #20;
    reset = 0;

    $display("\n========================================");
    $display("TEST 1 : WRITE OPERATION");
    $display("========================================");

    //-------------------------------------------------
    // Write 10
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 10;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 20
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 20;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 30
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 30;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 40
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 40;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 50
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 50;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 60
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 60;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 70
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 70;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    //-------------------------------------------------
    // Write 80
    //-------------------------------------------------

    @(posedge clk);
    wr_en = 1;
    write_data = 80;
    expected_queue.push_back(write_data);

    @(posedge clk);
    wr_en = 0;

    $display("\nFIFO should now be FULL.");

    //-------------------------------------------------
    // Overflow Test
    //-------------------------------------------------

    $display("\n========================================");
    $display("TEST 2 : OVERFLOW");
    $display("========================================");

    @(posedge clk);
    wr_en = 1;
    write_data = 99;

    @(posedge clk);
    wr_en = 0;
      //=================================================
    // Read Test (Self-Checking)
    //=================================================

    $display("\n========================================");
    $display("TEST 3 : READ OPERATION");
    $display("========================================");
    repeat (DEPTH)
begin
    expected_data = expected_queue.pop_front();

    rd_en = 1;

    #1;   // Allow combinational read_data to settle

    if (read_data === expected_data)
    begin
        pass_count++;
        $display("PASS : Expected=%0d Received=%0d",
                 expected_data, read_data);
    end
    else
    begin
        fail_count++;
        $error("FAIL : Expected=%0d Received=%0d",
                expected_data, read_data);
    end

    @(posedge clk);   // Advance read pointer

    rd_en = 0;

    @(posedge clk);
end
    $display("\nFIFO should now be EMPTY.");

    //=================================================
    // Underflow Test
    //=================================================

    $display("\n========================================");
    $display("TEST 4 : UNDERFLOW");
    $display("========================================");

    @(posedge clk);
    rd_en = 1;

    @(posedge clk);
    rd_en = 0;

    //=================================================
    // Final Report
    //=================================================

    #20;

    $display("\n========================================");
    $display("FINAL TEST SUMMARY");
    $display("========================================");

    $display("PASS COUNT : %0d", pass_count);
    $display("FAIL COUNT : %0d", fail_count);

    if(fail_count == 0)
    begin
        $display("\n************************************");
        $display("*      ALL TESTS PASSED!           *");
        $display("************************************");
    end
    else
    begin
        $display("\n************************************");
        $display("*      SOME TESTS FAILED!          *");
        $display("************************************");
    end

    #20;
    $finish;

end

endmodule

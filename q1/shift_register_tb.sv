module shift_register_tb;

// complete here
  timeunit 1ns; timeprecision 1ps;

  localparam int N = 4;

  logic              clk;
  logic              rst_n;
  logic              serial_parallel;
  logic              load_enable;
  logic              serial_in;
  logic [N-1:0]      parallel_in;
  logic [N-1:0]      parallel_out;
  logic              serial_out;

  // DUT instance
  shift_register #(.N(N)) dut (
    .clk, .rst_n,
    .serial_parallel,
    .load_enable,
    .serial_in,
    .parallel_in,
    .parallel_out,
    .serial_out
  );

  // 100 MHz clock
  initial clk = 1'b0;
  always  #5ns clk = ~clk;

  initial begin
    serial_parallel = 0;
    load_enable     = 0;
    serial_in       = 0;
    parallel_in     = '0;

    // reset
    rst_n = 0;
    repeat (2) @(posedge clk);
    rst_n = 1;
    @(posedge clk); #1ps;

    // check reset -> zero
    if (parallel_out !== '0) $error("FAIL: after reset not zero, got %b", parallel_out);
    else                     $display("PASS: reset -> %b", parallel_out);

    // parallel load: 1101
    serial_parallel = 1;     // parallel mode
    load_enable     = 1;
    parallel_in     = 4'b1101;
    @(posedge clk); #1ps;
    if (parallel_out !== 4'b1101) $error("FAIL: parallel load, got %b", parallel_out);
    else                          $display("PASS: parallel load -> %b", parallel_out);

    // hold test: load_enable = 0 (should not change)
    load_enable = 0;
    parallel_in = 4'b0000;
    serial_in   = 1'b1;
    @(posedge clk); #1ps;
    if (parallel_out !== 4'b1101) $error("FAIL: hold, got %b", parallel_out);
    else                          $display("PASS: hold -> %b", parallel_out);

    // serial shifts
    // shift in 1
    load_enable     = 1;
    serial_parallel = 0;     // serial mode
    serial_in       = 1'b1;
    @(posedge clk); #1ps;
    if (parallel_out !== 4'b1011) $error("FAIL: shift in 1, got %b", parallel_out);
    else                          $display("PASS: shift(1) -> %b (serial_out=%b)", parallel_out, serial_out);

    // shift in 0
    serial_in = 1'b0;
    @(posedge clk); #1ps;
    if (parallel_out !== 4'b0110) $error("FAIL: shift in 0, got %b", parallel_out);
    else                          $display("PASS: shift(0) -> %b (serial_out=%b)", parallel_out, serial_out);

    // shift in 1
    serial_in = 1'b1;
    @(posedge clk); #1ps;
    if (parallel_out !== 4'b1101) $error("FAIL: shift in 1, got %b", parallel_out);
    else                          $display("PASS: shift(1) -> %b (serial_out=%b)", parallel_out, serial_out);

    $display("Test finished.");
    $finish;
  end


endmodule

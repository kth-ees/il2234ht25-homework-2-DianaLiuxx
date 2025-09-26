module shift_register #(parameter N=4)
                      (input logic clk,
                       input logic rst_n,
                       input logic serial_parallel,
                       input logic load_enable,
                       input logic serial_in,
                       input logic [N-1:0] parallel_in,
                       output logic [N-1:0] parallel_out,
                       output logic serial_out);

//complete here
  logic [N-1:0] q;            // the register

  assign parallel_out = q;
  assign serial_out   = q[N-1];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q <= '0;
    end else if (load_enable) begin
      if (serial_parallel) begin
        q <= parallel_in;                       // parallel load
      end else begin
        q <= { q[N-2:0], serial_in };           // serial shift-left
      end
    end

  end

endmodule

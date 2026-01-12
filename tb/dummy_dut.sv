/*
* Module: dummy_dut
* Description: A simple DUT with sub-modules to test hierarchical waveform dumping.
*/
module dummy_dut (
    input logic clk,
    input logic rst_n
);
  logic [31:0] counter;
  logic [ 7:0] state;

  // Sub-module instance to test depth
  sub_module u_sub (.*);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 0;
      state   <= 0;
    end else begin
      counter <= counter + 1;
      state   <= state + 1;
    end
  end
endmodule

/*
* Module: sub_module
* Description: Sub-level module to verify depth-specific dumping.
*/
module sub_module (
    input logic clk,
    input logic rst_n
);
  logic [3:0] sub_cnt;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) sub_cnt <= 0;
    else sub_cnt <= sub_cnt + 1;
  end
endmodule

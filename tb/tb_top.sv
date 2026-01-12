module tb_top;

  logic clk;
  logic rst_n;

  dummy_dut u_dut_0 (.*);
  dummy_dut u_dut_1 (.*);

  // Instantiate waveform controller
  smart_wave_ctrl u_wave_ctrl ();

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n = 0;
    #20 rst_n = 1;
    $display("Simulation running...");
    #2000;
    $display("Simulation finished.");
    $finish;
  end

endmodule

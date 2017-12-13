`include "clk_div.v"
`include "counter.v"

module lamp #( 
  parameter c_freq = 100000000 // 100 Mhz
)(
  input  i_clk,
  output o_led1,
  output o_led2
);

  wire w_clk;

  clk_div #(
    .c_div (c_freq / 2000000) // 2 MHz
  ) clk_div (
    .i_clk (i_clk),
    .o_clk (w_clk)
  );

  //assign o_led1 = w_clk;
  //assign o_led2 = !w_clk;

  localparam c_max = 16666; // 120 fps @ 2 MHz clock
  wire [$clog2(c_max)-1:0] r_count;

  counter #(
    .c_max (c_max)
  ) frame_counter (
    .i_clk (w_clk),
    .o_count (r_count)
  );

endmodule
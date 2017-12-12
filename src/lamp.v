`include "clk_div.v"

module lamp (
  input  i_clk100M,
  output o_led1,
  output o_led2
);

  wire w_clk;

  clk_div #(
    .c_div (50000000) // 2 Hz
  ) div (
    .i_clk (i_clk100M),
    .o_clk (w_clk)
  );

  assign o_led1 = w_clk;
  assign o_led2 = !w_clk;

endmodule

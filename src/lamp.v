`include "clk_div.v"

module lamp (
  input  i_clk100M,
  output o_led1,
  output o_led2
);

  reg r_clk;

  clk_div #(
    .c_div (50000000) // 2 Hz
  ) div (
    .i_clk (i_clk100M),
    .o_clk (r_clk)
  );

  assign o_led1 = r_clk;
  assign o_led2 = !r_clk;

endmodule

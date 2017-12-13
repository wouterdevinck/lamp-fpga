`include "clk_div.v"

module lamp #( 
  parameter c_freq = 100000000 // 100 Mhz
)(
  input  i_clk,
  output o_led1,
  output o_led2
);

  wire w_clk;

  clk_div #(
    .c_div (c_freq / 2) // 2 Hz
  ) div (
    .i_clk (i_clk),
    .o_clk (w_clk)
  );

  assign o_led1 = w_clk;
  assign o_led2 = !w_clk;

endmodule

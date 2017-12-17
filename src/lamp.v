`include "clk_div.v"
`include "demo.v"
//`include "framebuffer.v"

module lamp #( 
  parameter c_freq = 100000000 // 100 Mhz
)(
  input  i_clk,
  output o_led1,
  output o_led2,
  output o_clk,
  output o_dai,
  output o_lat
);

  wire w_clk;
  wire w_demo_clk;
  wire w_demo_dai;
  wire w_demo_lat;

  clk_div #(
    .c_div (c_freq / 2000000) // 2 MHz
  ) clk_div (
    .i_clk (i_clk),
    .o_clk (w_clk)
  );

  demo demo (
    .i_clk (w_clk),
    .o_clk (w_demo_clk),
    .o_dai (w_demo_dai),
    .o_lat (w_demo_lat)
  );

  /* wire [11:0] r_data;
  framebuffer #(
    .c_ledboards (30)
  ) ram (
    .i_clk (w_clk),
    .o_data (r_data)
  );
  assign o_led1 = r_data[0] & r_data[7];
  assign o_led2 = r_data[11];*/
  
  assign o_led1 = 1;
  assign o_led2 = 0;

  assign o_clk = w_demo_clk;
  assign o_dai = w_demo_dai;
  assign o_lat = w_demo_lat;

endmodule
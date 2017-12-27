`include "clk_div.v"
`include "framebuffer.v"
`include "driver.v"

module lamp #( 
  parameter c_freq = 100000000 // 100 Mhz
)(
  input  i_clk,
  output o_clk,
  output o_dai,
  output o_lat
);

  localparam c_ledboards = 2;
  localparam c_framerate = 120;
  localparam c_bps = 12;
  localparam c_clock = 2000000;

  localparam c_channels = c_ledboards * 32;
  localparam c_addr_w = $clog2(c_channels);

  wire w_clk;

  wire [c_bps-1:0] w_current_data;
  wire [c_addr_w-1:0] w_current_addr;
  wire w_current_write;

  wire [c_bps-1:0] w_driver_data;
  wire [c_addr_w-1:0] w_driver_addr;
  wire w_driver_clk;
  wire w_driver_dai;
  wire w_driver_lat;

  clk_div #(
    .c_div (c_freq / c_clock)
  ) clk_div (
    .i_clk (i_clk),
    .o_clk (w_clk)
  );

  framebuffer #(
    .c_ledboards (c_ledboards),
    .c_bps (c_bps)
  ) current (
    .i_clk (w_clk),
    .i_wen (w_current_write),
    .i_waddr (w_current_addr),
    .i_wdata (w_current_data),
    .i_ren (1'b1),
    .i_raddr (w_driver_addr),
    .o_rdata (w_driver_data)
  );
  
  driver #(
    .c_ledboards (c_ledboards),
    .c_bps (c_bps),
    .c_frame_period (c_clock / c_framerate)
  ) driver (
    .i_clk (w_clk),
    .i_data (w_driver_data),
    .o_addr (w_driver_addr),
    .o_clk (w_driver_clk),
    .o_dai (w_driver_dai),
    .o_lat (w_driver_lat)
  );

  assign o_clk = w_driver_clk;
  assign o_dai = w_driver_dai;
  assign o_lat = w_driver_lat;

endmodule
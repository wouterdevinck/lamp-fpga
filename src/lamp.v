`include "clk_div.v"
`include "framebuffer.v"
`include "animator.v"
`include "driver.v"

module lamp #( 
  parameter c_freq = 100000000 // 100 Mhz
)(
  input  i_clk,
  output o_clk,
  output o_dai,
  output o_lat
);

  localparam c_ledboards = 30;
  localparam c_framerate = 120;
  localparam c_max_time = 480;
  localparam c_bpc = 12;
  localparam c_clock = 2000000;

  localparam c_channels = c_ledboards * 32;
  localparam c_addr_w = $clog2(c_channels);
  localparam c_time_w = $clog2(c_max_time);

  wire w_clk;

  wire [c_bpc-1:0]    w_target_data;

  wire [c_bpc-1:0]    w_animator_data;
  wire [c_addr_w-1:0] w_animator_addr;
  wire                w_animator_write;

  wire [c_bpc-1:0]    w_current_data;
  wire [c_addr_w-1:0] w_current_addr;

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
    .c_bpc (c_bpc)
  ) next_target_frame (
    .i_clk (w_clk),
    .i_wen (),   // TODO
    .i_waddr (), // TODO
    .i_wdata (), // TODO
    .i_time (),  // TODO
    .i_raddr (), // TODO
    .o_rdata (), // TODO
    .o_time ()   // TODO
  );

  framebuffer #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc)
  ) target_frame (
    .i_clk (w_clk),
    .i_wen (),   // TODO
    .i_waddr (), // TODO
    .i_wdata (), // TODO
    .i_time (),  // TODO
    .i_raddr (w_animator_addr),
    .o_rdata (w_target_data),
    .o_time ()   // TODO
  );

  animator #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_max_time (c_max_time)
  ) animator (
    .i_clk (w_clk),
    .i_drq (w_driver_lat),
    .i_target_data (w_target_data),
    .i_current_data (w_current_data),
    .i_target_time (), // TODO
    .i_start_time (),  // TODO
    .o_wen (w_animator_write),
    .o_addr (w_animator_addr), 
    .o_data (w_animator_data)
  );

  framebuffer #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc)
  ) current_frame (
    .i_clk (w_clk),
    .i_wen (w_animator_write),
    .i_waddr (w_animator_addr),
    .i_wdata (w_animator_data),
    .i_time (), // TODO
    .i_raddr (w_current_addr),
    .o_rdata (w_current_data),
    .o_time ()  // TODO
  );
  
  driver #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_frame_period (c_clock / c_framerate)
  ) driver (
    .i_clk (w_clk),
    .i_data (w_current_data),
    .o_addr (w_driver_addr),
    .o_clk (w_driver_clk),
    .o_dai (w_driver_dai),
    .o_lat (w_driver_lat)
  );

  assign w_current_addr = w_driver_addr | w_animator_addr;

  assign o_clk = w_driver_clk;
  assign o_dai = w_driver_dai;
  assign o_lat = w_driver_lat;

endmodule
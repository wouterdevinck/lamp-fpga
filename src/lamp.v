`include "clkdiv.v"
`include "protocol.v"
`include "framebuffer.v"
`include "animator.v"
`include "driver.v"

module lamp #( 
  parameter c_freq = 100000000 // 100 Mhz
)(

  // Clock input
  input i_clk,

  // SPI slave
  input i_dck,
  input i_cs,
  input i_mosi,
  
  // Output to LED drivers
  output o_clk,
  output o_dai,
  output o_lat

);

  localparam c_ledboards = 30;
  localparam c_framerate = 120;
  localparam c_max_time = 1024;
  localparam c_max_type = 64;
  localparam c_bpc = 12;
  localparam c_clock = 2000000; // 2 MHz

  localparam c_channels = c_ledboards * 32;
  localparam c_addr_w = $clog2(c_channels);
  localparam c_time_w = $clog2(c_max_time);
  localparam c_type_w = $clog2(c_max_type);

  wire w_clk;

  wire [c_bpc-1:0] w_protocol_data;
  wire [c_time_w-1:0] w_protocol_time;
  wire [c_type_w-1:0] w_protocol_type;
  wire [c_addr_w-1:0] w_protocol_addr;
  wire w_protocol_write;

  wire [c_bpc-1:0] w_next_data;
  wire [c_time_w-1:0] w_next_time;
  wire [c_type_w-1:0] w_next_type;
  wire [c_addr_w-1:0] w_next_addr; // TODO: driver
  wire w_next_write; // TODO: driver

  wire [c_bpc-1:0] w_target_data;
  wire [c_time_w-1:0] w_target_time;
  wire [c_type_w-1:0] w_target_type;

  wire [c_bpc-1:0] w_animator_data;
  wire [c_addr_w-1:0] w_animator_addr;
  wire w_animator_write;

  wire [c_bpc-1:0] w_current_data;
  wire [c_addr_w-1:0] w_current_addr;

  wire [c_addr_w-1:0] w_driver_addr;

  wire w_driver_clk;
  wire w_driver_dai;
  wire w_driver_lat;

  clkdiv #(
    .c_div (c_freq / c_clock)
  ) clkdiv (
    .i_clk (i_clk),
    .o_clk (w_clk)
  );

  protocol #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_max_time (c_max_time),
    .c_max_type (c_max_type)
  ) protocol (
    .i_clk (w_clk),
    .i_dck (i_dck),
    .i_cs (i_cs),
    .i_mosi (i_mosi),
    .o_wen (w_protocol_write),
    .o_addr (w_protocol_addr),
    .o_data (w_protocol_data),
    .o_time (w_protocol_time),
    .o_type (w_protocol_type) 
  );

  framebuffer #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_max_time (c_max_time),
    .c_max_type (c_max_type)
  ) next_target_frame (
    .i_clk (w_clk),
    .i_wen (w_protocol_write),
    .i_waddr (w_protocol_addr),
    .i_wdata (w_protocol_data),
    .i_time (w_protocol_time),
    .i_type (w_protocol_type),
    .i_raddr (w_next_addr),
    .o_rdata (w_next_data),
    .o_time (w_next_time),
    .o_type (w_next_type)
  );

  framebuffer #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_max_time (c_max_time),
    .c_max_type (c_max_type)
  ) target_frame (
    .i_clk (w_clk),
    .i_wen (w_next_write),
    .i_waddr (w_next_addr),
    .i_wdata (w_next_data),
    .i_time (w_next_time),
    .i_type (w_next_type),
    .i_raddr (w_animator_addr),
    .o_rdata (w_target_data),
    .o_time (w_target_time),
    .o_type (w_target_type)
  );

  animator #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_max_time (c_max_time),
    .c_max_type (c_max_type)
  ) animator (
    .i_clk (w_clk),
    .i_drq (w_driver_lat),
    .i_target_data (w_target_data),
    .i_current_data (w_current_data),
    .i_type (w_target_type),
    .i_target_time (w_target_time),
    .i_start_time (),  // TODO
    .o_wen (w_animator_write),
    .o_addr (w_animator_addr), 
    .o_data (w_animator_data)
  );

  framebuffer #(
    .c_ledboards (c_ledboards),
    .c_bpc (c_bpc),
    .c_max_time (c_max_time),
    .c_max_type (c_max_type)
  ) current_frame (
    .i_clk (w_clk),
    .i_wen (w_animator_write),
    .i_waddr (w_animator_addr),
    .i_wdata (w_animator_data),
    .i_time (), // TODO
    .i_type (), // TODO
    .i_raddr (w_current_addr),
    .o_rdata (w_current_data),
    .o_time (), // TODO
    .o_type ()  // TODO
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
// Holds one frame. Uses 3 BRAMs for 30 ledboards.
module framebuffer #( 
  parameter c_ledboards = 30,
  // Each ledboard has two DM633 16 channel drivers.
  parameter c_channels = c_ledboards * 32,
  parameter c_addr_w = $clog2(c_channels),
  // Each channel has a 12 bit PWM.
  parameter c_bps = 12
)(
  input i_clk, i_wen, i_ren, 
  input [c_addr_w-1:0] i_waddr, i_raddr,
  input [c_bps-1:0] i_data,
  output reg [c_bps-1:0] o_data
);
  reg [c_bps-1:0] r_mem [0:c_channels-1];
  always @(posedge i_clk) begin
    if (i_wen)
      r_mem[i_waddr] <= i_data;
    if (i_ren)
      o_data <= r_mem[i_raddr];
  end
endmodule
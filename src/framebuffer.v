// Holds one frame. Uses 3 BRAMs for 30 ledboards.
module framebuffer #( 
  parameter c_ledboards = 30,
  // Each ledboard has two DM633 16 channel drivers.
  parameter c_channels = c_ledboards * 32,
  parameter c_addr_w = $clog2(c_channels),
  // Each channel has a 12 bit PWM.
  parameter c_bpc = 12
)(
  input i_clk, i_wen, i_ren, 
  input [c_addr_w-1:0] i_waddr, i_raddr,
  input [c_bpc-1:0] i_wdata,
  output reg [c_bpc-1:0] o_rdata
);
  reg [c_bpc-1:0] r_mem [0:c_channels-1];
  always @(posedge i_clk) begin
    if (i_wen)
      r_mem[i_waddr] <= i_wdata;
    if (i_ren)
      o_rdata <= r_mem[i_raddr];
  end
  initial begin 
    r_mem[0]  = 12'hFFF;
    r_mem[1]  = 0;
    r_mem[2]  = 0;
    r_mem[3]  = 0;
    r_mem[4]  = 12'hFFF;
    r_mem[5]  = 0;
    r_mem[6]  = 0;
    r_mem[7]  = 0;
    r_mem[8]  = 12'hFFF;
    r_mem[9]  = 0;
    r_mem[10] = 0;
    r_mem[11] = 0;
    r_mem[12] = 12'hFFF;
    r_mem[13] = 0;
    r_mem[14] = 0;
    r_mem[15] = 0;
    r_mem[16] = 12'hFFF;
    r_mem[17] = 0;
    r_mem[18] = 0;
    r_mem[19] = 0;
    r_mem[20] = 12'hFFF;
    r_mem[21] = 0;
    r_mem[22] = 0;
    r_mem[23] = 0;
    r_mem[24] = 12'hFFF;
    r_mem[25] = 0;
    r_mem[26] = 0;
    r_mem[27] = 0;
    r_mem[28] = 12'hFFF;
    r_mem[29] = 0;
    r_mem[30] = 0;
    r_mem[31] = 0;
    r_mem[32] = 12'hFFF;
    r_mem[33] = 0;
    r_mem[34] = 0;
    r_mem[35] = 0;
    r_mem[36] = 12'hFFF;
    r_mem[37] = 0;
    r_mem[38] = 0;
    r_mem[39] = 0;
    r_mem[40] = 12'hFFF;
    r_mem[41] = 0;
    r_mem[42] = 0;
    r_mem[43] = 0;
    r_mem[44] = 12'hFFF;
    r_mem[45] = 0;
    r_mem[46] = 0;
    r_mem[47] = 0;
    r_mem[48] = 12'hFFF;
    r_mem[49] = 0;
    r_mem[50] = 0;
    r_mem[51] = 0;
    r_mem[52] = 12'hFFF;
    r_mem[53] = 0;
    r_mem[54] = 0;
    r_mem[55] = 0;
    r_mem[56] = 12'hFFF;
    r_mem[57] = 0;
    r_mem[58] = 0;
    r_mem[59] = 0;
    r_mem[60] = 12'hFFF;
    r_mem[61] = 0;
    r_mem[62] = 0;
    r_mem[63] = 0;
  end
endmodule
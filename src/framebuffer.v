module framebuffer #( 
  parameter c_ledboards = 30,
  parameter c_channels = c_ledboards * 32,
  parameter c_addr_w = $clog2(c_channels),
  parameter c_bpc = 12,
  parameter c_max_time = 480,
  parameter c_time_w = $clog2(c_max_time)
)(
  input i_clk, i_wen,
  input [c_addr_w-1:0] i_waddr, i_raddr,
  input [c_bpc-1:0] i_wdata,
  input [c_time_w-1:0] i_time, 
  output reg [c_bpc-1:0] o_rdata,
  output reg [c_time_w-1:0] o_time 
);

  reg [c_bpc-1:0] r_mem [0:c_channels-1];
  reg [c_time_w-1:0] r_time;

  always @(posedge i_clk) begin
    if (i_wen) begin
      r_mem[i_waddr] <= i_wdata;
      r_time <= i_time;
    end
    o_rdata <= r_mem[i_raddr];
    o_time <= r_time;
  end

  initial begin 
    r_mem[0]  = 12'h7FF; // R3 15
    r_mem[1]  = 0;       // G3 14
    r_mem[2]  = 0;       // B3 13
    r_mem[3]  = 0;       // W3 12
    r_mem[4]  = 0;       // R2 11
    r_mem[5]  = 12'h7FF; // G2 10
    r_mem[6]  = 0;       // B2 09
    r_mem[7]  = 0;       // W2 08
    r_mem[8]  = 0;       // R1 07
    r_mem[9]  = 0;       // G1 06
    r_mem[10] = 12'h7FF; // B1 05
    r_mem[11] = 0;       // W1 04
    r_mem[12] = 0;       // R0 03
    r_mem[13] = 0;       // G0 02
    r_mem[14] = 0;       // B0 01
    r_mem[15] = 12'h7FF; // W0 00

    r_mem[16] = 12'h7FF;
    r_mem[17] = 0;
    r_mem[18] = 0;
    r_mem[19] = 0;
    r_mem[20] = 0;
    r_mem[21] = 12'h7FF;
    r_mem[22] = 0;
    r_mem[23] = 0;
    r_mem[24] = 0;
    r_mem[25] = 0;
    r_mem[26] = 12'h7FF;
    r_mem[27] = 0;
    r_mem[28] = 0;
    r_mem[29] = 0;
    r_mem[30] = 0;
    r_mem[31] = 12'h7FF;

    r_mem[32] = 12'h7FF;
    r_mem[33] = 0;
    r_mem[34] = 0;
    r_mem[35] = 0;
    r_mem[36] = 0;
    r_mem[37] = 12'h7FF;
    r_mem[38] = 0;
    r_mem[39] = 0;
    r_mem[40] = 0;
    r_mem[41] = 0;
    r_mem[42] = 12'h7FF;
    r_mem[43] = 0;
    r_mem[44] = 0;
    r_mem[45] = 0;
    r_mem[46] = 0;
    r_mem[47] = 12'h7FF;

    r_mem[48] = 12'h7FF;
    r_mem[49] = 0;
    r_mem[50] = 0;
    r_mem[51] = 0;
    r_mem[52] = 0;
    r_mem[53] = 12'h7FF;
    r_mem[54] = 0;
    r_mem[55] = 0;
    r_mem[56] = 0;
    r_mem[57] = 0;
    r_mem[58] = 12'h7FF;
    r_mem[59] = 0;
    r_mem[60] = 0;
    r_mem[61] = 0;
    r_mem[62] = 0;
    r_mem[63] = 12'h7FF;
  end

endmodule
module demo (
  input i_clk,
  output o_clk,
  output o_dai,
  output o_lat
);

  localparam c_boards = 1;

  localparam c_frame_period = 16666; // 120 fps (@ 2 MHZ i_clk)
  localparam c_frame_max = 480;
  localparam c_channels = c_boards * 32;
  localparam c_bps = 12;

  localparam c_frame_period_1 = c_frame_period - 1;
  localparam c_frame_max_1 = c_frame_max - 1;
  localparam c_channels_1 = c_channels - 1;
  localparam c_bps_1 = c_bps - 1;

  localparam c_count_width = $clog2(c_frame_period);
  localparam c_frame_count_width = $clog2(c_frame_max);
  localparam c_channel_count_width = $clog2(c_channels);
  localparam c_bit_count_width = $clog2(c_bps);

  reg [c_count_width-1:0] r_count = 0;
  reg [c_frame_count_width-1:0] r_framecount = 0;
  reg [c_channel_count_width-1:0] r_channelcount = 0;
  reg [c_bit_count_width-1:0] r_bitcount = 0;

  localparam s_wait = 2'd0;
  localparam s_transmit = 2'd1;
  localparam s_latch = 2'd2;
  reg [1:0] r_state = s_wait; 

  reg r_clk = 0;
  reg r_dai = 0;
  reg r_lat = 0;

  always @(posedge i_clk) begin
    if (r_count == c_frame_period_1[c_count_width-1:0]) begin
      r_count <= 0;
      if (r_framecount == c_frame_max_1[c_frame_count_width-1:0]) begin
        r_framecount <= 0;
      end else begin
        r_framecount <= r_framecount + 1;
      end
    end else begin
      r_count <= r_count + 1;
    end
    case (r_state)
      s_wait: begin
        if (r_count == 0) begin
          r_channelcount <= 0;
          r_bitcount <= 0;
          r_state <= s_transmit;
        end
      end
      s_transmit: begin
        if (r_bitcount == 0 && r_channelcount == 0) begin
          r_clk <= 1;
        end
        if (r_bitcount == c_bps_1[c_bit_count_width-1:0]) begin
          if (r_channelcount == c_channels_1[c_channel_count_width-1:0]) begin
            r_state <= s_latch;
          end else begin
            r_bitcount <= 0;
            r_channelcount <= r_channelcount + 1;
          end
        end else begin
          r_bitcount <= r_bitcount + 1;
          // Rotate through the four colors
          /* verilator lint_off WIDTH */
          if ((r_channelcount % 4) == (r_framecount / (c_frame_max / 4))) begin
            r_dai <= 1;
          end else begin
            r_dai <= 0;
          end
          /* verilator lint_on WIDTH */
        end
      end
      s_latch: begin
        if (r_lat == 1) begin
          r_lat <= 0;
          r_state <= s_wait;
        end else begin
          r_clk <= 0;
          r_lat <= 1;
        end
      end
      default: begin
      end
    endcase
  end

  assign o_clk = ~i_clk & r_clk;
  assign o_dai = r_dai;
  assign o_lat = r_lat;

endmodule
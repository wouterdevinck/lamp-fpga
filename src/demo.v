module demo (
  input i_clk,
  output o_clk,
  output o_dai,
  output o_lat
);

  localparam c_frame_period = 16666;
  localparam c_frame_max = 120;

  localparam c_count_width = $clog2(c_frame_period);
  localparam c_frame_count_width = $clog2(c_frame_max);

  reg [c_count_width-1:0] r_count = 0;
  reg [c_frame_count_width-1:0] r_framecount = 0;

  localparam s_wait = 3'd0;
  localparam s_white = 3'd1;
  localparam s_blue = 3'd2;
  localparam s_green = 3'd3;
  localparam s_red = 3'd4;
  localparam s_latch = 3'd5;
  reg [2:0] r_state = s_wait; 

  always @(posedge i_clk) begin
    if (r_count == c_frame_period[c_count_width-1:0] - 1) begin
      r_count <= 0;
      if (r_framecount == c_frame_max[c_frame_count_width-1:0] - 1) begin
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
          r_state <= s_white;
        end
      end
      s_white: begin

      end
      s_blue: begin

      end
      s_green: begin

      end
      s_red: begin

      end
      s_latch: begin

      end
      default: begin
      end
    endcase
  end

endmodule
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

  always @(posedge i_clk) begin
    if (r_count == c_frame_period[c_count_width-1:0]) begin
      r_count <= 0;
      if (r_framecount == c_frame_max[c_frame_count_width-1:0]) begin
        r_framecount <= 0;
      end else begin
        r_framecount <= r_framecount + 1;
      end
    end else begin
      r_count <= r_count + 1;
    end
  end

endmodule
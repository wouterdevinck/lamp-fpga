module clk_div #( 
  parameter c_div = 2
)(
  input i_clk,
  output o_clk
);

  localparam c_width = $clog2(c_div);
  reg [c_width-1:0] r_count = 0;
  reg r_clk = 0;

  always @(posedge i_clk) begin
    if (r_count[c_width-1:0] == c_div[c_width-1:0]) begin
      r_count <= 0;
      r_clk <= !r_clk;
    end else begin
      r_count <= r_count + 1;
    end
  end

  assign o_clk = r_clk;

endmodule
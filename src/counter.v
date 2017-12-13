module counter #( 
  parameter c_max = 100,
  parameter c_width = $clog2(c_max)
)(
  input i_clk,
  output reg [c_width-1:0] o_count = 0
);

  always @(posedge i_clk) begin
    if (o_count[c_width-1:0] == c_max[c_width-1:0]) begin
      o_count <= 0;
    end else begin
      o_count <= o_count + 1;
    end
  end

endmodule
module animator #( 
  parameter c_ledboards = 30,
  parameter c_channels = c_ledboards * 32,
  parameter c_addr_w = $clog2(c_channels),
  parameter c_bpc = 12
)(
  input i_clk,
  input i_drq,
  input [c_bpc-1:0] i_target_data,
  output o_current_wen, o_target_ren,
  output [c_addr_w-1:0] o_current_addr, o_target_addr,
  output [c_bpc-1:0] o_current_data
);

  localparam c_channels_1 = c_channels - 1;

  reg [c_addr_w-1:0] r_addr = 0;

  localparam s_wait =  2'd0;
  localparam s_read =  2'd1;
  localparam s_anim =  2'd2;
  localparam s_write = 2'd3;
  reg [1:0] r_state = s_wait; 

  always @(posedge i_clk) begin
    case (r_state)
      s_wait: begin
        if (i_drq == 1'b1) begin
          r_addr <= 0;
          r_state <= s_read;
        end
      end
      s_read: begin
        r_state <= s_anim;
      end
      s_anim: begin
        r_state <= s_write;
      end
      s_write: begin
        if (r_addr == c_channels_1[c_addr_w-1:0]) begin
          r_state <= s_wait;
        end else begin
          r_addr <= r_addr + 1;
          r_state <= s_read;
        end
      end
      default: begin
      end
    endcase
  end

endmodule
module protocol /* #(
  
)*/(
  input i_clk,
  input i_dck,
  input i_cs,
  input i_mosi
);

  reg r_prev_dck = 0;

  reg [4:0] r_command = 0;
  reg [10:0] r_length = 0;
  reg [2:0] r_command_bit = 0;
  reg [3:0] r_length_bit = 0;

  reg [5:0] r_kf_type = 0;
  reg [9:0] r_kf_duration = 0;
  reg [2:0] r_kf_type_bit = 0;
  reg [3:0] r_kf_duration_bit = 0;

  reg [2:0] r_bitcount = 0;
  
  localparam s_global_wait = 2'd0;
  localparam s_global_command = 2'd1;
  localparam s_global_length = 2'd2;
  localparam s_global_execute = 2'd3;
  reg [1:0] r_global_state = s_global_wait;
  
  localparam s_keyframe_wait = 2'd0;
  localparam s_keyframe_type = 2'd1;
  localparam s_keyframe_duration = 2'd2;
  localparam s_keyframe_data = 2'd3;
  reg [1:0] r_keyframe_state = s_keyframe_wait;

  localparam c_command_keyframe = 5'd0;

  always @(posedge i_clk) begin
    if (i_cs == 0) begin
      if (i_dck != r_prev_dck) begin
        r_prev_dck = i_dck;
        if(i_dck == 1) begin
          receiveBit(i_mosi);
        end
      end
    end else begin
      r_prev_dck = 0;
      r_global_state = 0;
      r_keyframe_state = 0;
      r_command_bit = 0;
      r_length_bit = 0;
      r_kf_type_bit = 0;
      r_kf_duration_bit = 0;
    end
  end

  task receiveBit;
    input i_bit;
    begin
      case (r_global_state)
        s_global_wait: begin
          r_global_state = s_global_command;
          r_command[4] = i_bit;
          r_command_bit = 1;
        end
        s_global_command: begin
          if (r_command_bit == 4) begin
            r_global_state = s_global_length;
          end
          r_command[4 - r_command_bit] = i_bit;
          r_command_bit = r_command_bit + 1;
        end
        s_global_length: begin
          if (r_length_bit == 10) begin
            r_global_state = s_global_execute;
          end
          r_length[10 - r_length_bit] = i_bit;
          r_length_bit = r_length_bit + 1;
        end
        s_global_execute: begin
          if (r_length == 1 && r_bitcount == 6) begin
            r_global_state = s_global_wait;
          end
          if (r_bitcount == 7) begin
            r_length = r_length - 1; 
            r_bitcount = 0;
          end else begin
            r_bitcount = r_bitcount + 1;
          end
          messagePump(i_bit);
        end
        default: begin
        end
      endcase
    end
  endtask

  task messagePump;
    input i_bit;
    case (r_command)
      c_command_keyframe: begin
        receiveKeyframe(i_bit);
      end
      default: begin
      end
    endcase
  endtask

  task receiveKeyframe;
    input i_bit;
    begin
      case (r_keyframe_state)
        s_keyframe_wait: begin
          r_keyframe_state = s_keyframe_type;
          r_kf_type[5] = i_bit;
          r_kf_type_bit = 1;
        end
        s_keyframe_type: begin
          if (r_kf_type_bit == 5) begin
            r_keyframe_state = s_keyframe_duration;
          end
          r_kf_type[5 - r_kf_type_bit] = i_bit;
          r_kf_type_bit = r_kf_type_bit + 1;
        end
        s_keyframe_duration: begin
          if (r_kf_duration_bit == 9) begin
            r_keyframe_state = s_keyframe_data;
          end
          r_kf_duration[9 - r_kf_duration_bit] = i_bit;
          r_kf_duration_bit = r_kf_duration_bit + 1;
        end
        s_keyframe_data: begin
          // TODO pump keyframe data into framebuffer
        end
        default: begin
        end
      endcase
    end
  endtask

endmodule
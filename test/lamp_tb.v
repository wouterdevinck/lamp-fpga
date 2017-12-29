`timescale 1us/1ns
`include "lamp.v"

module lamp_tb();

  reg r_clk;
  wire w_clk;
  wire w_dai;
  wire w_lat;
 
  lamp #(
    .c_freq (20000000) // 20 Mhz
  ) lamp (
    .i_clk (r_clk),
    .o_clk (w_clk),
    .o_dai (w_dai),
    .o_lat (w_lat)
  );

  initial begin
    r_clk = 0;
  end 
 
  always begin
    #0.025 r_clk = !r_clk; // 20 MHz
  end

  always begin
    #100000 $display($time, " 100 ms have passed");
  end


  reg [c_bpc-1:0] r_data = 0;

  initial begin
    $dumpfile("lamp.vcd");
    $dumpvars(0, lamp_tb);

    #2 calculate(
      c_anim_linear,
      10, 80, 
      5, 5, 10, 
      r_data
    );
    #3 $display(r_data);

    #4 calculate(
      c_anim_linear,
      10, 80, 
      5, 5, 4, 
      r_data
    );
    #5 $display(r_data);

    #100000 $finish;
  end

  localparam c_anim_linear =  1'd1; 
  localparam c_max_time = 11;
  localparam c_bpc = 12;
  localparam c_time_w = $clog2(c_max_time);
  localparam c_max_time_1 = c_max_time - 1;

  task calculate;

    input [0:0] i_anim_type;
    input [c_bpc-1:0] i_current_data;
    input [c_bpc-1:0] i_target_data; 
    input [c_time_w-1:0] i_start_time;
    input [c_time_w-1:0] i_current_time;
    input [c_time_w-1:0] i_target_time;
    output [c_bpc-1:0] o_data;

    begin
      case (i_anim_type) 
        c_anim_linear: begin
          /*o_data = i_current_data + (
                   (i_target_data - i_current_data) / 
                   ((i_target_time < i_current_time) ? 
                   (c_max_time - i_current_time + i_target_time) : 
                   (i_target_time - i_current_time)));*/
          if (i_target_time < i_current_time) begin
            o_data = i_current_data + (i_target_data - i_current_data) / 
                     (c_max_time - i_current_time + i_target_time);
          end else begin
            o_data = i_current_data + (i_target_data - i_current_data) / 
                     (i_target_time - i_current_time);
          end
        end
        default: begin
        end
      endcase
    end

  endtask
   
endmodule
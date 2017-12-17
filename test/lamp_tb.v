`timescale 1us/1ns
`include "lamp.v"

module lamp_tb();

  reg r_clk;
  wire w_led1;
  wire w_led2;
  wire w_clk;
  wire w_dai;
  wire w_lat;
 
  lamp #(
    .c_freq (20000000) // 20 Mhz
  ) lamp (
    .i_clk (r_clk),
    .o_led1 (w_led1),
    .o_led2 (w_led2),
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

  initial begin
    $dumpfile("lamp.vcd");
    $dumpvars(0, lamp_tb);
    #100000 $finish;
  end
   
endmodule
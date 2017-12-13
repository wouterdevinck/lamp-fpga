`timescale 1us/10ns
`include "lamp.v"

module lamp_tb();

  reg r_clk;
  wire w_led1;
  wire w_led2;
 
  lamp #(
    .c_freq (2000000) // 2 Mhz
  ) lamp (
    .i_clk (r_clk),
    .o_led1 (w_led1),
    .o_led2 (w_led2)
  );

  initial begin
    r_clk = 0;
  end 
 
  always begin
    #0.25 r_clk = !r_clk; // 2 MHz
  end

  always begin
    #1000000 $display($time, " A second has passed");
  end

  initial begin
    $dumpfile("lamp.vcd");
    $dumpvars(0, lamp_tb);
    #5000000 $finish; // 5 seconds
  end
   
endmodule
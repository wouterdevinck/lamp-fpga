`timescale 1us/10ns
`include "lamp.v"

module lamp_tb();

  reg r_clk;
  wire w_led1;
  wire w_led2;
 
  lamp #(
    .c_freq (10000000) // 10 Mhz
  ) lamp (
    .i_clk (r_clk),
    .o_led1 (w_led1),
    .o_led2 (w_led2)
  );

  initial begin
    r_clk = 0;
  end 
 
  always begin
    #0.05 r_clk = !r_clk; // 10 MHz
  end

  always begin
    #100000 $display($time, " 100 ms have passed");
  end

  initial begin
    $dumpfile("lamp.vcd");
    $dumpvars(0, lamp_tb);
    #1000000 $finish;
  end
   
endmodule
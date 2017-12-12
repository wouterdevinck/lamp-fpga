`include "lamp.v"

module lamp_tb();

  wire w_clk;
  wire w_led1;
  wire w_led2;
   
  lamp lamp (
    .i_clk100M (w_clk),
    .o_led1 (w_led1),
    .o_led2 (w_led2)
  );

  //initial begin
  //  w_clk = 0; 
  //end 
 
  //always  
  //  #5 w_clk = !w_clk;
   
  // TODO

  initial begin
    $dumpfile("lamp.vcd");
    $dumpvars(0, lamp_tb);

    $finish;
  end
   
endmodule
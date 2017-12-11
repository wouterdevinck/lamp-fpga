`include "../src/lamp.v"

module lamp_tb();

  reg i_clk100M;
  reg o_led1;
  reg o_led2;
   
  lamp lamp (
    .i_clk100M (i_clk100M),
    .o_led1 (o_led1),
    .o_led2 (o_led2)
  );

  initial begin
    i_clk100M = 0; 
  end 
 
  always  
    #5 i_clk100M = !i_clk100M; 
   
  // TODO

  initial begin

    $finish;
  end
   
endmodule
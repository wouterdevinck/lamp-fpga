module protocol /* #(
  
)*/(
  input i_clk,
  input i_dck,
  input i_cs,
  input i_mosi
);

  reg r_pdck = 0;

  reg r_data = 0; // test

  always @(posedge i_clk) begin
    if (i_cs == 0) begin
      if (i_dck != r_pdck) begin
        r_pdck = i_dck;
        if(i_dck == 1) begin
        
          r_data = i_mosi; // test

        end
      end
    end
  end

endmodule
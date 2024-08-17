module Comparator(
    input wire [15:0] held_value,
    input wire [15:0] dac_out,
    output reg comparator_out
);
 always @(*) begin
 if(held_value>dac_out) comparator_out=1'b1;
 else comparator_out=1'b0;
 end
   
endmodule
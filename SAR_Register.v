module SAR_Register (
    input clk,
    input rst,
    input comparator_out,
    output [15:0] sar_value
);
  
    reg [15:0] comp = 16'h8000;
    reg [3:0] ptr = 4'b1111;
  
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ptr <= 4'b1111;
            comp <= 16'h8000;
        end else begin
            if (comparator_out) begin
                comp[ptr] <= 1'b1;
            end else begin
                comp[ptr] <= 1'b0;
            end
            if (ptr > 0) begin
                ptr <= ptr - 1;
                comp[ptr - 1] <= 1'b1;
            end
        end
    end
  
    assign sar_value = comp;
endmodule

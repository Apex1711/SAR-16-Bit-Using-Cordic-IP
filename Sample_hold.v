module SampleAndHold(
    input wire clk,
    input wire [15:0] analog_in,
    output reg [15:0] held_value
);
    always @(posedge clk) begin
            held_value <= analog_in;
            $display("Sampled Held Value: %d", held_value);
        end
endmodule
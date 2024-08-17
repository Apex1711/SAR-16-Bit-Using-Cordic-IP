module DAC(
    input wire [15:0] sar_value,
    output wire [15:0] dac_out
);
    assign dac_out = sar_value; // Ideal DAC, direct mapping
endmodule
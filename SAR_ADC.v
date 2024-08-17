module SAR_ADC(
    input wire clk,
    input wire reset,
    input [15:0] analog_in,
    output [15:0] digital_out
);
    wire [15:0] held_value;
    wire [15:0] sar_value;
    wire [15:0] dac_out;
    wire comparator_out;

    reg shift;

    // Instantiate the sample and hold circuit
    SampleAndHold sh(
        .clk(clk),
        .analog_in(analog_in),
        .held_value(held_value)
    );

    // Instantiate the SAR register
    SAR_Register sar(
        .clk(clk),
        .rst(reset),
        .comparator_out(comparator_out),
        .sar_value(sar_value)
    );

    //Instantiate the comparator
    Comparator comp(
        .held_value(held_value),
        .dac_out(dac_out),
        .comparator_out(comparator_out)
    );
    
    DAC dac(
            .sar_value(sar_value),
            .dac_out(dac_out)
        );

    // Assign the output of the SAR ADC
    assign digital_out = sar_value;

endmodule
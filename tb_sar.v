`timescale 10ps/1ps

module tb_SAR_ADC;
    reg clk;
    reg reset;
    reg start;
    wire [15:0] digital_out;
    wire [15:0] analog_in;
    reg reset_2;

    SAR_ADC uut (
    .analog_in(analog_in),
        .clk(clk),
        .reset(reset),
        .digital_out(digital_out)
    );
    localparam signed [15:0] PI_POS = 16'b0110_0100_1000_1000;
    localparam signed [15:0] PI_NEG = 16'b1001_1011_0111_1000;
    localparam PHASE_INC = 256;

    reg signed [15:0] phase = 0;
    reg phase_tvalid = 1'b0;
    wire [15:0] cos;
    wire sincos_tvalid;
    reg clk_sine = 1'b0;

    SineWaveGenerator sine_gen (
        .clk(clk_sine),
        .phase(phase),
        .phase_tvalid(phase_tvalid),
        .cos(cos),
        .analog_in(analog_in),
        .sincos_tvalid(sincos_tvalid)
    );
    always #1 clk = ~clk;
    always #16 clk_sine = ~clk_sine; 
    always @(posedge clk_sine)begin reset=1; #1 reset=0; end
    
    
    initial begin

        clk = 0;
        clk_sine = 0;
        reset = 0;
        #3 reset = 1; reset_2=1;
        start = 0;
        #5000;
        $finish;
    end

   initial begin
        $monitor("SAR Value: %d, Held Value: %d, DAC Out: %d, Comparator Out: %d, Analog In: %d", 
                  uut.sar.sar_value, uut.sh.held_value, uut.dac_out, uut.comparator_out, uut.analog_in);
    end

    initial begin
        phase = 0;
        phase_tvalid = 1'b0;
        #20 reset_2=0;
    end

    always @(posedge clk_sine) begin
        if (reset_2) begin
            phase <= 0;
            phase_tvalid <= 1'b0;
        end else begin
            phase_tvalid <= 1'b1;
            if (phase + PHASE_INC < PI_POS)
                phase <= phase + PHASE_INC;
            else
                phase <= PI_NEG;
        end
    end
endmodule
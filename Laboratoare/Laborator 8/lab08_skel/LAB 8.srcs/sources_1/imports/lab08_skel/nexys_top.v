// must declare BTN and SW as "inout" because, when assigning
// them to porta/portb, XST is complaining that those are
// inout as well, and nobody guarantees it that someone won't
// be driving an output into a wire declared as input.
module nexys_top (
        // Clock sources
        input  wire       clk, // Primary oscillator, Linear Tech. LTC6905 Oscillator
        // User I/O
        inout  wire [4:0] BTN,     // non-debounced push-buttons, active high
        output wire [7:0] LED,     // green LEDs, active high
        inout  wire [7:0] SW       // slide switches
    );

    assign LED[6:0] = 7'b1111111;

    cpu #(
        .INSTR_WIDTH     (16),
        .DATA_WIDTH      (8),
        .I_ADDR_WIDTH    (10),
        .ADDR_WIDTH      (16),
        .D_ADDR_WIDTH    (7),
        .IO_ADDR_WIDTH   (6),
        .R_ADDR_WIDTH    (5),
        .RST_ACTIVE_LEVEL(1)
    ) avr (
        .osc_clk    (clk),
        .reset      (SW[7]),
        .trace_mode (SW[6]),
        .trace_clk  (SW[5]),
        .prescaler  (SW[4:0]), // HOW_TO_USE_PRESCALER
        .pb         (),
        .pa         (),
        .oc0a       (LED[7]),
        .oc0b       (),
        .debug_pc   (),
        .debug_state()
    );

endmodule

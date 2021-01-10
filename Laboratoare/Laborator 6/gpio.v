`include "defines.vh"
module io_sram #(
        parameter   DATA_WIDTH = 8,
        parameter   ADDR_WIDTH = 6,  // 64 I/O registers
		  parameter I_ADDR_WIDTH = 10  // 1024 valid instructions
    )(
        // to host cpu
        input  wire                    clk,
        input  wire                    reset,
        input  wire                    oe,
        input  wire                    cs,
        input  wire                    we,
        input  wire   [ADDR_WIDTH-1:0] address,
        inout  wire   [DATA_WIDTH-1:0] data,
        // to external pins
        inout  wire   [DATA_WIDTH-1:0] pa,
        inout  wire   [DATA_WIDTH-1:0] pb
    );

    reg  [DATA_WIDTH-1:0] memory[0:(1<<ADDR_WIDTH)-1];
    reg  [ADDR_WIDTH-1:0] addr_buf;
    wire                  readonly;
    wire [DATA_WIDTH-1:0] pa_buf;
    wire [DATA_WIDTH-1:0] pb_buf;
    reg    [ADDR_WIDTH:0] i;

    always @(negedge clk)
    begin
        if (reset) begin
            for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
                memory[i] <= 0;
            end
        end
        else if (cs) begin
            if (we && !readonly) begin
                memory[address] <= data;
            end else begin
                addr_buf <= address;
            end
        end
        memory[`PINA]  <= pa;     // taken directly from external pin
        memory[`PINB]  <= pb;     // taken directly from external pin
       
    end

    assign data = (cs && oe && !we) ? memory[addr_buf] : {DATA_WIDTH{1'bz}};
    assign readonly = (address == `PINA || address == `PINB);

    assign pa = pa_buf;    // directly to external pin
    assign pb = pb_buf;    // directly to external pin


    gpio_unit #(
        .DATA_WIDTH(DATA_WIDTH)
    ) gpio (
        .clk      (clk),
        .reset    (reset),
        .mem_ddra (memory[`DDRA]),
        .mem_ddrb (memory[`DDRB]),
        .mem_porta(memory[`PORTA]),
        .mem_portb(memory[`PORTB]),
        .pa_buf   (pa_buf),
        .pb_buf   (pb_buf)
    );
endmodule


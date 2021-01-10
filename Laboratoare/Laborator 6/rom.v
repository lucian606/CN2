module rom #(
        parameter   DATA_WIDTH = 16,
        parameter   ADDR_WIDTH = 8          // 2 * 1024 bytes of ROM
    )(
        input  wire                  clk,
        input  wire [ADDR_WIDTH-1:0] addr,  // here comes the program counter
        output  reg [DATA_WIDTH-1:0] data   // here goes the instruction
    );

    reg [DATA_WIDTH-1:0] value;

    always @* begin
        case (addr)
		  	// Checker ex 1 si ex 2
			/*	 ldi 	r28, 3 		*/
			0:		value = 16'b1110000011000011;
			/*	 out 	0x06, r28 		*/
			1:		value = 16'b1011100111000110;
			/*	 in 	r17, 0x06 		*/
			2:		value = 16'b1011000100010110;
			
			default:		value = 16'b0000000000000000;

        endcase
    end

    always @(negedge clk) begin
        data <= value;
    end

endmodule

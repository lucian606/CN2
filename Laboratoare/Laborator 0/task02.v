module task02(
	output reg serial_out,
	input serial_in,
	input clk,
	input reset
);
    reg [7:0] memory;
    always @ (posedge clk) begin
        if (reset == 1'b1) begin
            memory = 8'b00000000;
            memory[0] = serial_in;
        end
        else begin
            memory = memory << 1;
            memory[0] = serial_in;
        end
	// TODO
	   serial_out = memory[7];
    end
endmodule



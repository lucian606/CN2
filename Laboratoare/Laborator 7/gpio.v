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


    reg [DATA_WIDTH-1:0] pa_buf; //buffer pentru porta
    reg [DATA_WIDTH-1:0] pb_buf;	//buffer pentru portb
    reg    [ADDR_WIDTH:0] i;

	 always @(posedge clk) begin

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


        for (i = 0; i < DATA_WIDTH; i = i + 1) begin

				/* Atentie! Elementele urmatoare sunt expuse pentru Portul A,
				dar sunt valabile si trebuie aplicate, de asemenea, pt Portul B.

				Amintim ca:
					DDRA - seteaza directia pinilor, deci:
						DDRA[5] == 0 inseamna ca de pe pinul 5 al portului A se citeste.
						DDRA[3] == 1 inseamna ca pe pinul 3 al portului A se scrie.
						PORTA[3] acest bit seteaza valoarea pinului 3, daca DDRA[3] == 1 (altfel nu are efect).
						PINA[6] ne spune valoarea de pe pinul 6 (PA6)
				*/

				/* TODO 1:
					Pentru fiecare bit, daca DDRA este setat pt citire, stocam valoarea din porta in memorie.
					(In ce registru o stocam? De unde CITIM valoarea unui pin?).
					Daca DDRA este setata pt scriere, stocam in porta_buffer valoare ce vrem sa fie pusa pe pin.
					(Cu ce registru setam VALOAREA ce vrem sa fie pusa pe pin? )

					Completeaza codul comentat de mai jos.
				*/
				

				if (memory[`DDRA][i] == 0) begin
					memory[`PINA][i] <= pa[i];						// Change this
				end else begin
					pa_buf[i] <= memory[`PORTA][i];									// Change this
				end
				

				/*TODO1: Asemeni si pt Portul B.*/
				if (memory[`DDRB][i] == 0) begin
					memory[`PINB][i] <= pb[i];						// Change this
				end else begin
					pb_buf[i] <= memory[`PORTB][i];									// Change this
				end
        end


    end

	 assign data = (cs && oe && !we) ? memory[addr_buf] : {DATA_WIDTH{1'bz}};
    assign readonly = (address == `PINA || address == `PINB);

    /* TODO 1: Asignati valori de iesire pentru fiecare pin (individual) din  porta si portb.
		Daca bitul corespunzator din DDRA este setat, vom asigna lui porta valoarea bit-ului din
		bufferul lui porta (declarate la linia 31), altfel pinul va avea 'impedanta marita' (1'bz).
	 */
	// Exemplu:
	// assign pa[0] = memory[`DDRA][0] ? pa_buf[0] : 1'bz;
	always @(posedge clk) begin
        if (reset)
        begin
            pa_buf <= 0;
            pb_buf <= 0;
        end
        else
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : gen_ports
            pa_buf[i] <= memory[`DDRA][i] ? memory[`DDRA][i] : 1'bz;
            pb_buf[i] <= memory[`DDRB][i] ? memory[`DDRB][i] : 1'bz;
        end
    end

endmodule


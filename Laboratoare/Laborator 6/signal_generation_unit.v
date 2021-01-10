`include "defines.vh"
module signal_generation_unit (
        input  wire  [`STAGE_COUNT-1:0] pipeline_stage,
        input  wire [`OPCODE_COUNT-1:0] opcode_type,
        input  wire  [`GROUP_COUNT-1:0] opcode_group,
        output wire [`SIGNAL_COUNT-1:0] signals
    );

    /* Control signals */

    /* Register interface logic */
    // TODO2: Ce alt grup citeste din RR?
    assign signals[`CONTROL_REG_RR_READ] = 
            (pipeline_stage == `STAGE_ID) &&
            (opcode_group[`GROUP_ALU_TWO_OP] || opcode_group[`GROUP_LOAD_INDIRECT] || opcode_group[`GROUP_REGISTER] || opcode_group[`GROUP_STORE]
					  || 
					  opcode_group[`GROUP_IO_WRITE]				// Change this
					  );
    assign signals[`CONTROL_REG_RR_WRITE] = 0;
    assign signals[`CONTROL_REG_RD_READ] =
            (pipeline_stage == `STAGE_ID) &&
            (opcode_group[`GROUP_ALU] || 
             opcode_group[`GROUP_ALU_IMD] ||
             opcode_group[`GROUP_STORE_INDIRECT] ||   // X, Y sau Z
             opcode_group[`GROUP_LOAD_INDIRECT]);
    // TODO2: Ce alt grup scrie in RD?
    assign signals[`CONTROL_REG_RD_WRITE] = 
            (pipeline_stage == `STAGE_WB) &&
            (opcode_group[`GROUP_ALU] || opcode_group[`GROUP_REGISTER] || opcode_group[`GROUP_LOAD] 
						|| 
						opcode_group[`GROUP_IO_READ]				// Change this
						);

    /* Memory interface logic */
    assign signals[`CONTROL_MEM_READ] =
           (pipeline_stage == `STAGE_MEM) &&
           opcode_group[`GROUP_LOAD];
    assign signals[`CONTROL_MEM_WRITE] =
           (pipeline_stage == `STAGE_MEM) &&
           opcode_group[`GROUP_STORE];

    /* IO interface logic */
    // TODO2: Ce grupuri declanseaza aceste doua semnale? 
    assign signals[`CONTROL_IO_READ] = 
			opcode_group[`GROUP_IO_READ]				// Change this
			;
    assign signals[`CONTROL_IO_WRITE] =
			opcode_group[`GROUP_IO_WRITE]				// Change this
			;
endmodule

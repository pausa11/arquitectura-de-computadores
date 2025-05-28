// ImmediateGenerator.sv
// Generador de inmediatos para un procesador RISC-V de 32 bits
// Recibe los 25 bits superiores de la instrucción (bits[31:7]) y el opcode
// para extraer y extender correctamente el inmediato.

module ImmediateGenerator (
    input  logic [24:0] instr25,   // Bits[31:7] de la instrucción
    input  logic [6:0]  opcode,    // opcode para seleccionar formato
    output logic [31:0] imm_out    // Inmediato extendido a 32 bits
);

    // Opcodes RISC-V para formatos inmediatos
    localparam [6:0]
        OP_ITYPE  = 7'b0010011,  // I-type ALU (ADDI...)
        OP_LW     = 7'b0000011,  // Load Word (I-type)
        OP_JALR   = 7'b1100111,  // JALR (I-type)
        OP_STORE  = 7'b0100011,  // S-type
        OP_BRANCH = 7'b1100011,  // B-type
        OP_LUI    = 7'b0110111,  // U-type LUI
        OP_AUIPC  = 7'b0010111,  // U-type AUIPC
        OP_JAL    = 7'b1101111;  // J-type

    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

    always_comb begin
        // I-type: instr25[24:13] = instr[31:20]
        imm_i = {{20{instr25[24]}}, instr25[24:13]};
        // S-type: instr25[24:18]=instr[31:25], instr25[4:0]=instr[11:7]
        imm_s = {{20{instr25[24]}}, instr25[24:18], instr25[4:0]};
        // B-type: instr25[24]=instr[31], instr25[0]=instr[7], instr25[23:18]=instr[30:25], instr25[4:1]=instr[11:8]
        imm_b = {{19{instr25[24]}}, instr25[24], instr25[0], instr25[23:18], instr25[4:1], 1'b0};
        // U-type: instr25[24:5]=instr[31:12]
        imm_u = {instr25[24:5], 12'd0};
        // J-type: instr25[24]=instr[31], instr25[12:5]=instr[19:12], instr25[13]=instr[20], instr25[23:14]=instr[30:21]
        imm_j = {{11{instr25[24]}}, instr25[24], instr25[12:5], instr25[13], instr25[23:14], 1'b0};

        unique case (opcode)
            OP_ITYPE, OP_LW, OP_JALR: imm_out = imm_i;
            OP_STORE:               imm_out = imm_s;
            OP_BRANCH:              imm_out = imm_b;
            OP_LUI, OP_AUIPC:       imm_out = imm_u;
            OP_JAL:                 imm_out = imm_j;
            default:                imm_out = 32'd0;
        endcase
    end

endmodule

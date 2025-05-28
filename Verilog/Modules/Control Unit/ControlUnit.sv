// ControlUnit.sv
// Unidad de control principal para un procesador RISC-V de 32 bits
// Genera señales de control basadas en opcode. Los campos funct3 y funct7
// se pasan al módulo ALUControl para determinar la operación precisa de la ALU.

module ControlUnit (
    input  logic [6:0]  opcode,    // Campo opcode de la instrucción
    input  logic [2:0]  funct3,    // Campo funct3 (no usado aquí, para ALUControl)
    input  logic [6:0]  funct7,    // Campo funct7 (no usado aquí, para ALUControl)
    output logic        RegWrite,  // Escribir en el banco de registros
    output logic        MemRead,   // Leer de memoria de datos
    output logic        MemWrite,  // Escribir en memoria de datos
    output logic        MemToReg,  // Seleccionar dato para write-back
    output logic [1:0]  ALUOp,     // Control de la ALU (00: add/sub para load/store, 01: sub para branch, 10: usar funct)
    output logic        ALUSrc,    // Segundo operando ALU: 0=rs2, 1=inmediato
    output logic        Branch,    // Señal de branch condicional
    output logic        Jump,      // Señal de salto incondicional (JAL/JALR)
    output logic        Lui,       // Señal para cargar inmediato alto (LUI)
    output logic        Auipc     // Señal para adicionar PC a inmediato (AUIPC)
);

    // Definición de opcodes RISC-V
    localparam [6:0]
        OP_RTYPE  = 7'b0110011,  // R-type
        OP_ITYPE  = 7'b0010011,  // I-type ALU (ADDI, etc.)
        OP_LW     = 7'b0000011,  // Load Word
        OP_SW     = 7'b0100011,  // Store Word
        OP_BRANCH = 7'b1100011,  // Branches
        OP_JAL    = 7'b1101111,  // Jump and Link
        OP_JALR   = 7'b1100111,  // Jump and Link Register
        OP_LUI    = 7'b0110111,  // Load Upper Immediate
        OP_AUIPC  = 7'b0010111;  // Add Upper Immediate to PC

    // Lógica combinacional de control
    always_comb begin
        // Valores por defecto
        RegWrite  = 1'b0;
        MemRead   = 1'b0;
        MemWrite  = 1'b0;
        MemToReg  = 1'b0;
        ALUSrc    = 1'b0;
        ALUOp     = 2'b00;
        Branch    = 1'b0;
        Jump      = 1'b0;
        Lui       = 1'b0;
        Auipc     = 1'b0;

        unique case (opcode)
            OP_RTYPE: begin        // Operaciones register-register
                RegWrite = 1'b1;
                ALUSrc   = 1'b0;
                ALUOp    = 2'b10;   // ALUControl con funct3/funct7
            end
            OP_ITYPE: begin        // ALU con inmediato (ADDI, SLTI)
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b10;
            end
            OP_LW: begin           // Load
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemToReg = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;   // add para direccion
            end
            OP_SW: begin           // Store
                MemWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;
            end
            OP_BRANCH: begin       // Branch condicional
                Branch   = 1'b1;
                ALUOp    = 2'b01;   // sub para comparar
            end
            OP_JAL: begin          // JAL
                RegWrite = 1'b1;
                Jump     = 1'b1;
                MemToReg = 1'b0;    // PC+4
            end
            OP_JALR: begin         // JALR
                RegWrite = 1'b1;
                Jump     = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;   // add para direccion
                MemToReg = 1'b0;
            end
            OP_LUI: begin          // LUI
                RegWrite = 1'b1;
                Lui      = 1'b1;
                MemToReg = 1'b0;
            end
            OP_AUIPC: begin        // AUIPC
                RegWrite = 1'b1;
                Auipc    = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;
                MemToReg = 1'b0;
            end
            default: begin
                // Opcodes no soportados: señales en 0
            end
        endcase
    end
endmodule

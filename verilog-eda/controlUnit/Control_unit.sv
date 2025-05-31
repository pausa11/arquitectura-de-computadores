module Control_unit (
    input  logic [6:0]  OpCode,       // Código de operación
    input  logic [2:0]  Funct3,       // Función 3 bits
    input  logic [6:0]  Funct7,       // Función 7 bits
    output logic        RUWr,        // Registro write enable
    output logic [2:0]  ImmSrc,      // Fuente de inmediato
    output logic        AluASrc,     // ALU A source select
    output logic        AluBSrc,     // ALU B source select
    output logic [4:0]  BrOp,        // Branch operation
    output logic [3:0]  ALUOp,       // ALU operation
    output logic        DMWr,        // Data memory write enable
    output logic [2:0]  DMCtrl,      // Data memory control
    output logic [1:0]  RUDataWrSrc  // Register write data source
);

    //------------------------------------------------------------------------------
    // Señales intermedias y valor por defecto
    //------------------------------------------------------------------------------
    always_comb begin
        // Inicialización de salidas
        RUWr         = 1'b0;
        ImmSrc       = 3'b000;
        AluASrc      = 1'b0;
        AluBSrc      = 1'b0;
        BrOp         = 5'b00000;
        ALUOp        = 4'b0000;
        DMWr         = 1'b0;
        DMCtrl       = 3'b000;
        RUDataWrSrc  = 2'b00;

        //--------------------------------------------------
        // Tipo de instrucción según OpCode
        //--------------------------------------------------
        unique case (OpCode)
            7'b0110011: begin // R-type
                RUWr = 1'b1;
            end
            7'b0010011: begin // I-type (arith)
                RUWr     = 1'b1;
                AluBSrc  = 1'b1;
            end
            7'b0000011: begin // I-type (load)
                RUWr         = 1'b1;
                AluBSrc      = 1'b1;
                RUDataWrSrc  = 2'b01;
            end
            7'b1100111: begin // I-type (jalr)
                RUWr         = 1'b1;
                AluBSrc      = 1'b1;
                BrOp         = 5'b10000;
                RUDataWrSrc  = 2'b10;
            end
            7'b1100011: begin // B-type (branch)
                ImmSrc  = 3'b101;
                AluASrc = 1'b1;
                AluBSrc = 1'b1;
            end
            7'b0100011: begin // S-type (store)
                ImmSrc  = 3'b001;
                AluBSrc = 1'b1;
                DMWr    = 1'b1;
            end
            7'b1101111: begin // J-type (jal)
                RUWr         = 1'b1;
                ImmSrc       = 3'b110;
                AluASrc      = 1'b1;
                AluBSrc      = 1'b1;
                BrOp         = 5'b10000;
                RUDataWrSrc  = 2'b10;
            end
            7'b0110111: begin // U-type (lui)
                RUWr    = 1'b1;
                ImmSrc  = 3'b010;
                AluBSrc = 1'b1;
                ALUOp   = 4'b0111;
            end
            7'b0010111: begin // U-type (auipc)
                RUWr         = 1'b1;
                ImmSrc       = 3'b010;
                AluASrc      = 1'b1;
                AluBSrc      = 1'b1;
                BrOp         = 5'b10000;
                RUDataWrSrc  = 2'b10;
            end
            default: begin
                // mantener valores por defecto
            end
        endcase

        //------------------------------------------------------------------------------
        // ALUOp para R-type
        //------------------------------------------------------------------------------
        if (OpCode == 7'b0110011) begin
            unique case ({Funct3, Funct7})
                10'b0000000000: ALUOp = 4'b0000; // ADD
                10'b0000100000: ALUOp = 4'b1000; // SUB
                10'b0010000000: ALUOp = 4'b0001; // SLL
                10'b0100000000: ALUOp = 4'b0010; // SLT
                10'b0110000000: ALUOp = 4'b0011; // SLTU
                10'b1000000000: ALUOp = 4'b0100; // XOR
                10'b1010000000: ALUOp = 4'b0101; // SRL
                10'b1010100000: ALUOp = 4'b1101; // SRA
                10'b1100000000: ALUOp = 4'b0110; // OR
                10'b1110000000: ALUOp = 4'b0111; // AND
                default:        ALUOp = 4'b0000;
            endcase
        end

        //------------------------------------------------------------------------------
        // ALUOp para I-type arith (addi, slli, ...)
        //------------------------------------------------------------------------------
        if (OpCode == 7'b0010011) begin
            unique case (Funct3)
                3'b000: ALUOp = 4'b0000; // ADDI
                3'b001: ALUOp = 4'b0001; // SLLI
                3'b010: ALUOp = 4'b0010; // SLTI
                3'b011: ALUOp = 4'b0011; // SLTIU
                3'b100: ALUOp = 4'b0100; // XORI
                3'b101: begin            // SRLI/SRAI
                    ALUOp = (Funct7[6]) ? 4'b1101 : 4'b0101;
                end
                3'b110: ALUOp = 4'b0110; // ORI
                3'b111: ALUOp = 4'b0111; // ANDI
                default: ALUOp = 4'b0000;
            endcase
        end

        //------------------------------------------------------------------------------
        // BrOp para B-type condicional
        //------------------------------------------------------------------------------
        if (OpCode == 7'b1100011) begin
            unique case (Funct3)
                3'b000: BrOp = 5'b01000; // BEQ
                3'b001: BrOp = 5'b01001; // BNE
                3'b100: BrOp = 5'b01100; // BLT
                3'b101: BrOp = 5'b01101; // BGE
                3'b110: BrOp = 5'b01110; // BLTU
                3'b111: BrOp = 5'b01111; // BGEU
                default: BrOp = 5'b00000;
            endcase
        end

        //------------------------------------------------------------------------------
        // DMCtrl para loads/stores
        //------------------------------------------------------------------------------
        if (OpCode == 7'b0000011 || OpCode == 7'b0100011) begin
            unique case (Funct3)
                3'b000: DMCtrl = 3'b000; // LB/SB
                3'b001: DMCtrl = 3'b001; // LH/SH
                3'b010: DMCtrl = 3'b010; // LW/SW
                3'b100: DMCtrl = 3'b100; // LBU
                3'b101: DMCtrl = 3'b101; // LHU
                default: DMCtrl = 3'b000;
            endcase
        end
    end

endmodule

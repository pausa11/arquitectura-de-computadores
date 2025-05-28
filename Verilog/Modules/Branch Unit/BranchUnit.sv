// BranchUnit.sv
// Unidad de control de saltos (branch) para un procesador de 32 bits

module BranchUnit (
    input  logic [31:0] rs1,       // Valor de registro fuente 1
    input  logic [31:0] rs2,       // Valor de registro fuente 2
    input  logic [4:0]  BrOp,      // Código de operación de branch/jump
    output logic        NextPCSrc  // Señal: 1 si se toma el salto
);

    // Definición de códigos de operación
    localparam [4:0]
        BEQ   = 5'b01000,  // Branch if equal
        BNE   = 5'b01001,  // Branch if not equal
        BLT   = 5'b01100,  // Branch if less than (signed)
        BGE   = 5'b01101,  // Branch if greater or equal (signed)
        BLTU  = 5'b01110,  // Branch if less than (unsigned)
        BGEU  = 5'b01111,  // Branch if greater or equal (unsigned)
        JMP   = 5'b1zzzz;  // Jump incondicional (placeholder, usa casez)

    // Lógica combinacional para decidir si tomar el branch/jump
    always_comb begin
        unique casez (BrOp)
            BEQ:   NextPCSrc = (rs1 == rs2);
            BNE:   NextPCSrc = (rs1 != rs2);
            BLT:   NextPCSrc = ($signed(rs1) < $signed(rs2));
            BGE:   NextPCSrc = ($signed(rs1) >= $signed(rs2));
            BLTU:  NextPCSrc = (rs1 < rs2);
            BGEU:  NextPCSrc = (rs1 >= rs2);
            JMP:   NextPCSrc = 1'b1;  // Cubre cualquier código que empiece con '1'
            default: NextPCSrc = 1'b0; // No saltar
        endcase
    end

endmodule
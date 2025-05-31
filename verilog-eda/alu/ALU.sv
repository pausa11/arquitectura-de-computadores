module ALU (
    input  logic [31:0] A,        // Operando A
    input  logic [31:0] B,        // Operando B
    input  logic  [3:0] ALUOp,    // Código de operación
    output logic [31:0] Alu_out   // Resultado
);

    //------------------------------------------------------------------------------
    // Lógica combinacional de la ALU
    //------------------------------------------------------------------------------
    always_comb begin
        unique case (ALUOp)
            4'b0000: Alu_out = A + B;                              // ADD
            4'b1000: Alu_out = A - B;                              // SUB
            4'b0001: Alu_out = A << B[4:0];                        // SLL
            4'b0010: Alu_out = {31'b0, A <  B};                    // SLT (signed)
            4'b0011: Alu_out = {31'b0, $unsigned(A) < $unsigned(B)}; // SLTU (unsigned)
            4'b0100: Alu_out = A ^ B;                              // XOR
            4'b0101: Alu_out = A >> B[4:0];                        // SRL
            4'b1101: Alu_out = A >>> B[4:0];                       // SRA
            4'b0110: Alu_out = A | B;                              // OR
            4'b0111: Alu_out = A & B;                              // AND
            default: Alu_out = 32'b0;                              // NOP
        endcase
    end

endmodule

// ArithmeticLogicUnit.sv
// ALU de 32 bits con operaciones combinacionales definidas por ALUOp

module ArithmeticLogicUnit (
    input  logic [31:0] A,        // Operando A
    input  logic [31:0] B,        // Operando B
    input  logic [3:0]  ALUOp,    // Código de operación
    output logic [31:0] ALURes    // Resultado de la ALU
);

    // Definición de códigos de operación (pueden ajustarse según ISA)
    localparam [3:0]
        OP_ADD   = 4'b0000,  // Suma A + B
        OP_SUB   = 4'b1000,  // Resta A - B
        OP_SLL   = 4'b0001,  // Shift lógico izquierda A << B[4:0]
        OP_SLTU  = 4'b0011,  // Set Less Than Unsigned
        OP_SLT   = 4'b0010,  // Set Less Than Signed
        OP_XOR   = 4'b0100,  // XOR bit a bit
        OP_SRL   = 4'b0101,  // Shift lógico derecha A >> B[4:0]
        OP_SRA   = 4'b1101,  // Shift aritmético derecha
        OP_OR    = 4'b0110,  // OR bit a bit
        OP_AND   = 4'b0111,  // AND bit a bit
        OP_MUL   = 4'b1110;  // Multiplicación A * B

    // Lógica combinacional: siempre usar always_comb para verificar sensibilidad completa
    always_comb begin
        unique case (ALUOp)
            OP_ADD:  ALURes = A + B;
            OP_SUB:  ALURes = A - B;
            OP_SLL:  ALURes = A << B[4:0];
            OP_SLTU: ALURes = (A < B) ? 32'd1 : 32'd0;
            OP_SLT:  ALURes = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            OP_XOR:  ALURes = A ^ B;
            OP_SRL:  ALURes = A >> B[4:0];
            OP_SRA:  ALURes = A >>> B[4:0];
            OP_OR:   ALURes = A | B;
            OP_AND:  ALURes = A & B;
            OP_MUL:  ALURes = A * B;
            default: ALURes = 32'd0;  // Valor seguro por defecto
        endcase
    end

endmodule
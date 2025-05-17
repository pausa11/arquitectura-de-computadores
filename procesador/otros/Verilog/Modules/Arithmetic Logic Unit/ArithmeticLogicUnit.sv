module ArithmeticLogicUnit (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] ALUOp,
    output logic [31:0] ALURes
);

    always @(*) begin
        case (ALUOp)
            4'b0000: ALURes = A + B; // Suma
            4'b1000: ALURes = A - B; // Resta
            4'b0001: ALURes = A << B[4:0]; // Corrimiento lógico a la izquierda
            4'b0011: ALURes = (A < B) ? 32'b1 : 32'b0; // Comparación sin signo
            4'b0010: ALURes = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // Comparación con signo
            4'b0100: ALURes = A ^ B; // XOR
            4'b0101: ALURes = A >> B[4:0]; // Corrimiento lógico a la derecha
            4'b1101: ALURes = A >>> B[4:0]; // Corrimiento aritmético a la derecha
            4'b0110: ALURes = A | B; // OR
            4'b0111: ALURes = A & B; // AND
            4'b1110: ALURes = A * B; // Multiplicación
            
            default: ALURes = 32'b0; // Valor por defecto
        endcase
    end
endmodule

module InstructionMemory (
    input logic [31:0] Address,        // Dirección de la instrucción
    output logic [31:0] Instruction    // Instrucción leída
);

    logic [7:0] memory [0:511];        // Memoria de 8 bits, 512 bytes en total

    // Inicialización de la memoria desde un archivo
    initial begin
        $readmemh("Instructions.txt", memory);
    end

    always @(*) begin
        Instruction = { memory[Address], memory[Address + 1], memory[Address + 2], memory[Address + 3] };
    end
endmodule

`include "InstructionMemory.sv"

module IM_tb;

    logic [31:0] Address;
    logic [31:0] Instruction;

    // Instanciar el modulo de InstructionMemory
    InstructionMemory im (
        .Address(Address),
        .Instruction(Instruction)
    );

    initial begin
        // Iniciar la simulacion
        $display("Inicio de la simulacion de InstructionMemory_tb");
        
        // Test 1: Leer desde la direccion 0
        Address = 32'd44;
        #10; // Espera para que se propague la instruccion
        $display("Direccion: %d, Instruccion: %h", Address, Instruction);

        // Test 2: Leer desde la direccion 4
        Address = 32'd4;
        #10;
        $display("Direccion: %d, Instruccion: %h", Address, Instruction);

        // Test 3: Leer desde la direccion 8
        Address = 32'd8;
        #10;
        $display("Direccion: %d, Instruccion: %h", Address, Instruction);

        // Test 4: Leer desde una direccion arbitraria, como 12
        Address = 32'd12;
        #10;
        $display("Direccion: %d, Instruccion: %h", Address, Instruction);

        // Finalizar la simulacion
        $display("Fin de la simulacion de InstructionMemory_tb");
        $finish;
    end
endmodule

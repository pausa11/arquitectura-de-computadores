`include "ImmediateGenerator.sv"

module IG_tb;

    // Entradas
    logic [24:0] Imm;
    logic [2:0] ImmSrc;

    // Salidas
    logic [31:0] ImmExt;

    // Instanciar el generador de inmediatos
    ImmediateGenerator ig (
        .Imm(Imm),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin
        $dumpfile("IG.vcd");
        $dumpvars(0, IG_tb);
        // Test 1: I-Type
        Imm = 25'b1111111111111111111111111; // Inmediato positivo
        ImmSrc = 3'b000; // I-Type
        #10; 
        $display("I-Type: ImmExt=%b", ImmExt); // Debería imprimir un inmediato extendido

        // Test 2: S-Type
        Imm = 25'b1111111111111111000000000; // Inmediato negativo
        ImmSrc = 3'b001; // S-Type
        #10; 
        $display("S-Type: ImmExt=%b", ImmExt); // Debería imprimir un inmediato extendido

        // Test 3: B-Type
        Imm = 25'b1111111111110000000000000; // Inmediato negativo
        ImmSrc = 3'b101; // B-Type
        #10; 
        $display("B-Type: ImmExt=%b", ImmExt); // Debería imprimir un inmediato extendido

        // Test 4: U-Type
        Imm = 25'b0000000000001111100000000; // Inmediato positivo
        ImmSrc = 3'b010; // U-Type
        #10; 
        $display("U-Type: ImmExt=%b", ImmExt); // Debería imprimir un inmediato extendido

        // Test 5: J-Type
        Imm = 25'b0000000000001111100000000; // Inmediato positivo
        ImmSrc = 3'b110; // J-Type
        #10; 
        $display("J-Type: ImmExt=%b", ImmExt); // Debería imprimir un inmediato extendido

        // Test 6: Caso por defecto
        Imm = 25'b1010101010101010101010101; // Cualquier valor
        ImmSrc = 3'b111; // Caso por defecto
        #10; 
        $display("Caso por defecto: ImmExt=%b", ImmExt); // Debería ser 0

        $finish;
    end
endmodule

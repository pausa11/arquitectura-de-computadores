`include "BranchUnit.sv"

module BU_tb;

    // Definición de las señales de entrada y salida
    logic [31:0] o_rs1;
    logic [31:0] o_rs2;
    logic [4:0] BrOp;
    logic NextPCSrc;

    // Instancia del módulo BranchUnit
    BranchUnit bu (
        .o_rs1(o_rs1),
        .o_rs2(o_rs2),
        .BrOp(BrOp),
        .NextPCSrc(NextPCSrc)
    );

    // Proceso inicial para aplicar los estímulos
    initial begin
        $dumpfile("BU.vcd");
        $dumpvars(0, BU_tb);

        // Caso de prueba 1: BEQ (Branch if Equal)
        o_rs1 = 32'd10;
        o_rs2 = 32'd5;
        BrOp = 5'b01000; // BEQ
        #10; // Esperar 10 unidades de tiempo
        $display("BEQ: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);

        // Caso de prueba 2: BNE (Branch if Not Equal)
        o_rs1 = 32'd15;
        o_rs2 = 32'd15;
        BrOp = 5'b01001; // BNE
        #10; // Esperar 10 unidades de tiempo
        $display("BNE: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);

        // Caso de prueba 3: BLT (Branch if Less Than, signed)
        o_rs1 = 32'd5;
        o_rs2 = 32'd4;
        BrOp = 5'b01100; // BLT
        #10; // Esperar 10 unidades de tiempo
        $display("BLT: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);

        // Caso de prueba 4: BGE (Branch if Greater or Equal, signed)
        o_rs1 = 32'd15;
        o_rs2 = 32'd32;
        BrOp = 5'b01101; // BGE
        #10; // Esperar 10 unidades de tiempo
        $display("BGE: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);

        // Caso de prueba 5: BLTU (Branch if Less Than, unsigned)
        o_rs1 = 32'd5;
        o_rs2 = 32'd10;
        BrOp = 5'b01110; // BLTU
        #10; // Esperar 10 unidades de tiempo
        $display("BLTU: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);

        // Caso de prueba 6: BGEU (Branch if Greater or Equal, unsigned)
        o_rs1 = 32'd10;
        o_rs2 = 32'd5;
        BrOp = 5'b01111; // BGEU
        #10; // Esperar 10 unidades de tiempo
        $display("BGEU: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);

        // Caso de prueba 7: Caso por defecto
        o_rs1 = 32'd0;
        o_rs2 = 32'd0;
        BrOp = 5'b00000; // Caso por defecto
        #10; // Esperar 10 unidades de tiempo
        $display("Default: o_rs1 = %d, o_rs2 = %d, NextPCSrc = %b", o_rs1, o_rs2, NextPCSrc);
        

        // Terminar la simulación
        $finish;
    end
endmodule

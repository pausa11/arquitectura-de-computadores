`include "RegistersUnit.sv"

module RU_tb;

    // Señales de entrada y salida para el DUT
    logic Clk;
    logic [4:0] rs1, rs2, rd;
    logic [31:0] DataWr;
    logic RUWr;
    logic [31:0] o_rs1, o_rs2;

    // Instanciar el modulo RegistersUnit
    RegistersUnit ru (
        .Clk(Clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .DataWr(DataWr),
        .RUWr(RUWr),
        .o_rs1(o_rs1),
        .o_rs2(o_rs2)
    );

    // Generar el reloj
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk; // Reloj con periodo de 10 unidades de tiempo
    end

    initial begin
        $dumpfile("RU.vcd");
        $dumpvars(0, RU_tb);

        $display("Inicio de la simulacion de RegistersUnit_tb");

        // Inicializacion
        RUWr = 0;
        rs1 = 5'd0; rs2 = 5'd0; rd = 5'd0; DataWr = 32'd0;
        #10;

        // Prueba 1: Intento de escribir en el registro x0, debe mantenerse en 0
        rd = 5'd0; DataWr = 32'd123; RUWr = 1;
        #10;
        RUWr = 0;
        rs1 = 5'd0;
        #10;
        $display("Prueba 1 - Registro x0: Direccion = %0d, o_rs1 = %0d (esperado: 0)", rs1, o_rs1);

        // Prueba 2: Escritura en un registro diferente de x0 (x5)
        rd = 5'd5; DataWr = 32'd45; RUWr = 1;
        #10;
        RUWr = 0;
        rs1 = 5'd5;
        #10;
        $display("Prueba 2 - Escritura en x5: Direccion = %0d, o_rs1 = %0d (esperado: 45)", rs1, o_rs1);

        // Prueba 3: Escribir en otro registro (x10) y leer de dos registros simultaneamente
        rd = 5'd10; DataWr = 32'd100; RUWr = 1;
        #10;
        RUWr = 0;
        rs1 = 5'd5; rs2 = 5'd10;
        #10;
        $display("Prueba 3 - Lectura simultanea: o_rs1 (x5) = %0d (esperado: 45), o_rs2 (x10) = %0d (esperado: 100)", o_rs1, o_rs2);

        // Prueba 4: Verificar que los registros no cambian sin habilitar RUWr
        rd = 5'd10; DataWr = 32'd200; RUWr = 0;
        #10;
        rs1 = 5'd10;
        #10;
        $display("Prueba 4 - Sin habilitar escritura: o_rs1 (x10) = %0d (esperado: 100)", o_rs1);

        // Fin de la simulacion
        $display("Fin de la simulacion de RegistersUnit_tb");
        $finish;
    end
endmodule

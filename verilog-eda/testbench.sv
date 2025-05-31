`timescale 1ns / 1ns

module Procesador_monociclo_tb;

    // --------------------------------------------------------------------------
    // Parámetros de simulación
    // --------------------------------------------------------------------------
    localparam integer CLK_PERIOD = 10;   // Periodo de reloj en ns
    localparam integer NUM_CYCLES = 100;  // Número de ciclos a simular

    // --------------------------------------------------------------------------
    // Señales
    // --------------------------------------------------------------------------
    logic Clk;

    // --------------------------------------------------------------------------
    // Instanciación del DUT
    // --------------------------------------------------------------------------
    Procesador_monociclo uut (
        .Clk(Clk)
    );

    // --------------------------------------------------------------------------
    // Generador de reloj
    // --------------------------------------------------------------------------
    initial begin
        Clk = 1'b0;
        forever #(CLK_PERIOD/2) Clk = ~Clk;
    end

    // --------------------------------------------------------------------------
    // Monitor de señales
    // --------------------------------------------------------------------------
    initial begin
        $display("time(ns)\tClk\tPC");
        $monitor("%0t\t%b\t%h", $time, Clk, uut.Out_PC);
    end

    // --------------------------------------------------------------------------
    // Bloque principal de simulación
    // --------------------------------------------------------------------------
    initial begin
        // Generar archivo VCD
        $dumpfile("Procesador_monociclo_tb.vcd");
        $dumpvars(0, Procesador_monociclo_tb);

        // Ejecutar simulación
        #(CLK_PERIOD * NUM_CYCLES);

        $display("Simulación completada en %0t ns", $time);
        $finish;
    end

endmodule
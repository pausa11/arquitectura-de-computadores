module ProgramCounter(
    input logic Clk,               // Señal de reloj
    input logic [31:0] NextPC,    // Dirección de la siguiente instrucción
    output logic [31:0] Address         // Dirección actual del Address
);

    // Inicialización del Address en 0
    initial Address = 32'h00000000;

    // Bloque siempre que se ejecuta en cada flanco positivo de Clk
    always_ff @(posedge Clk) begin
        Address <= NextPC;             // Actualiza el Address al siguiente valor
    end
endmodule

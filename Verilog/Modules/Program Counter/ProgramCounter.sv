// ProgramCounter.sv
// Contador de programa (PC) para un procesador RISC-V de 32 bits
// Actualiza el PC en cada flanco de reloj con la dirección proporcionada.

module ProgramCounter (
    input  logic        clk,        // Señal de reloj
    input  logic        rst_n,      // Reset asíncrono activo bajo
    input  logic [31:0] next_pc,    // Dirección del siguiente PC
    output logic [31:0] pc          // Valor actual del PC
);

    // Inicialización y reset asíncrono
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 32'h00000000;      // Valor inicial al reset
        end else begin
            pc <= next_pc;          // Actualiza PC en flanco
        end
    end

endmodule

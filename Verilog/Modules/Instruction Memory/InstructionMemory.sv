// InstructionMemory.sv
// Módulo de memoria de instrucciones para un procesador RISC-V de 32 bits
// Permite lectura de instrucciones almacenadas en memoria.

module InstructionMemory #(
    parameter ADDR_WIDTH = 10        // Tamaño de la memoria: 2^ADDR_WIDTH bytes
)(
    input  logic [ADDR_WIDTH-1:0] Address,   // Dirección de instrucción (word-aligned)
    output logic [31:0]          InstrOut    // Instrucción de 32 bits leída
);

    // Memoria interna: arreglo de bytes
    localparam DEPTH = 1 << ADDR_WIDTH;
    logic [7:0] memory [0:DEPTH-1];

    // Lectura combinacional: 4 bytes formados en orden little-endian
    always_comb begin
        InstrOut = {memory[{Address, 2'b11}],
                    memory[{Address, 2'b10}],
                    memory[{Address, 2'b01}],
                    memory[{Address, 2'b00}]};
    end

endmodule


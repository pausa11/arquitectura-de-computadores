// DataMemory.sv
// Módulo de memoria de datos para RISC-V de 32 bits
// Permite operaciones de carga (byte, halfword, word) con signo y sin signo,
// y almacenamiento (byte, halfword, word).

module DataMemory #(
    parameter ADDR_WIDTH = 10        // Tamaño de la memoria: 2^ADDR_WIDTH bytes
)(
    input  logic         clk,         // Señal de reloj
    input  logic         MemRead,     // Habilita lectura
    input  logic         MemWrite,    // Habilita escritura
    input  logic [2:0]   MemOp,       // Operación de memoria: 000=LB, 001=LH, 010=LW, 100=LBU, 101=LHU
                                      // 011=SB, 110=SH, 111=SW
    input  logic [31:0]  Address,     // Dirección efectiva
    input  logic [31:0]  WriteData,   // Datos a escribir
    output logic [31:0]  ReadData     // Datos leídos
);

    // Memoria interna: arreglos de bytes
    localparam DEPTH = 1 << ADDR_WIDTH;
    logic [7:0] memory [0:DEPTH-1];
    logic [31:0] aligned_data;

    // Lógica de lectura (combinacional)
    always_comb begin
        ReadData = 32'd0;
        if (MemRead) begin
            unique case (MemOp)
                3'b000: // LB (sign-extend byte)
                    ReadData = {{24{memory[Address][7]}}, memory[Address]};
                3'b001: // LH (sign-extend halfword)
                    ReadData = {{16{memory[Address+1][7]}}, memory[Address+1], memory[Address]};
                3'b010: // LW (word)
                    ReadData = {memory[Address+3], memory[Address+2], memory[Address+1], memory[Address]};
                3'b100: // LBU (zero-extend byte)
                    ReadData = {24'd0, memory[Address]};
                3'b101: // LHU (zero-extend halfword)
                    ReadData = {16'd0, memory[Address+1], memory[Address]};
                default:
                    ReadData = 32'd0;
            endcase
        end
    end

    // Escritura en memoria (sincrónica)
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            unique case (MemOp)
                3'b011: // SB (store byte)
                    memory[Address] <= WriteData[7:0];
                3'b110: // SH (store halfword)
                    {memory[Address+1], memory[Address]} <= WriteData[15:0];
                3'b111: // SW (store word)
                    {memory[Address+3], memory[Address+2], memory[Address+1], memory[Address]} <= WriteData;
                default: ; // No write
            endcase
        end
    end

endmodule

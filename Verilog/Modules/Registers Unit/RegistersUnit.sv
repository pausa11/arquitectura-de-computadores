// RegistersUnit.sv
// Banco de 32 registros de 32 bits para un procesador RISC-V de 32 bits
// Registros de propósito general con x0 siempre en 0 y salida opcional de debug.

module RegistersUnit (
    input  logic        clk,          // Señal de reloj
    input  logic        rst_n,        // Reset asíncrono activo bajo
    input  logic [4:0]  rs1,          // Índice de registro fuente 1
    input  logic [4:0]  rs2,          // Índice de registro fuente 2
    input  logic [4:0]  rd,           // Índice de registro destino
    input  logic [31:0] write_data,   // Dato a escribir en rd
    input  logic        reg_write,    // Habilita escritura en registro
    output logic [31:0] read_data1,   // Dato leído de rs1
    output logic [31:0] read_data2,   // Dato leído de rs2
    output logic [31:0] debug_reg10   // Salida de registro x10 para debug
);

    // Banco de registros: 32 entradas de 32 bits
    logic [31:0] regs [0:31];

    // Escritura en flanco de reloj o reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Inicialización: x0=0, otros a 0, x2=esp (ejemplo)
            integer i;
            for (i = 0; i < 32; i++) regs[i] <= 32'd0;
            regs[2] <= 32'd1024;  // Stack pointer inicial (opcional)
        end else if (reg_write && (rd != 5'd0)) begin
            regs[rd] <= write_data;  // No escribir en x0
        end
    end

    // Lectura combinacional: x0 siempre en 0
    always_comb begin
        read_data1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
        read_data2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
        debug_reg10 = regs[10];
    end

endmodule

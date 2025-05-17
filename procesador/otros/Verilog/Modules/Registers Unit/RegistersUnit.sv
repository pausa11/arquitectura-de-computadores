module RegistersUnit (
    input logic Clk,                         // Señal de reloj
    input logic [4:0] rs1,                   // Dirección del primer registro a leer
    input logic [4:0] rs2,                   // Dirección del segundo registro a leer
    input logic [4:0] rd,                    // Dirección del registro donde escribir
    input logic [31:0] DataWr,               // Dato a escribir en el registro
    input logic RUWr,                        // Señal para habilitar escritura en el registro
    output logic [31:0] o_rs1,            // Dato leído del primer registro
    output logic [31:0] o_rs2,             // Dato leído del segundo registro
    output logic [31:0] reg10                // Valor del registro 10
);

    // Array de 32 registros de 32 bits
    logic [31:0] registers [31:0];

    initial begin 
        for(int i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
        registers[2] = 32'd1024;
    end

    // Lectura de registros
    assign o_rs1 = registers[rs1];
    assign o_rs2 = registers[rs2];
    assign reg10 = registers[10]; // Exponer el contenido del registro 10

    // Escritura en el registro
    always_ff @(posedge Clk) begin
        if (RUWr && rd != 5'b00000) begin
            registers[rd] <= DataWr;        // Escribe el dato en el registro especificado, excepto en x0
        end
    end

endmodule

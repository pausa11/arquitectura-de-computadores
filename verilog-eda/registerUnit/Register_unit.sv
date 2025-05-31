module Register_unit (
    input  logic        Clk,       // Señal de reloj
    input  logic [31:0] RuDataWr,  // Datos a escribir
    input  logic [4:0]  Rs1,       // Índice registro fuente 1
    input  logic [4:0]  Rs2,       // Índice registro fuente 2
    input  logic [4:0]  Rd,        // Índice registro destino
    input  logic        RuWr,      // Habilita escritura en registro
    output logic [31:0] RuRs1,     // Dato leído registro fuente 1
    output logic [31:0] RuRs2      // Dato leído registro fuente 2
);

    //------------------------------------------------------------------------------
    // Bancos de registros (32 x 32 bits)
    //------------------------------------------------------------------------------
    logic [31:0] Registers [0:31] = '{ default: 32'b0 };

    //------------------------------------------------------------------------------
    // Escritura de registros (flanco de subida)
    //------------------------------------------------------------------------------
    always_ff @(posedge Clk) begin
        if (RuWr && (Rd != 5'd0)) begin
            Registers[Rd] <= RuDataWr;
        end
    end

    //------------------------------------------------------------------------------
    // Lectura de registros (combinacional)
    //------------------------------------------------------------------------------
    always_comb begin
        RuRs1 = Registers[Rs1];
        RuRs2 = Registers[Rs2];
    end

endmodule

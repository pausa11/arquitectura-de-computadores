module Data_memory (
    input  logic [31:0] Address,   // Dirección de memoria
    input  logic [31:0] DataWr,    // Datos a escribir
    input  logic        DMWr,      // Señal de escritura
    input  logic [2:0]  DMCtrl,    // Control de acceso
    output logic [31:0] DataRd     // Datos leídos
);

    //------------------------------------------------------------------------------
    // Memoria de bytes (little endian)
    //------------------------------------------------------------------------------
    logic [7:0] Memory [0:31] = '{ default: 8'b0 };

    //------------------------------------------------------------------------------
    // Lectura de memoria (combinacional)
    //------------------------------------------------------------------------------
    always_comb begin
        DataRd = 32'b0;
        unique case (DMCtrl)
            3'b000: // LB: load byte (signed)
                DataRd = {{24{Memory[Address][7]}}, Memory[Address]};
            3'b001: // LH: load halfword (signed)
                DataRd = {{16{Memory[Address+1][7]}}, Memory[Address+1], Memory[Address]};
            3'b010: // LW: load word
                DataRd = {Memory[Address+3], Memory[Address+2], Memory[Address+1], Memory[Address]};
            3'b100: // LBU: load byte unsigned
                DataRd = {24'b0, Memory[Address]};
            3'b101: // LHU: load halfword unsigned
                DataRd = {16'b0, Memory[Address+1], Memory[Address]};
            default:
                DataRd = 32'b0;
        endcase
    end

    //------------------------------------------------------------------------------
    // Escritura de memoria (combinacional con retardo implicito)
    //------------------------------------------------------------------------------
    always_comb begin
        if (DMWr) begin
            unique case (DMCtrl)
                3'b000: // SB: save byte
                    Memory[Address] <= DataWr[7:0];
                3'b001: // SH: save halfword
                begin
                    Memory[Address]     <= DataWr[7:0];
                    Memory[Address + 1] <= DataWr[15:8];
                end
                3'b010: // SW: save word
                begin
                    Memory[Address]     <= DataWr[7:0];
                    Memory[Address + 1] <= DataWr[15:8];
                    Memory[Address + 2] <= DataWr[23:16];
                    Memory[Address + 3] <= DataWr[31:24];
                end
                default: ;
            endcase
        end
    end

endmodule


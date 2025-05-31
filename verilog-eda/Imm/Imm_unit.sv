module Imm_unit (
    input  logic [24:0] ImmIn,    // Bits de inmediato brutos
    input  logic [2:0]  ImmSrc,   // Selección de tipo de inmediato
    output logic [31:0] ImmExt    // Inmediato extendido a 32 bits
);

    //------------------------------------------------------------------------------
    // Extensión de signo
    //------------------------------------------------------------------------------
    always_comb begin
        // Inicialización de ImmExt según signo (bit 24)
        ImmExt = (ImmIn[24]) ? 32'hFFFFFFFF : 32'b0;

        //------------------------------------------------------------------------------
        // Construcción del inmediato según formato
        //------------------------------------------------------------------------------
        unique case (ImmSrc)
            3'b000: begin // I-type
                ImmExt[11:0] = ImmIn[24:13];
            end
            3'b001: begin // S-type
                ImmExt[11:0] = {ImmIn[24:18], ImmIn[4:0]};
            end
            3'b101: begin // B-type
                ImmExt[12:0] = {ImmIn[24], ImmIn[0], ImmIn[23:18], ImmIn[4:1], 1'b0};
            end
            3'b010: begin // U-type
                ImmExt[31:12] = ImmIn[24:5];
            end
            3'b110: begin // J-type
                ImmExt[20:0] = {ImmIn[24], ImmIn[12:5], ImmIn[13], ImmIn[23:14], 1'b0};
            end
            default: ; // Sin cambios más allá de la inicialización
        endcase
    end

endmodule
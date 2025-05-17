module ImmediateGenerator (
    input logic [24:0] Imm,          // Parte superior del inmediato de 25 bits
    input logic [2:0] ImmSrc,        // Selección de inmediato
    output logic [31:0] ImmExt       // Inmediato extendido a 32 bits
);

    always @(*) begin
        case (ImmSrc)
            3'b000: ImmExt = {{20{Imm[24]}}, Imm[24:13]}; // I-Type 
            3'b001: ImmExt = {{20{Imm[24]}}, Imm[24:18], Imm[4:0]}; // S-Type 
            3'b101: ImmExt = {{19{Imm[24]}}, Imm[24], Imm[0], Imm[23:18], Imm[4:1], 1'b0}; // B-Type 
            3'b010: ImmExt = {Imm[24:5], 12'b0}; // U-Type 
            3'b110: ImmExt = {{12{Imm[24]}}, Imm[24], Imm[12:5], Imm[13], Imm[23:14], 1'b0}; // J-Type
            default: ImmExt = 32'b0; // Default value
        endcase
    end
endmodule

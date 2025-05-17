module BranchUnit (
    input logic [31:0] o_rs1,        // Entrada de fuente rs1Out
    input logic [31:0] o_rs2,        // Entrada de fuente rs2Out
    input logic [4:0] BrOp,            // Señal de operación de branch
    output logic NextPCSrc             // Señal para seleccionar la siguiente dirección del PC
);

    always @(*) begin
        case (BrOp)
            5'b01000: NextPCSrc = (o_rs1 == o_rs2);  // BEQ: Igualdad
            5'b01001: NextPCSrc = (o_rs1 != o_rs2);  // BNE: Diferencia
            5'b01100: NextPCSrc = ($signed(o_rs1) < $signed(o_rs2));  // BLT: Menor que (con signo)
            5'b01101: NextPCSrc = ($signed(o_rs1) >= $signed(o_rs2)); // BGE: Mayor o igual que (con signo)
            5'b01110: NextPCSrc = (o_rs1 < o_rs2);   // BLT: Menor que (sin signo)
            5'b01111: NextPCSrc = (o_rs1 >= o_rs2);  // BGE: Mayor o igual que (sin signo)
            5'b1xxxx: NextPCSrc = 1'b1;
            default:  NextPCSrc = 1'b0;  // Por defecto no hay salto
        endcase
    end
endmodule

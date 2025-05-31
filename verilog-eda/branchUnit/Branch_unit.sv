module Branch_unit (
    input  logic [31:0] In1,       // Operando 1
    input  logic [31:0] In2,       // Operando 2
    input  logic  [4:0] BrOp,      // Código de operación de branch
    output logic        NextPCSrc // Señal de salto
);

    //------------------------------------------------------------------------------
    // Lógica combinacional para determinar NextPCSrc
    //------------------------------------------------------------------------------
    always_comb begin
        // Valor por defecto: no salto
        NextPCSrc = 0;

        // Salto incondicional (bit 4 = 1)
        if (BrOp[4]) begin
            NextPCSrc = 1;
        end

        // Opciones de salto condicional (bits [4:3] = 2'b10)
      if (BrOp[4:3] == 01) begin
            unique case (BrOp[3:0])
                4'b1000: NextPCSrc = (In1 == In2);                     // BEQ
                4'b1001: NextPCSrc = (In1 != In2);                     // BNE
                4'b1100: NextPCSrc = (In1 <  In2);                     // BLT (signed)
                4'b1101: NextPCSrc = (In1 >= In2);                     // BGE (signed)
                4'b1110: NextPCSrc = ($unsigned(In1) <  $unsigned(In2)); // BLTU (unsigned)
                4'b1111: NextPCSrc = ($unsigned(In1) >= $unsigned(In2)); // BGEU (unsigned)
                default: NextPCSrc = 1'b0;
            endcase
        end
        if(BrOp[4:3] == 2'b00)begin	//No realiza el salto cuando los 2 bits mas significativos son 00
			NextPCSrc = 0;				//Salida en 0
        end
      
    end

endmodule
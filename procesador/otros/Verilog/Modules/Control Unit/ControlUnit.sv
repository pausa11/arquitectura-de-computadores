module ControlUnit (
    input logic [6:0] OpCode,           // Código de operación
    input logic [2:0] Funct3,           // Función 3
    input logic [6:0] Funct7,           // Función 7
    output logic ALUASrc,               // Fuente A para la ALU
    output logic ALUBSrc,               // Fuente B para la ALU
    output logic [3:0] ALUOp,           // Operación de la ALU
    output logic [2:0] ImmSrc,          // Fuente de inmediato
    output logic RUWr,                  // Señal de escritura en el registro
    output logic [4:0] BrOp,            // Señal de operación de Branch
    output logic [2:0] DMCtrl,          // Control de la Data Memory
    output logic DMWr,                  // Señal de escritura en la Data Memory
    output logic [1:0] RUDataWrSrc     // Fuente de datos para escritura en el registro
);

    always @(*) begin
        case (OpCode)
            7'b0110011: begin // Tipo R

            if (Funct7 == 7'b0000001 && Funct3 == 3'b000) begin
          		ALUOp = 4'b1110; // Multiplicación
        	end 
          	else begin
            	ALUOp = {Funct7[5], Funct3[2:0]};
        	end


                RUWr = 1'b1;                 // Habilitar escritura en el registro
                ALUASrc = 1'b0;              // Fuente A proviene del registro
                ALUBSrc = 1'b0;              // Fuente B proviene del registro
                //ALUOp = {Funct7[5], Funct3}; // Operación basada en Funct7 y Funct3
                ImmSrc = 3'bxxx;             // Sin inmediato
                BrOp = 5'b00xxx;             // No operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b00;         // Datos desde la ALU
            end

            7'b0010011: begin // Tipo I
                RUWr = 1'b1;                 // Escritura en el registro
                ALUASrc = 1'b0;              // Fuente A del registro
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b000;             // Inmediato de tipo I
                BrOp = 5'b00xxx;             // No operación de salto
                ALUOp = (Funct3 == 3'b101) ? {Funct7[5], Funct3} : {1'b0, Funct3};
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b00;         // Datos desde la ALU
            end

            7'b0000011: begin // Tipo L (Load)
                RUWr = 1'b1;                 // Escritura en el registro
                ALUASrc = 1'b0;              // Fuente A del registro
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b000;             // Inmediato de tipo I
                ALUOp = 4'b0000;             // Suma para dirección de memoria
                BrOp = 5'b00xxx;             // No operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = Funct3;             // Control de memoria basado en Funct3
                RUDataWrSrc = 2'b01;         // Datos desde la memoria
            end

            7'b0100011: begin // Tipo S (Store)
                RUWr = 1'b0;                 // Sin escritura en el registro
                ALUASrc = 1'b0;              // Fuente A del registro
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b001;             // Inmediato de tipo S
                ALUOp = 4'b0000;             // Suma para dirección de memoria
                BrOp = 5'b00xxx;             // No operación de salto
                DMWr = 1'b1;                 // Habilitar escritura en memoria
                DMCtrl = Funct3;             // Control de memoria basado en Funct3
                RUDataWrSrc = 2'bxx;         // Sin datos para el registro
            end

            7'b1100011: begin // Tipo B (Branch)
                RUWr = 1'b0;                 // Sin escritura en el registro
                ALUASrc = 1'b1;              // Fuente A es inmediato
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b101;             // Inmediato de tipo B
                ALUOp = 4'b0000;             // Suma para cálculo de dirección
                BrOp = {2'b01, Funct3};      // Operación de salto según Funct3
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'bxx;         // Sin datos para el registro
            end

            7'b1101111: begin // Tipo J (JAL)
                RUWr = 1'b1;                 // Escritura en el registro
                ALUASrc = 1'b1;              // Fuente A es PC
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b110;             // Inmediato de tipo J
                ALUOp = 4'b0000;             // Suma para cálculo de dirección
                BrOp = 5'b1xxxx;             // Operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b10;         // Datos desde PC + 4
            end

            7'b1100111: begin // Tipo JR (JALR)
                RUWr = 1'b1;                 // Escritura en el registro
                ALUASrc = 1'b0;              // Fuente A del registro
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b000;             // Inmediato de tipo I
                ALUOp = 4'b0000;             // Suma para dirección de salto
                BrOp = 5'b1xxxx;             // Operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b10;         // Datos desde PC + 4
            end

            7'b0110111: begin // Tipo U (LUI)
                RUWr = 1'b1;                 // Escritura en el registro
                ALUASrc = 1'bx;              // Fuente A no importa
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b010;             // Inmediato de tipo U
                ALUOp = 4'b1111;             // Operación especial para LUI
                BrOp = 5'b00xxx;             // No operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b00;         // Datos desde ALU
            end

            7'b0010111: begin // Tipo U (AUIPC)
                RUWr = 1'b1;                 // Escritura en el registro
                ALUASrc = 1'b1;              // Fuente A es PC
                ALUBSrc = 1'b1;              // Fuente B es inmediato
                ImmSrc = 3'b010;             // Inmediato de tipo U
                ALUOp = 4'b1111;             // Operación especial para AUIPC
                BrOp = 5'b00xxx;             // No operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b00;         // Datos desde ALU
            end

            default: begin // Caso por defecto
                RUWr = 1'b0;                 // Sin escritura en el registro
                ALUASrc = 1'bx;              // Fuente A no importa
                ALUBSrc = 1'bx;              // Fuente B no importa
                ImmSrc = 3'bxxx;             // Sin inmediato
                ALUOp = 4'bxxxx;             // Sin operación
                BrOp = 5'b00xxx;             // Sin operación de salto
                DMWr = 1'b0;                 // No se escribe en memoria
                DMCtrl = 3'bxxx;             // Sin control de memoria
                RUDataWrSrc = 2'b00;         // Fuente de datos predeterminada
            end
        endcase
    end
endmodule

`include "Monociclo.sv"

module Monociclo_tb;
    logic Clk;
    integer instruction_count = 0; // Cambiado a `integer` para compatibilidad
    integer file;                 // Variable para manejar el archivo

    // Instancia del módulo Monociclo
    Monociclo MC (
        .Clk(Clk)
    );

    // Generación de reloj
    always #5 Clk = ~Clk;

    // Bloque inicial
    initial begin
        Clk = 0;

        // Abrir el archivo para escritura
        file = $fopen("Monociclo_output.txt", "w");
        if (file == 0) begin
            $display("Error: No se pudo abrir el archivo Monociclo_output.txt.");
            $finish; // Detener simulación si no se puede abrir el archivo
        end

        // Configuración de dumping de señales
        $dumpfile("Monociclo.vcd");
        $dumpvars(0, Monociclo_tb);

        // Primera instrucción
        instruction_count++;
        $display("\n%d instrucción\n", instruction_count);
        $fwrite(file, "\n%d instrucción\n", instruction_count);

        #6000;
        $fclose(file); // Cerrar el archivo al finalizar
        $finish;
    end

    // Monitor de señales
    initial begin
        $monitor(
            "Time: %0t\nInstruction: %h\nALUOp: %h\nALUASrc: %b\n\nALUBSrc: %b\nRUWr: %b\nImmSrc: %h\n\nBrOp: %h\nDMWr: %b\nDMCtrl: %h\n\nRUDataWrSrc: %h\nImmExt: %h\no_rs1: %h\n\no_rs2: %h\nDataWr: %h\ni_ALUA: %h\n\ni_ALUB: %h\nALURes: %h\n\nDataRd: %h\nNextAddress: %h\nNextPCSrc: %b\n\nNextPC: %h\nAddress: %h\nreg10: %h\n",
            $time, MC.Instruction, MC.ALUOp, MC.ALUASrc, MC.ALUBSrc, MC.RUWr, MC.ImmSrc, MC.BrOp, MC.DMWr, MC.DMCtrl, MC.RUDataWrSrc, MC.ImmExt, MC.o_rs1, MC.o_rs2, MC.DataWr, MC.i_ALUA, MC.i_ALUB, MC.ALURes, MC.DataRd, MC.NextAddress, MC.NextPCSrc, MC.NextPC, MC.Address, MC.reg10
        );
    end

    // Escribir señales en archivo en cada flanco de reloj
    always @(posedge Clk) begin
        instruction_count++;
        $display("\n%d instrucción\n", instruction_count);
        $fwrite(file, "\n%d instrucción\n", instruction_count);
        $fwrite(file, "Time: %0t\nInstruction: %h\nALUOp: %h\nALUASrc: %b\n\nALUBSrc: %b\nRUWr: %b\nImmSrc: %h\n\nBrOp: %h\nDMWr: %b\nDMCtrl: %h\n\nRUDataWrSrc: %h\nImmExt: %h\no_rs1: %h\n\no_rs2: %h\nDataWr: %h\ni_ALUA: %h\n\ni_ALUB: %h\nALURes: %h\n\nDataRd: %h\nNextAddress: %h\nNextPCSrc: %b\n\nNextPC: %h\nAddress: %h\nreg10: %h\n\n",
                 $time, MC.Instruction, MC.ALUOp, MC.ALUASrc, MC.ALUBSrc, MC.RUWr, MC.ImmSrc, MC.BrOp, MC.DMWr, MC.DMCtrl, MC.RUDataWrSrc, MC.ImmExt, MC.o_rs1, MC.o_rs2, MC.DataWr, MC.i_ALUA, MC.i_ALUB, MC.ALURes, MC.DataRd, MC.NextAddress, MC.NextPCSrc, MC.NextPC, MC.Address, MC.reg10);
    end
endmodule

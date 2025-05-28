`include "ControlUnit.sv"

module CU_tb;

    // Entradas
    logic [6:0] OpCode;
    logic [2:0] Funct3;
    logic [6:0] Funct7;

    // Salidas
    logic ALUASrc;
    logic ALUBSrc;
    logic [3:0] ALUOp;
    logic [2:0] ImmSrc;
    logic RUWr;
    logic [4:0] BrOp;
    logic [2:0] DMCtrl;
    logic DMWr;
    logic [1:0] RUDataWrSrc;

    // Instanciar la unidad de control
    ControlUnit cu (
        .OpCode(OpCode),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .ALUASrc(ALUASrc),
        .ALUBSrc(ALUBSrc),
        .ALUOp(ALUOp),
        .ImmSrc(ImmSrc),
        .RUWr(RUWr),
        .BrOp(BrOp),
        .DMCtrl(DMCtrl),
        .DMWr(DMWr),
        .RUDataWrSrc(RUDataWrSrc)
    );

    initial begin
        $dumpfile("CU.vcd");
        $dumpvars(0, CU_tb);
        // Test 1: Tipo R
        OpCode = 7'b0110011; Funct3 = 3'b000; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo R: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 2: Tipo I
        OpCode = 7'b0010011; Funct3 = 3'b010; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo I: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 3: Tipo Load
        OpCode = 7'b0000011; Funct3 = 3'b010; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo Load: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 4: Tipo Store
        OpCode = 7'b0100011; Funct3 = 3'b010; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo Store: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 5: Tipo Branch
        OpCode = 7'b1100011; Funct3 = 3'b000; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo Branch: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 6: Tipo J (JAL)
        OpCode = 7'b1101111; Funct3 = 3'b000; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo J: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 7: Tipo U (LUI)
        OpCode = 7'b0110111; Funct3 = 3'b000; Funct7 = 7'b0000000;
        #10; 
        $display("Tipo U: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        // Test 8: Caso por defecto
        OpCode = 7'b1111111; Funct3 = 3'b111; Funct7 = 7'b1111111;
        #10; 
        $display("Caso por defecto: RUWr=%b, ALUASrc=%b, ALUBSrc=%b, ALUOp=%b, ImmSrc=%b, DMWr=%b, BrOp=%b, DMCtrl=%b", RUWr, ALUASrc, ALUBSrc, ALUOp, ImmSrc, DMWr, BrOp, DMCtrl);

        $finish;
    end
endmodule

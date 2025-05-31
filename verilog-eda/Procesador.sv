`include "Control_unit.sv"
`include "Register_unit.sv"
`include "Branch_unit.sv"
`include "ALU.sv"
`include "Data_memory.sv"
`include "Imm_unit.sv"
`include "Instruction_memory.sv"

module Procesador_monociclo (
    input  logic         Clk
);

    // Program Counter and Instruction
    logic [31:0] Out_PC           = 32'b0;
    logic [31:0] Out_Instruction;

    // Control signals
    logic        RUWr;
    logic [2:0]  ImmSrc;
    logic        AluASrc;
    logic        AluBSrc;
    logic [4:0]  BrOp;
    logic [3:0]  ALUOp;
    logic        DMWr;
    logic [2:0]  DMCtrl;
    logic [1:0]  RUDataWrSrc;

    // Data paths
    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [31:0] ImmExt;
    logic [31:0] MuxA;
    logic [31:0] MuxB;
    logic [31:0] Alu_out;
    logic [31:0] DataRd;
    logic [31:0] MuxRUDataWrSrc;

    // Internal summation and branch
    logic [31:0] Suma       = 32'b0;
    logic [31:0] MuxSalto   = 32'b0;
    logic        NextPCSrc;

    //------------------------------------------------------------------------------
    // Sequential PC update
    //------------------------------------------------------------------------------
    always_ff @(posedge Clk) begin
        Out_PC <= MuxSalto;
    end

    //------------------------------------------------------------------------------
    // Combinational logic: ALU inputs, immediate, multiplexers, branch
    //------------------------------------------------------------------------------
    always_comb begin
        // Increment PC by 4
        Suma = Out_PC + 4;

        // ALU A input multiplexer
        MuxA = (AluASrc) ? Out_PC : rs1;

        // ALU B input multiplexer
        MuxB = (AluBSrc) ? ImmExt : rs2;

        // Register Write Data multiplexer
        unique case (RUDataWrSrc)
            2'b10: MuxRUDataWrSrc = Suma;
            2'b01: MuxRUDataWrSrc = DataRd;
            2'b00: MuxRUDataWrSrc = Alu_out;
            default: MuxRUDataWrSrc = 32'b0;
        endcase

        // Branch target multiplexer
        MuxSalto = (NextPCSrc) ? Alu_out : Suma;
    end

    //------------------------------------------------------------------------------
    // Module instances
    //------------------------------------------------------------------------------
    Instruction_memory im (
        .Address    (Out_PC),
        .Instruction(Out_Instruction)
    );

    Control_unit cu (
        .OpCode       (Out_Instruction[6:0]),
        .Funct3       (Out_Instruction[14:12]),
        .Funct7       (Out_Instruction[31:25]),
        .RUWr         (RUWr),
        .ImmSrc       (ImmSrc),
        .AluASrc      (AluASrc),
        .AluBSrc      (AluBSrc),
        .BrOp         (BrOp),
        .ALUOp        (ALUOp),
        .DMWr         (DMWr),
        .DMCtrl       (DMCtrl),
        .RUDataWrSrc  (RUDataWrSrc)
    );

    Register_unit ru (
        .Clk      (Clk),
        .RuDataWr (MuxRUDataWrSrc),
        .Rs1      (Out_Instruction[19:15]),
        .Rs2      (Out_Instruction[24:20]),
        .Rd       (Out_Instruction[11:7]),
        .RuWr     (RUWr),
        .RuRs1    (rs1),
        .RuRs2    (rs2)
    );

    Imm_unit iu (
        .ImmIn   (Out_Instruction[31:7]),
        .ImmSrc  (ImmSrc),
        .ImmExt  (ImmExt)
    );

    ALU alu (
        .A      (MuxA),
        .B      (MuxB),
        .ALUOp  (ALUOp),
        .Alu_out(Alu_out)
    );

    Data_memory dm (
        .Address (Alu_out),
        .DataWr  (rs2),
        .DMWr    (DMWr),
        .DMCtrl  (DMCtrl),
        .DataRd  (DataRd)
    );

    Branch_unit bu (
        .In1       (rs1),
        .In2       (rs2),
        .BrOp      (BrOp),
        .NextPCSrc (NextPCSrc)
    );

endmodule

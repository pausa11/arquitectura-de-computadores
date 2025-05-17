`include "../Modules/Instruction Memory/InstructionMemory.sv"
`include "../Modules/Control Unit/ControlUnit.sv"
`include "../Modules/Immediate Generator/ImmediateGenerator.sv"
`include "../Modules/Registers Unit/RegistersUnit.sv"
`include "../Modules/Arithmetic Logic Unit/ArithmeticLogicUnit.sv"
`include "../Modules/Data Memory/DataMemory.sv"
`include "../Modules/Branch Unit/BranchUnit.sv"

module Monociclo (
    input logic Clk
);

    logic [31:0] Instruction;    
    logic [3:0] ALUOp;
    logic ALUASrc;
    logic ALUBSrc;
    logic RUWr;
    logic [2:0] ImmSrc;
    logic [4:0] BrOp;
    logic DMWr;
    logic [2:0] DMCtrl;
    logic [1:0] RUDataWrSrc;
    logic [31:0] ImmExt;
    logic [31:0] o_rs1;
    logic [31:0] o_rs2;
    logic [31:0] reg10;
    logic [31:0] DataWr;
    logic [31:0] i_ALUA;
    logic [31:0] i_ALUB;
    logic [31:0] ALURes;
    logic [31:0] DataRd;
    logic [31:0] NextAddress = 32'b0; // Address + 4
    logic NextPCSrc;
    logic [31:0] NextPC = 32'b0;
    logic [31:0] Address = 32'b0;

    always_ff @(posedge Clk) begin
        Address <= NextPC;
    end

    always @(*) begin
        i_ALUA = ALUASrc ? Address : o_rs1;
        i_ALUB = ALUBSrc ? ImmExt : o_rs2;
        NextAddress = Address + 32'd4;
        NextPC = NextPCSrc ? ALURes : NextAddress;
        DataWr = RUDataWrSrc == 2'b00 ? ALURes : 
                 RUDataWrSrc == 2'b01 ? DataRd : 
                 NextAddress;
    end

    InstructionMemory IM (
        .Address(Address),
        .Instruction(Instruction)
    );

    ControlUnit CU (
        .OpCode(Instruction[6:0]),
        .Funct3(Instruction[14:12]),
        .Funct7(Instruction[31:25]),
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

    ImmediateGenerator IG (
        .Imm(Instruction[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    RegistersUnit RU (
        .Clk(Clk),
        .rs1(Instruction[19:15]),
        .rs2(Instruction[24:20]),
        .rd(Instruction[11:7]),
        .DataWr(DataWr),
        .RUWr(RUWr),
        .o_rs1(o_rs1),
        .o_rs2(o_rs2),
        .reg10(reg10)
    );

    ArithmeticLogicUnit ALU (
        .A(i_ALUA),
        .B(i_ALUB),
        .ALUOp(ALUOp),
        .ALURes(ALURes)
    );  

    DataMemory DM (
        .Clk(Clk),
        .Address(ALURes),
        .DataWr(o_rs2),
        .DMCtrl(DMCtrl),
        .DMWr(DMWr),
        .DataRd(DataRd)
    );

    BranchUnit BU (
        .o_rs1(o_rs1),
        .o_rs2(o_rs2),
        .BrOp(BrOp),
        .NextPCSrc(NextPCSrc)
    );

endmodule

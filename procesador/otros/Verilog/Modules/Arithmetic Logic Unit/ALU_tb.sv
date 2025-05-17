`include "ArithmeticLogicUnit.sv"

module ALU_tb;
    reg [31:0] A, B;  // Actualizado a 32 bits
    reg [3:0] ALUOp;     // ALUOp permanece en 4 bits
    wire [31:0] ALURes; // Actualizado a 32 bits

    ArithmeticLogicUnit alu (.A(A), .B(B), .ALUOp(ALUOp), .ALURes(ALURes)); // Usando nombrado explícito en SystemVerilog
    
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);

        A = 32'b00000000000000000000000000000001;
        B = 32'b00000000000000000000000000001000;
        ALUOp = 4'b0000; // Suma
        #10;

        A = 32'b00000000000000000000000000000100;
        B = 32'b00000000000000000000000000000010;
        ALUOp = 4'b1000; // Resta
        #10;

        A = 32'b00000000000000000000000000000100;
        B = 32'b00000000000000000000000000000001;
        ALUOp = 4'b0100; // XOR
        #10;

        //Multiplicación
        A = 32'b00000000000000000000000000000100;
        B= 32'b00000000000000000000000000000010;
        ALUOp = 4'b1110; // Multiplicación
        #10;

        $finish;
    end
endmodule

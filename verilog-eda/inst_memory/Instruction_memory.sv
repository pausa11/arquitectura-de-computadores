module Instruction_memory(
    input  logic [31:0] Address,
    output logic [31:0] Instruction
);
    logic [7:0] Memory[255:0];

    // ⚠️ Leer el archivo .hex (1 byte por línea)
    initial begin
        $readmemh("Instruction_memory.hex", Memory);
    end

    // ✅ Construcción de instrucción en little-endian
    always_comb begin
        Instruction = {Memory[Address+3], Memory[Address+2], Memory[Address+1], Memory[Address]};
    end
endmodule

module DataMemory (
    input logic Clk,                 // Señal de reloj
    input logic [31:0] Address,      // Dirección para la memoria de datos
    input logic [31:0] DataWr,       // Datos a escribir en memoria
    input logic [2:0] DMCtrl,        // Señal de control para determinar el tipo de acceso
    input logic DMWr,                // Señal de habilitación de escritura
    output logic [31:0] DataRd       // Datos leídos de la memoria
);

    // Memoria RAM de 32 bits con tamaño ajustable
    logic [7:0] memory [1023:0];

    // Proceso para leer y escribir en la memoria
    always @* begin
        DataRd = 32'b0;
        case (DMCtrl)
            3'b000: begin // Read a byte
                DataRd = {{24{memory[Address][7]}}, memory[Address]}; // Extend the byte to 32 bits
            end
            3'b001: begin // Read a halfword (16 bits)
                DataRd = {{16{memory[Address + 1][7]}}, memory[Address + 1], memory[Address]};
            end
            3'b010: begin // Read a word (32 bits)
                DataRd = {memory[Address], memory[Address + 1], memory[Address + 2], memory[Address + 3]};
            end
            3'b100: begin
                DataRd[31:0] = {24'b0, memory[Address]}; // lb (U): load byte unsigned     
            end  	
            3'b101: begin 
                DataRd[31:0] = {16'b0, memory[Address + 1], memory[Address]}; // lh (U): load halfword unsigned
            end
            default: begin
                DataRd = 32'b0; // If something goes wrong, return 0
            end
        endcase
    end

    // Write data to memory
    always_ff @(posedge Clk) begin
        if (DMWr) begin
            case (DMCtrl)
                3'b000: // Write byte
                    memory[Address] <= DataWr[7:0]; // Only write the 8 least significant bits
                3'b001: // Write halfword (16 bits)
                    {memory[Address], memory[Address + 1]} <= DataWr[15:0];
                3'b010: // Write word (32 bits)
                    {memory[Address], memory[Address + 1], memory[Address + 2], memory[Address + 3]} <= DataWr;
            endcase
        end
    end
endmodule

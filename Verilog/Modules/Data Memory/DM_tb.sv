`include "DataMemory.sv"

module DM_tb;
    // Señales de prueba
    logic Clk;
    logic [31:0] Address;
    logic [31:0] DataWr;
    logic [2:0] DMCtrl;
    logic DMWr;
    logic [31:0] DataRd;

    // Instancia del módulo de memoria de datos
    DataMemory dataMemory (
        .Clk(Clk),
        .Address(Address),
        .DataWr(DataWr),
        .DMCtrl(DMCtrl),
        .DMWr(DMWr),
        .DataRd(DataRd)
    );

    // Generación de la señal de reloj
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

    // Proceso de prueba para monitorear instrucciones sw y lw
    initial begin
        $dumpfile("DM.vcd");
        $dumpvars(0, DM_tb);
        // Ejemplo de operación `sw`
        Address = 32'h00000000;
        DataWr = 32'h12345678;
        DMCtrl = 3'b010; // Acceso de palabra completa
        DMWr = 1'b1;     // Habilita escritura
        #10;
        $display("Time: %0t | sw x1, 0(x2) | Address: %h | DataWr: %h", $time, Address, DataRd);

        // Ejemplo de operación `lw` que lee desde la misma dirección
        DMWr = 1'b0;     // Deshabilita escritura
        #10;
        $display("Time: %0t | lw x1, 0(x2) | Address: %h | DataRd: %h", $time, Address, DataRd);

        // Cambia la dirección y escribe en 4(x2)
        Address = 32'h00000004;
        DataWr = 32'h87654321;
        DMWr = 1'b1;
        #10;
        $display("Time: %0t | sw x10, 4(x2) | Address: %h | DataWr: %h", $time, Address, DataRd);

        // Lee de nuevo en 0(x2) y 4(x2)
        DMWr = 1'b0;
        
        // Lectura en 0(x2)
        Address = 32'h00000000;
        #10;
        $display("Time: %0t | lw x1, 0(x2) | Address: %h | DataRd: %h", $time, Address, DataRd);

        // Lectura en 4(x2)
        Address = 32'h00000004;
        #10;
        $display("Time: %0t | lw x1, 4(x2) | Address: %h | DataRd: %h", $time, Address, DataRd);
        
        $finish;
    end
endmodule

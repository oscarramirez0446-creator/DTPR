`timescale 1ns / 1ps

module TB_DPTR;

reg clk;
reg rst; 

// Instancia del procesador con ambos puertos conectados
DPTR uut (
    .clk(clk),
    .rst(rst)
);

// Generación del reloj (Periodo de 10ns)
initial begin
    clk = 1'b0;
end

always begin
    #5 clk = ~clk;
end

// Bloque de estímulos (Reset inicial y simulación)
initial begin
    // Dar un pulso de reset al inicio para limpiar el PC y los buffers
    rst = 1'b1; 
    #10;        
    rst = 1'b0; // Apagar reset y arrancar procesador

    $display("Arquitectura De Computadoras");
    $display("Hardware funcionando");
    $display("Mi primera memoria");

    // Tiempo de simulación
    #120;

    $display("Me encanta esto");
    $display("FIN DE LA SIMULACION");
    $display("Adios");

    $stop;
end

endmodule
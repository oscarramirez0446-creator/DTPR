module TB_DPTR;

reg clk;

DPTR uut (
    .clk(clk)
);

initial
begin
    clk = 1'b0;
end

always
begin
    #5 clk = ~clk;
end

initial
begin
    $display("Arquitectura De Computadoras");
    $display("Hardware funcionando");
    $display("Mi primera memoria");

    // Tiempo suficiente para ejecutar
    // las 10 instrucciones:
    // 0, 4, 8, 12, 16, 20, 24, 28, 32, 36

    #120;

    $display("Me encanta esto");
    $display("FIN DE LA SIMULACION");
    $display("Adios");

    $stop;
end

endmodule
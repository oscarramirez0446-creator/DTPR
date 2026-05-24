module MemoriaDeInstrucciones (
    input [31:0] dir,
    output reg [31:0] Dsalida
);

reg [31:0] MEM [0:255];

initial begin
    $readmemb("memoria.txt", MEM);
end

always @(*) begin
    Dsalida = MEM[dir >> 2];
end

endmodule
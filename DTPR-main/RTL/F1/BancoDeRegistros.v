module BancoDeRegistros(
    input wire clk,
    input wire WE,
    input wire [4:0] AR1,
    input wire [4:0] AR2,
    input wire [4:0] AW,
    input wire [31:0] DW,
    output wire [31:0] DR1,
    output wire [31:0] DR2
);

reg [31:0] regis [31:0];

// Inicialización de registros
initial
begin
//Ponerlos en decimal!!!! Que sea menor al resultado que cabe en 32 bits
    regis[0]  = 32'b0;
    regis[1]  = 32'b0;
    regis[2]  = 32'b0;
    regis[3]  = 32'd3; //rs de la primera instruccion ADD en MemoriaDeInstrucciones
    regis[4]  = 32'd4; //rt de la primera instruccion ADD en MemoriaDeInstrucciones
    regis[5]  = 32'b0;
    regis[6]  = 32'b0; //rd de la primera instruccion ADD en MemoriaDeInstrucciones
    regis[7]  = 32'b0;
    regis[8]  = 32'b0;
    regis[9]  = 32'b0;
    regis[10] = 32'b0;
    regis[11] = 32'b0;
    regis[12] = 32'b0;
    regis[13] = 32'b0;
    regis[14] = 32'b0;
    regis[15] = 32'b0;
    regis[16] = 32'b0;
    regis[17] = 32'b0;
    regis[18] = 32'b0;
    regis[19] = 32'b0;
    regis[20] = 32'b0;
    regis[21] = 32'b0;
    regis[22] = 32'b0;
    regis[23] = 32'b0;
    regis[24] = 32'b0;
    regis[25] = 32'b0;
    regis[26] = 32'b0;
    regis[27] = 32'b0;
    regis[28] = 32'b0;
    regis[29] = 32'b0;
    regis[30] = 32'b0;
    regis[31] = 32'b0;
end

// Lectura
assign DR1 = (AR1 == 5'd0) ? 32'd0 : regis[AR1];
assign DR2 = (AR2 == 5'd0) ? 32'd0 : regis[AR2];

// Escritura
always @(posedge clk)
begin
    if (WE)
    begin
        if (AW != 5'd0)
        begin
            regis[AW] <= DW;
        end
    end
end

endmodule

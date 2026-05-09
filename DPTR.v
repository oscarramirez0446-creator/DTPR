module DPTR(
    input clk
);

// Señales internas

wire [31:0] instruccion;

wire [5:0] op;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [5:0] funct;

wire MemToReg;
wire RegWrite;
wire MemWrite;
wire MemRead;
wire [2:0] ALUop;

wire [2:0] ALU_Sel;

wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] ALU_Result;
wire [31:0] WriteData;

wire Zero;

reg [31:0] dir;

initial
begin
    dir = 32'd0;
end

always @(posedge clk)
begin
    dir = dir + 4;
end

// Memoria de Instrucciones

MemoriaDeInstrucciones MI (
    .dir(dir),
    .Dsalida(instruccion)
);

// Separación de campos de instrucción

assign opcode = instruccion[31:26];
assign rs     = instruccion[25:21];
assign rt     = instruccion[20:16];
assign rd     = instruccion[15:11];
assign shamt  = instruccion[10:6];
assign funct  = instruccion[5:0];

// Unidad de Control

UnidadDeControl U_ctrl (
    .op(op),
    .MemToReg(MemToReg),
    .RegWrite(RegWrite),
    .MemToWrite(MemToWrite),
    .MemToRead(MemToRead),	
    .ALUop(ALUop)
);

// ALU Control

ALU_Control A_ctrl (
    .ALUop(ALUop),
    .FNC(funct),
    .ALU_Sel(ALU_Sel)
);

// Banco de Registros

BancoDeRegistros BR (
    .clk(clk),	
    .WE(RegWrite),
    .AR1(rs),
    .AR2(rt),
    .AW(rd),
    .DW(WriteData),
    .DR1(ReadData1),
    .DR2(ReadData2)
);

// ALU

ALU alu (
    .A(ReadData1),
    .B(ReadData2),
    .ALUControl(ALU_Sel),
    .Resultado(ALU_Result),
    .Zero(Zero)
);

// Multiplexor alu memory

Multiplexor MUX (
    .A(ALU_Result),
    .B(32'b0),
    .sel(MemToReg),
    .Y(WriteData)
);
// Multiplexor reg inst

MultiplexorDos MUX2 (
    .A(DR2),
    .B(32'b0),
    .sel(B)
  
);
// Multiplexor instruction memory 

Multiplexor5a1 MUX5b (
    .A(rt),
    .B(rd),
    .select(AW)
  
);

endmodule
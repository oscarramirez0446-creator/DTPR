module DPTR(
    input clk,
    input rst
);

// CABLES DE RETORNO (WB -> ID)

wire wb_RegWrite;
wire [4:0]  wb_WriteReg;
wire [31:0] WriteData;

// ETAPA 1: FETCH (IF)

wire [31:0] if_pc_plus_4;
wire [31:0] instruccion; 
reg  [31:0] dir;         

always @(posedge clk or posedge rst) begin
    if (rst) dir <= 32'd0;
    else     dir <= if_pc_plus_4; 
end

assign if_pc_plus_4 = dir + 4;

MemoriaDeInstrucciones MI ( 
    .dir(dir),
    .Dsalida(instruccion)
);

// BUFFER 1: IF / ID

wire [31:0] id_pc_plus_4;
wire [31:0] id_instruccion;

buffer_IF_ID buf_if_id (
    .clk(clk), .rst(rst),
    .pc_plus_4_in(if_pc_plus_4),     .instruction_in(instruccion),
    .pc_plus_4_out(id_pc_plus_4),    .instruction_out(id_instruccion)
);

// ETAPA 2: DECODE (ID)

wire [5:0] op    = id_instruccion[31:26];
wire [4:0] rs    = id_instruccion[25:21];
wire [4:0] rt    = id_instruccion[20:16];
wire [4:0] rd    = id_instruccion[15:11];
wire [4:0] shamt = id_instruccion[10:6];
wire [5:0] funct = id_instruccion[5:0];

wire RegWrite, MemToReg, MemWrite, MemRead, ALUSrc, RegDst;
wire [2:0] ALUop;
wire [31:0] ReadData1, ReadData2, InmExt; 

UnidadDeControl U_ctrl ( 
    .op(op),
    .MemToReg(MemToReg),
    .RegWrite(RegWrite),
    .MemToWrite(MemWrite), 
    .MemToRead(MemRead),   
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .ALUop(ALUop)
);

BancoDeRegistros BR ( 
    .clk(clk),  
    .WE(wb_RegWrite),           
    .AR1(rs),
    .AR2(rt),
    .AW(wb_WriteReg),           
    .DW(WriteData),             
    .DR1(ReadData1),       
    .DR2(ReadData2)        
);

sign_extend sign_ext (
    .in_16(id_instruccion[15:0]), 
    .out_32(InmExt)
);

// BUFFER 2: ID / EX

wire ex_RegWrite, ex_MemToReg, ex_MemWrite, ex_MemRead, ex_ALUSrc, ex_RegDst;
wire [2:0]  ex_ALUop;
wire [31:0] ex_pc_plus_4, ex_ReadData1, ex_ReadData2, ex_InmExt;
wire [4:0]  ex_rt, ex_rd;

buffer_ID_EX buf_id_ex (
    .clk(clk), .rst(rst),
    .wb_regwrite_in(RegWrite), .wb_memtoreg_in(MemToReg),
    .m_memread_in(MemRead),    .m_memwrite_in(MemWrite),
    .ex_regdst_in(RegDst),     .ex_alusrc_in(ALUSrc),
    .ex_aluop_in(ALUop),
    .pc_plus_4_in(id_pc_plus_4),
    .read_data1_in(ReadData1), .read_data2_in(ReadData2),
    .imm_ext_in(InmExt),
    .rt_in(rt),                .rd_in(rd),
    
    .wb_regwrite_out(ex_RegWrite), .wb_memtoreg_out(ex_MemToReg),
    .m_memread_out(ex_MemRead),    .m_memwrite_out(ex_MemWrite),
    .ex_regdst_out(ex_RegDst),     .ex_alusrc_out(ex_ALUSrc),
    .ex_aluop_out(ex_ALUop),
    .pc_plus_4_out(ex_pc_plus_4),
    .read_data1_out(ex_ReadData1), .read_data2_out(ex_ReadData2),
    .imm_ext_out(ex_InmExt),
    .rt_out(ex_rt),                .rd_out(ex_rd)
);

// ETAPA 3: EXECUTE (EX)

wire [31:0] MuxALU_B, ALU_Result; 
wire [4:0]  WriteReg_ex;
wire [2:0]  ALU_Sel; 
wire Zero;           

ALU_Control A_ctrl ( 
    .ALUop(ex_ALUop), 
    .FNC(ex_InmExt[5:0]), 
    .ALU_Sel(ALU_Sel)
);

Multiplexor5a1 MUX5b ( 
    .A(ex_rt), 
    .B(ex_rd), 
    .select(ex_RegDst), 
    .Y(WriteReg_ex)     
);

MultiplexorDos MUX2 ( 
    .A(ex_ReadData2), 
    .B(ex_InmExt), 
    .sel(ex_ALUSrc), 
    .Y(MuxALU_B)       
);

ALU alu ( 
    .A(ex_ReadData1), 
    .B(MuxALU_B),
    .ALUControl(ALU_Sel), 
    .Resultado(ALU_Result), 
    .Zero(Zero)             
);

// BUFFER 3: EX / MEM

wire mem_RegWrite, mem_MemToReg, mem_MemWrite, mem_MemRead;
wire [31:0] mem_ALU_Result, mem_WriteData_Mem;
wire [4:0]  mem_WriteReg;

buffer_EX_MEM buf_ex_mem (
    .clk(clk), .rst(rst),
    .wb_regwrite_in(ex_RegWrite), .wb_memtoreg_in(ex_MemToReg),
    .m_memread_in(ex_MemRead),    .m_memwrite_in(ex_MemWrite),
    .alu_result_in(ALU_Result),   
    .write_data_in(ex_ReadData2), 
    .dest_reg_in(WriteReg_ex),
    
    .wb_regwrite_out(mem_RegWrite), .wb_memtoreg_out(mem_MemToReg),
    .m_memread_out(mem_MemRead),    .m_memwrite_out(mem_MemWrite),
    .alu_result_out(mem_ALU_Result), 
    .write_data_out(mem_WriteData_Mem),
    .dest_reg_out(mem_WriteReg)
);

// ETAPA 4: MEMORY (MEM)

wire [31:0] mem_ReadData_Mem;
assign mem_ReadData_Mem = 32'b0; 

// BUFFER 4: MEM / WB

wire wb_MemToReg;
wire [31:0] wb_ReadData_Mem, wb_ALU_Result;

buffer_MEM_WB buf_mem_wb (
    .clk(clk), .rst(rst),
    .wb_regwrite_in(mem_RegWrite),       .wb_memtoreg_in(mem_MemToReg),
    .read_data_mem_in(mem_ReadData_Mem), .alu_result_in(mem_ALU_Result),
    .dest_reg_in(mem_WriteReg),
    
    .wb_regwrite_out(wb_RegWrite),       .wb_memtoreg_out(wb_MemToReg),
    .read_data_mem_out(wb_ReadData_Mem), .alu_result_out(wb_ALU_Result),
    .dest_reg_out(wb_WriteReg)
);

// ETAPA 5: WRITE BACK (WB)

Multiplexor MUX ( 
    .A(wb_ALU_Result), 
    .B(wb_ReadData_Mem),
    .sel(wb_MemToReg), 
    .Y(WriteData) 
);

endmodule

module buffer_ID_EX (
    input wire clk,
    input wire rst,

    // --- ENTRADAS (Desde Decode) ---
    input wire wb_regwrite_in, wb_memtoreg_in,         
    input wire m_branch_in, m_memread_in, m_memwrite_in, 
    input wire ex_regdst_in, ex_alusrc_in,             
    input wire [2:0] ex_aluop_in,                       
    
    // Datos y Direcciones
    input wire [31:0] pc_plus_4_in,
    input wire [31:0] read_data1_in,
    input wire [31:0] read_data2_in,
    input wire [31:0] imm_ext_in,      
    input wire [4:0]  rs_in,           
    input wire [4:0]  rt_in,
    input wire [4:0]  rd_in,

    // --- SALIDAS (Hacia Execute) ---
    output reg wb_regwrite_out, output reg wb_memtoreg_out,
    output reg m_branch_out, output reg m_memread_out, output reg m_memwrite_out,
    output reg ex_regdst_out, output reg ex_alusrc_out,
    output reg [2:0] ex_aluop_out,                       
    
    output reg [31:0] pc_plus_4_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] imm_ext_out,
    output reg [4:0]  rs_out,
    output reg [4:0]  rt_out,
    output reg [4:0]  rd_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        {wb_regwrite_out, wb_memtoreg_out, m_branch_out, m_memread_out, m_memwrite_out} <= 5'b0;
        {ex_regdst_out, ex_alusrc_out} <= 2'b0;
        ex_aluop_out <= 3'b0;                            // <-- CORREGIDO A 3 BITS [cite: 156]
        pc_plus_4_out <= 32'b0; read_data1_out <= 32'b0; read_data2_out <= 32'b0;
        imm_ext_out <= 32'b0; rs_out <= 5'b0; rt_out <= 5'b0; rd_out <= 5'b0;
    end else begin
        wb_regwrite_out <= wb_regwrite_in; wb_memtoreg_out <= wb_memtoreg_in;
        m_branch_out <= m_branch_in; m_memread_out <= m_memread_in; m_memwrite_out <= m_memwrite_in;
        ex_regdst_out <= ex_regdst_in; ex_alusrc_out <= ex_alusrc_in;
        ex_aluop_out <= ex_aluop_in;                     // <-- PASA LOS 3 BITS [cite: 159]
        
        pc_plus_4_out <= pc_plus_4_in; read_data1_out <= read_data1_in; read_data2_out <= read_data2_in;
        imm_ext_out <= imm_ext_in; rs_out <= rs_in; rt_out <= rt_in; rd_out <= rd_in;
    end
end
endmodule

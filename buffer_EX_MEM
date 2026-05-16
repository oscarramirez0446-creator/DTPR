module buffer_EX_MEM (
    input wire clk,
    input wire rst,

    // --- ENTRADAS (Desde Execute) ---
    // Señales de Control
    input wire wb_regwrite_in, wb_memtoreg_in,
    input wire m_branch_in, m_memread_in, m_memwrite_in,
    
    // Datos y Resultados
    input wire [31:0] branch_target_in, // Resultado del sumador de saltos (PC + inmed<<2)
    input wire        zero_in,          // Flag zero de la ALU (para el beq)
    input wire [31:0] alu_result_in,    // Resultado de la ALU
    input wire [31:0] write_data_in,    // Dato a escribir en memoria (era read_data2)
    input wire [4:0]  dest_reg_in,      // Registro destino ya calculado (mux entre rt y rd)

    // --- SALIDAS (Hacia Memory) ---
    output reg wb_regwrite_out, output reg wb_memtoreg_out,
    output reg m_branch_out, output reg m_memread_out, output reg m_memwrite_out,
    
    output reg [31:0] branch_target_out,
    output reg        zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [4:0]  dest_reg_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {wb_regwrite_out, wb_memtoreg_out} <= 2'b0;
            {m_branch_out, m_memread_out, m_memwrite_out} <= 3'b0;
            branch_target_out <= 32'b0; zero_out <= 1'b0; alu_result_out <= 32'b0;
            write_data_out <= 32'b0; dest_reg_out <= 5'b0;
        end else begin
            wb_regwrite_out <= wb_regwrite_in; wb_memtoreg_out <= wb_memtoreg_in;
            m_branch_out <= m_branch_in; m_memread_out <= m_memread_in; m_memwrite_out <= m_memwrite_in;
            
            branch_target_out <= branch_target_in; zero_out <= zero_in;
            alu_result_out <= alu_result_in; write_data_out <= write_data_in;
            dest_reg_out <= dest_reg_in;
        end
    end
endmodule

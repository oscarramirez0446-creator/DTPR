module buffer_MEM_WB (
    input wire clk,
    input wire rst,

    // --- ENTRADAS (Desde Memory) ---
    // Señales de Control
    input wire wb_regwrite_in, wb_memtoreg_in,
    
    // Datos
    input wire [31:0] read_data_mem_in, // Lo que se leyó de la Data Memory (para lw)
    input wire [31:0] alu_result_in,    // El resultado de la ALU (pasó de largo por MEM)
    input wire [4:0]  dest_reg_in,      // A qué registro vamos a guardar

    // --- SALIDAS (Hacia Write Back / Register File) ---
    output reg wb_regwrite_out, output reg wb_memtoreg_out,
    output reg [31:0] read_data_mem_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  dest_reg_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_regwrite_out <= 1'b0; wb_memtoreg_out <= 1'b0;
            read_data_mem_out <= 32'b0; alu_result_out <= 32'b0; dest_reg_out <= 5'b0;
        end else begin
            wb_regwrite_out <= wb_regwrite_in; wb_memtoreg_out <= wb_memtoreg_in;
            read_data_mem_out <= read_data_mem_in; alu_result_out <= alu_result_in;
            dest_reg_out <= dest_reg_in;
        end
    end
endmodule

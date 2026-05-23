module buffer_IF_ID (
    input wire clk,
    input wire rst,
    
    // Entradas (Desde Fetch)
    input wire [31:0] pc_plus_4_in,
    input wire [31:0] instruction_in,
    
    // Salidas (Hacia Decode)
    output reg [31:0] pc_plus_4_out,
    output reg [31:0] instruction_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_plus_4_out   <= 32'b0;
            instruction_out <= 32'b0;
        end else begin
            pc_plus_4_out   <= pc_plus_4_in;
            instruction_out <= instruction_in;
        end
    end
endmodule

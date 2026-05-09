module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUControl,
    output reg [31:0] Resultado,
    output Zero
);

always @(*)
begin
    case(ALUControl)

        3'b010: Resultado = A + B; // ADD
        3'b110: Resultado = A - B; // SUB
        3'b000: Resultado = A & B; // AND
        3'b001: Resultado = A | B; // OR
        3'b111: Resultado = (A < B) ? 32'd1 : 32'd0; // SLT

        default: Resultado = 32'b0;

    endcase
end

assign Zero = (Resultado == 32'b0);

endmodule

module ALU_Control(
    input [2:0] ALUop,
    input [5:0] FNC,
    output reg [2:0] ALU_Sel
);

always @(*) 
begin
    case (ALUop)

        3'b010:
        begin
            case (FNC)

                6'b100000: ALU_Sel = 3'b010; // ADD
                6'b100010: ALU_Sel = 3'b110; // SUB
                6'b100100: ALU_Sel = 3'b000; // AND
                6'b100101: ALU_Sel = 3'b001; // OR
                6'b101010: ALU_Sel = 3'b111; // SLT

                default: ALU_Sel = 3'b000;

            endcase
        end

        default:
            ALU_Sel = 3'b000;

    endcase
end

endmodule
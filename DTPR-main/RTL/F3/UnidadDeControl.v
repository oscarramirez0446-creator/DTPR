module UnidadDeControl(
    input wire [5:0] op,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemToWrite, 
    output reg MemToRead,  
    output reg ALUSrc,
    output reg RegDst,
    output reg [2:0] ALUop,
    output reg Jump        
);

always @(*) begin
    // Valores por defecto para evitar latches indeseados
    MemToReg   = 1'b0;
    RegWrite   = 1'b0;
    MemToWrite = 1'b0;
    MemToRead  = 1'b0;
    ALUSrc     = 1'b0;
    RegDst     = 1'b0;
    ALUop      = 3'b000;
    Jump       = 1'b0;     

    case(op)
        // INSTRUCCIONES TIPO-R (Opcode 000000)
        6'b000000: begin 
            RegDst   = 1'b1;
            RegWrite = 1'b1;
            ALUop    = 3'b010; 
        end
        
        // INSTRUCCIONES TIPO-I (Fase 2)
        6'b100011: begin // LW
            ALUSrc    = 1'b1;
            MemToReg  = 1'b1;
            RegWrite  = 1'b1;
            MemToRead = 1'b1;
            ALUop     = 3'b000; 
        end
        
        6'b101011: begin // SW
            ALUSrc     = 1'b1;
            MemToWrite = 1'b1;
            ALUop      = 3'b000; 
        end
        
        6'b000100: begin // BEQ
            ALUop = 3'b110; 
        end

        // INSTRUCCIÓN TIPO-J (Fase 3)
        6'b000010: begin 
            Jump = 1'b1; 
        end
        
        default: begin
            // Si llega un Opcode desconocido, todo se queda en 0
        end
    endcase
end
endmodule
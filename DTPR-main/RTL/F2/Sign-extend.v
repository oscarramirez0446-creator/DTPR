module sign_extend (
    input wire [15:0] in_16,   // Recibe los 16 bits de la instrucción (Instruction[15:0])
    output wire [31:0] out_32  // Saca el valor extendido a 32 bits
);

    // Aplicamos exactamente la lógica de tu pizarrón
    // { {16 copias del bit 15} , los 16 bits originales }
    assign out_32 = { {16{in_16[15]}} , in_16 };

endmodule

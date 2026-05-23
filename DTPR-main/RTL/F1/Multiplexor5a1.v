module muxp_5b(
input wire [4:0] ins_1,
input wire [4:0] ins_2,
input wire select,
output reg [4:0] out_to_bank
);
always @(*) begin
    case (select)
        1'b0: out_to_bank= ins_1; 
        1'b1: out_to_bank = ins_2; 
        default: out_to_bank = 32'b0;
    endcase
end

endmodule


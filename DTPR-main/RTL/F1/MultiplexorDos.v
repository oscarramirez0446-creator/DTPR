module Multiplexor(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire sel,
    output reg [31:0] Y
);

always @(*)
begin
    case(sel)

        1'b0: Y = A;
        1'b1: Y = B;

        default: Y = A;

    endcase
end

endmodule

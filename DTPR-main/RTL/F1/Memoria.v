module Memoria(
    input wire clk,
    input wire WE,
    input wire [31:0] addr,
    input wire [31:0] WD,
    output reg [31:0] RD
);

reg [31:0] mem [0:1023];

always @(posedge clk)
begin
    if (WE)
    begin
        mem[addr[11:2]] <= WD;
    end

    RD <= mem[addr[11:2]];
end

endmodule

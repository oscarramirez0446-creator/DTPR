module pc (
input clk,
input [31:0] addnew,
output reg[31:0] address
);

always @(posedge clk)

begin

	address = addnew;
end

endmodule

module MemoriaDeInstrucciones (
input [31:0]dir,
output reg [31:0]Dsalida
);

//2.Declaracion de comp.

reg[7:0]MEM[0:255];

initial
begin
//ADD
MEM[0]=8'b00000000; // 000000 00011 00100 00110 00000 100000
MEM[1]=8'b01100100; // rs = 3 Es el registro("regis" en BancoDeRegistros) 3
MEM[2]=8'b00110000; // rt = 4 Es el registro 4
MEM[3]=8'b00100000; // rd = 6 Es el registro 6

MEM[4]=8'd8;
MEM[5]=8'd25;
MEM[6]=8'd98;
MEM[7]=8'd45;

//SUB
MEM[8]=8'd22;
MEM[9]=8'd65;
MEM[10]=8'd87;
MEM[11]=8'd41;
MEM[12]=8'd47;
MEM[13]=8'd88;
MEM[14]=8'd11;
MEM[15]=8'd59;

//AND
MEM[16]=8'd21;
MEM[17]=8'd01;
MEM[18]=8'd54;
MEM[19]=8'd75;
MEM[20]=8'd64;
MEM[21]=8'd91;
MEM[22]=8'd024;
MEM[23]=8'd55;

//OR
MEM[24]=8'd66;
MEM[25]=8'd28;
MEM[26]=8'd37;
MEM[27]=8'd12;
MEM[28]=8'd36;
MEM[29]=8'd42;
MEM[30]=8'd49;
MEM[31]=8'd27;

//SLT
MEM[32]=8'd81;
MEM[33]=8'd93;
MEM[34]=8'd99;
MEM[35]=8'd39;
MEM[36]=8'd10;
MEM[37]=8'd2;
MEM[38]=8'd5;
MEM[39]=8'd7;
end

always @*
begin
Dsalida={MEM[dir], MEM[dir+1], MEM[dir+2], MEM[dir+3]};
end

endmodule
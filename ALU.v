module P2_A (
	input [3:0]iA,
	input [3:0]iB,
	input iClk,
	input [4:0]iOp,
	output [4:0]oBanderas ,// usar if
	output [3:0] oResp
);

reg [4:0] rResp_D;
reg [4:0] rResp_Q;
reg [4:0] oBanderas_D;
reg [4:0] oBanderas_Q;
reg [3:0] rLRC;
reg [3:0] rR1;

reg [4:0]rparity_D;
reg [4:0]rparity_Q;


assign oResp = rResp_Q;
assign oBanderas = oBanderas_Q;


always @(posedge iClk)
begin
rResp_Q <= rResp_D;
oBanderas_Q <= oBanderas_D;
end 

always @ *
begin
case(iOp)
4'd0:rResp_D = iA - 1; // decremento 
4'd1:rResp_D = iA&iB; //and 
4'd2:rResp_D = iA|iB; //or 
4'd3:rResp_D = ~iA; //not 
4'd4:rResp_D = iA^iB; //nor 
4'd5:rResp_D = ~iA; //complemento A1
4'd6:rResp_D = iA<<<1; //aritmetico 
4'd7:rResp_D = iA>>>1 ; 
4'd8:rResp_D = iA<<1; //logico 
4'd9:rResp_D = iA>>1;
4'd10:rResp_D = (iA << iB) | ( iA >> ~iB); //rotacion left
4'd11:rResp_D = (iA >> iB) | ( iA >> ~iB); // Rotacion Rigth 
4'd12:rResp_D = iA + iB ; //suma 
4'd13:rResp_D = iA - iB; //resta
4'd14:rResp_D = iA * iB; //multiplicacion 
4'd15:rResp_D = iA/iB; //divicion 
4'd16:rResp_D = iA + 1;
endcase

//banderas carry, zero, sign, overflow y Pariedad
			
//negative en el bit mas significativo 
if((iA<iB ) && (iOp == 4'd13))
begin 
   oBanderas_D[0] = 1;
end
else 
begin 
  oBanderas_D [0] = 0;
end 

if ((rResp_Q==5'b0) | ( rResp_Q==5'b10000)) //zero
begin 
   oBanderas_D[1] = 1;
end
else 
begin 
  oBanderas_D [1] = 0;
end 

if ((iA[3]==5'b1 && iB[3]==5'b1 )) //carry 
begin
	oBanderas_D[2] = 1;
end 
else 
begin 
  oBanderas_D[2] = 0;
end 

if ((rResp_Q [4] == 5'b1)) //overflow 
begin 
	oBanderas_D[3] = 1;
end 
else 
begin 
  oBanderas_D[3] = 0;
end 

oBanderas_D[4] = (((rResp_Q[3]^rResp_Q[2])^rResp_Q[1])^rResp_Q[0]);


end
endmodule 


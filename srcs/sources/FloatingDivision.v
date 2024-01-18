`timescale 1ns / 1ps

module FloatingDivision#(parameter XLEN=32)
                        (input [XLEN-1:0]A,
                         input [XLEN-1:0]B,
                         output zero_division,
                         output [XLEN-1:0] result);

wire [7:0] Exponent;
wire [31:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7, result_unprotected;
wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3;

// zero division flag
assign zero_division = (B[30:23] == 0) ? 1'b1 : 1'b0;

/*----Initial value----       B_Mantissa * (2 ^ -1)            32 / 17 */
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1)); //verified
//                         48 / 17        -abs(temp1)
FloatingAddition A1(.A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.result(x0));

/*----First Iteration----*/
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2));
//                         +2            -temp2
FloatingAddition A2(.A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.result(temp3));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1));

/*----Second Iteration----*/
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4));
FloatingAddition A3(.A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.result(temp5));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2));

/*----Third Iteration----*/
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6));
FloatingAddition A4(.A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.result(temp7));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3));

/*----Reciprocal : 1/B----*/
assign Exponent = x3[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x3[22:0]};

/*----Multiplication A*1/B----*/
FloatingMultiplication M8(.A(A), .B(reciprocal), .result(result_unprotected));

assign result = ((A[30:23] == 0) || zero_division) ? 32'h0000_0000 : result_unprotected;
endmodule

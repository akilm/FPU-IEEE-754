# FPU-IEEE-754
Synthesizable Floating point unit written using Verilog. Supports 32-bit (Single-Precision) Multiplication, Addition and Division Operations based on the IEEE-754 standard for floating point numbers.
- FloatingAddition.v : For both addition and subtraction of single precision floating point numbers. For subtraction operation, invert the sign bit of the second operand. Values Truncated not rounded.
- FloatingMultiplication.v : For Multiplication of floating point numbers. Values Truncated not rounded.
- FloatingDivision.v : Uses **Newton Raphson** Iterations to find the reciprocal of the Divisor and then Multiplies the Reciprocal with the Dividend. Uses 8 multiplication instances and 3 addition instances
    ```
    Division Algorithm : A/B 
        Intial Seed : x0 = 48/17 - (32/17)*D
        where D - Divisor B adjusted to fit 0.5-1 range by replacing the exponent field with 8'd126
        
        Newton Raphson Iterations :
                      x1 = x0*(2-D*x0)
                      x2 = x1*(2-D*x1)
                      x3 = x2*(2-D*x2)
        x3 - Reciprocal of Adusted value D.
        Adjust the exponents to produce the final reciprocal of B 
        1/B : {B[31],x3[30:23]+8'd126-B[30:23],x3[22:0]}
        Final Value A*1/B
    ```
- FloatingSqrt.v :  Uses **Newton Raphson** Iterations to find the square root  
    ```
    Square root Algorithm : A^0.5
        A split into two parts -> M * 2^E
        A ^ 0.5 = (M * 2^E) ^ 0.5
                = M^0.5 * 2^(E/2)
        X = M^0.5 ; Z = 2^(E/2)
    M adjusted to fit the range 0.5-1 by replacing exponent with 8'd126 (actual exponent = 126-127 = -1).
        X = ( M * 1 )^0.5
        X = ( M * 2^(126-127) / 2^(126-127) ) ^0.5
        X = ( M* 2^(126-127)) ^ 0.5 / 2^(-0.5)
        X = ( M* 2^(126-127)) ^ 0.5 * 1/ 2^(-0.5)
        C = 1/ 2^(-0.5) is already known and multiplied at the end
        Y =  M* 2^(126-127)) ^ 0.5 is computed using Newton Raphson Iterations and Inserted in the equation
        thus X becomes -> X = Y*C
        2^(E/2) is basically exponent adjust and based on the value of E (Multiple of 2 or not), The resulting
        expression is multiplied by 2^(0.5) if the exponent is not a multiple of 2.
        values readjusted at the end.
        Intial Seed : x0 = 0.853553414345
        Newton Raphson Iterations :
                      x1 = 0.5*(x0 + X/x0)
                      x2 = 0.5*(x1 + X/x1)
                      x3 = 0.5*(x2 + X/x2)

        the exponent value of x3 is adjusted and multiplied with sqrt(2) if necessary to produce the final result.
    ```
**Note** : Rounding for all the modules in progress, currently the Least significant Bits are truncated to fit the field size.
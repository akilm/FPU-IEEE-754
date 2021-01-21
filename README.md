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
        Adjust the exponents to produce the final reciprocal of B = 1/B : {B[31],x3[30:23]+8'd126-B[30:23],x3[22:0]}
        Final Value A*1/B
    ```

**Note** : Rounding for all the modules in progress, currently the Least significant Bits are truncated to fit the field size.
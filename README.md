# RPN-30
Code contribution to Ashok Khanna's RPN-30 calculator for iOS 

Reverse Polish Notation (“RPN”) is a postfix mathematical notation in which operators (e.g., +, -, *, /) follow their operands (numbers). For example, RPN would calculate 5 + 3 as 5 3 +. (Polish Notation is a prefix mathematical notation in which operators precede their operands, and the previous example would be + 5 3.)

Quick RPN-30 tutorial: 
1. Basic operation is "M enter N operator" 
2. front and center value is x, upper left value is y, tiny upper right values are "the stack" 
3. enter pushes stack up, y to stack, x to y, and x replicated 
4. access to second functions by long tap 
5. access trig functions with the following codes
1=sin, 2=cos, 3=tan, 4=asin, 5=acos, 6=atan, 7=pi, 8=D-R 9=R-D
Operand -- enter -- trig code number -- [long tap] TRIG 
5. tap y to swap x and y 
6. tap most recent operation [below y] to undo 
7. tap x to backspace. 

One main virtue of RPN is avoiding parentheses. (7+8)*(6+5)= is 7e8+6e5+* three fewer keystrokes and the user can see the intermediate values. 

rpn i think is no parentheses

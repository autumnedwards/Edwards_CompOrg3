# Edwards_CompOrg3

Assume your Howard ID as a decimal integer is X. Let N = 26 + (X % 11) where % is the modulo
operation, and M = N – 10.
You will write a MIPS program that reads a string of up to 1000 characters from user input.
• With a single semicolon as the delimiter, split the input string into multiple substrings (with
the semicolon removed). If there is no semicolon in the input, the whole input string is
considered a substring referred to below.
• For each substring, remove the leading and trailing blank spaces and tab characters if any.
After that
o If the substring has zero characters or more than 4 characters or has at least one illegal
character (a character outside the set described below), the program prints a hyphen
"-" as an error message.
o If the substring has only the characters from '0' to '9' and from 'a' to β and from 'A' to
Δ, the program prints out the unsigned decimal integer corresponding to the base-N
number represented by the substring. β stands for the M-th lower case letter and Δ
stands for the M-th upper case letter in the English alphabet. In a base-N number, both
'a' and 'A' correspond to the decimal integer of 10, both 'b' and 'B' to 11, and so on, and
both β and Δ correspond to N – 1.
o If there are multiple substring, the numbers and the error message should be separated
by a single semicolon.
• The program must exit after processing one single user input.
• The processing of the whole input string must be done in a subprogram (Subprogram A,
must be labelled as sub_a). The main program must call Subprogram A and pass the string
address into it via the stack. Subprogram A parses the string and prints out the integers and
error messages one by one, with them separated by a single semicolon. No return value is
necessary from Subprogram A.
• When processing each substring, Subprogram A must call anothersubprogram (subprogram
B, must be labelled as sub_b), where the substring address is passed into Subprogram B via
the stack, and the decimal number or error message is returned to Subprogram A also via
the stack. 

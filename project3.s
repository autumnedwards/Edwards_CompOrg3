.data
userInput: .space 1000
invalid: .asciiz "-"

.text
main:
#must call Subprogram A and pass the string address into it via stack
addi $v0,8
la $a0,userInput
li $a1,1000
syscall

jal sub_a


#processing the string is done in Subprogram A
sub_a:
#must call Subprogram B and pass the substring address via stack


#processing the substring is done in Subprogram B
sub_b:
#decimal number or error message must be returned to Subprogram A via stack

j $ra

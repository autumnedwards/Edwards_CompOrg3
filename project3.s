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

#moving the userInput to $a0
move $s1,$a0

#pass data through the stack (caller)
addi $sp, $sp, -4
sw $fp, 0($sp)
add $fp, $sp, $zero
addi $sp, $sp, -4
sw $s1, 0($sp)
jal sub_a


#processing the string is done in Subprogram A
sub_a:
#must call Subprogram B and pass the substring address via stack
lw $t1, 0($sp)

#testing to see if the data was successfully passed to sub_a by printing the string 
li $v0,1
move $a0, $t1
syscall


#processing the substring is done in Subprogram B
s#ub_b:
#decimal number or error message must be returned to Subprogram A via stack

#j $ra

#syscall for ending the program
li $v0, 10 
syscall 

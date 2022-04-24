.data
userInput: .space 1001  #saves space for the l000 characters +1 (each character is 1 byte)
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

#syscall for ending the program
li $v0, 10 
syscall 


#processing the string is done in Subprogram A
sub_a:
#must call Subprogram B and pass the substring address via stack
lw $t1, 0($sp)

#moving the address of the string from register $t1 to $a1
move $a1, $t1

#create a counter register what will count the number of characters between the delimeter
li $t2,0
#create a variable for the delimeter, semicolon is 59 in decimal
li $t3, 59
#$t4 is the counter for the total characters (should not be more than 1000)
li $t4, 0
#create a variable where the bytes will be stored
li $t5, 0

parasString:

#lb $t5,$t4($a1)
add $t5, $t4, $a1 
lb $t5, ($t5)








bne $t4,1000 parasString



#testing to see if the data was successfully passed to sub_a by printing the string 
#li $v0,1
#move $a0,$t1
#syscall


#processing the substring is done in Subprogram B
#sub_b:
#decimal number or error message must be returned to Subprogram A via stack

#j $ra



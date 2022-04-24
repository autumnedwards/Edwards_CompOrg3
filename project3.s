#finding the base
#ID= @02992633
#02992633 % 11= 6
#base = 26 + 6 = 32



.data
userInput: .space 1001  #saves space for the l000 characters +1 (each character is 1 byte)
invalid: .asciiz "-"
subString: .space 1001 #saves space for 1000 characters +1 bc the entire string could technically be a substring at this point


.text
main:
#must call Subprogram A and pass the string address into it via stack

#gets the characters to read from the user input
addi $v0,8
la $a0,userInput
li $a1,1001
syscall

#moving the userInput to $a0
move $s1,$a0

#pass data through the stack (caller)
#frame pointer isn't needed b/c we only have one value to store but it is good practice
#addi $sp, $sp, -4
#sw $fp, 0($sp)
#add $fp, $sp, $zero
addi $sp, $sp, -4
sw $s1, 0($sp)
jal sub_a

#syscall for ending the program
li $v0, 10 
syscall 



          sub_a:  #sub program will move through the string and if it reaches a semicolon it will push the substring to sub_b
            
              move $s0, $ra #saving the return address
              lw $t1, 0($sp) #getting my input from the stack
              addi $sp, $sp, -4 #resetting the stack 

               
              move $a1, $t1 #moving the address of the string from register $t1 to $a1 (argument register)

            
              li $t2,1000 #create an index for the subString array (could be up to 1000 characters if there is no delimeter)
              
              li $t3, 59 #create a variable for the delimeter, semicolon is 59 in decimal
              
              li $t4, 0 #$t4 is the counter for the total characters (should not be more than 1000)
              
              li $t5, 0 #create a variable where the bytes will be stored

              parasString:
             
              beq $t4,1000, stop #when we have read all 1000 character stop
              #lb $t5,$t4($a1)
              add $t5, $t4, $a1 
              lb $t5, ($t5) #load character form string 
              bne $t5, $t3, again  #if the character is a semicolon jump to again
              j prep
              
            
              again:
              sb $t5, subString($t2)
              addi $t4,$t4,1 #increment the total character counter
              addi $t2, $t2,-1 #increment the subString counter 
              j parasString
              
              stop: #used to break the loop when it goes through all of the characters
              
              prep:
              la $a2, subString
              sw $?, 0($sp)
              jal sub_b





          



              #testing to see if the data was successfully passed to sub_a by printing the string 
              #li $v0,1
              #move $a0,$t1
              #syscall


              #processing the substring is done in Subprogram B
                        #sub_b:
                            #decimal number or error message must be returned to Subprogram A via stack

                            #j $ra



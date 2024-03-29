#finding the base
#ID= @02992633
#02992633 % 11= 6
#base = 26 + 6 = 32



.data
userInput: .space 1001  #saves space for the l000 characters +1 (each character is 1 byte)
invalidInput: .asciiz "-"
subString: .space 1001 #saves space for 1000 characters +1 bc the entire string could technically be a substring at this point
comma: .asciiz ","


.text
main:
#must call Subprogram A and pass the string address into it via stack

#gets the characters to read from the user input
addi $v0, $0,8
la $a0,userInput
li $a1,1001
syscall

#moving the userInput to $s1
move $s1,$a0


addi $sp, $sp, -4
sw $s1, 0($sp)
jal sub_a

#syscall for ending the program
li $v0, 10 
syscall 

    sub_a:  #sub program will move through the string and if it reaches a semicolon it will push the substring to sub_b
            
              move $s0, $ra
              lw $t1, 0($sp) #getting my input from the stack
              addi $sp, $sp, -16 #resetting the stack 
              sw $ra, 4($sp) #storing the return address in the stack
			   #move $a1, $t1 #moving the address of the string from register $t1 to $a1 (argument register)
              li $t2,0 #create an index for the subString array (could be up to 1000 characters if there is no delimeter)
              li $t3, 59 #create a variable for the delimeter, semicolon is 59 in decimal
              li $t4, 0 #$t4 is the counter for the total characters (should not be more than 1000)
              li $t5, 0 #create a variable where the bytes will be stored
	          li $s6, 0# create a counter for the substring 

              parasString:
             
                        beq $t4,1000, stop #when we have read all 1000 character stop
                        # beq $t4,10, stop #when it reaches the end (/n) stop
                        #lb $t5,$t4($a1)
                        # add $t5, $t4, $t1 
                        lb $t5, 0($t1) #load character form string 
                        beq $t5,10, newStatus
                        #check the 1st bit of the string
                        #li $v0, 1
                        #move $a0,$t5
                        #syscall
			
						bne $t5, $t3, again  #if the character is not a semicolon jump to again
                        j prep
              
            
              again:
                        sb $t5, subString($t2)
                        #check subString 
                        #lb $s7, subString($t2)
                        #li $v0, 1
                        #move $a0,$s7
                        #syscall
                        addi $t2, $t2,1 #increment the subString address counter
                        addi $t1, $t1, 1
                        #addi $s6, $s6, 1 #keeping track of where er are
                        j parasString

                newStatus:
                    li $s8, 5

                        stop: #used to break the loop when it goes through all of the characters
             
             prep:
                        addi $t1, $t1, 1
                        li $s7, 10
                        sb $s7, subString($t2) #storing the newLine character at the end of each substring 
                        la $a2, subString
                        move $s2, $a2
                        sw $s2, 0($sp)
                        sw $t1, 8($sp)
                        sw $t4, 12($sp)
                        jal sub_b
                        # lw $t1,8($sp)
                        # lw $ra,4($sp)
                        # lw $t4,12($sp)
                        # addi $sp, $sp, 16
			return:
                     beq $s3,-1,printInvalid
                     bge $s3,0, printSum

         
         
         printInvalid:
                     la $a0, invalidInput
                     li $v0, 4 
                     syscall 
		beq $s8, 5,done
                    li $t2, 0
                     beq $t1,10, done
                     beq $t4,1000, done
                     j printComma

         printSum:
                     li $v0, 1
                     move $a0,$s3
                     syscall
                     li $t2, 0
                     beq $t1,10, done
                     beq $t4,1000, done
                     beq $s8, 5,done
                     j printComma
         
         printComma:
                     la $a0, comma
                     li $v0, 4 
                     syscall 
                     j parasString
        out:
                    lw $t1,8($sp)
                    lw $ra,4($sp)
                    lw $t4,12($sp)
                    addi $sp, $sp, 16
                    j parasString


         done:
						move $ra, $s0
                        jr $ra
                     
                     sub_b: #sub_b should remove leading and trailing zeros, check to see if there are more than 4 or zero charachters, check to see if the inputs are in range/ valid, and convert valid characters to its base N equivalent
                            #decimal number or error message must be returned to Subprogram A via stack
                            #move $s3, $ra #saving the return address
                            lw $t6, 0($sp) #getting my input from the stack
                            addi $sp, $sp, -4 #resetting the stack 
                            
                            li $s4,0 #register where the bytes will be stored 
                            li $t8,0 #total character counter
                            li $t7, 0 #counter for the 4 character array after the leading and trailing blank spaces are removed

                            checkLeading:
                                      #lb $s4,$t8($t6)
                                      #add $s4, $t8, $t6
                                      lb $s4, 0($t6)
                                      #check to see if the string was passed to sub_b
                                      #li $v0, 1
                                      #move $a0,$s4
                                      #syscall

                                      beq $s4, 32, increment #if the byte is a space increment 
                                      beq $s4, 9, increment #if the byte is a tab increment 
                                      beq $s4, 10, invalid #if there are just blank spaces and a /n then it is invalid
                                      beq $t8, 1001, invalid #if the counter reaches all 1000 characters in the blank space counter it is invalid
                                      j checkCharacterRange 
                           increment:
                                     addi $t8, $t8, 1 #iterating the checkLeading counter 
                                     addi $t6, $t6, 1
                                     j checkLeading
                           
                           checkCharacterRange:
                                    beq $s4, 10, calculate
                                     blt $s4,58, possibleInt
                                     blt $s4, 87, possibleUpper
                                     blt $s4, 119 possibleLower
                                     bge $s4, 119, invalid

                                possibleInt:
                                     bge $s4, 48, integer
                                     blt $s4, 48, checklow
                           
                           possibleUpper:
                                     bge $s4, 65, uppercase
                                     blt $s4, 65, invalid
                           
                           possibleLower:
                                     bge $s4, 97, lowercase
                                     blt $s4, 97, invalid 
                                     
                           integer:
                                     addi $s4, $s4, -48
                                     j storeCharacter
                           
                           uppercase:
                                     addi $s4, $s4, -55
                                     j storeCharacter
                           
                           lowercase:
                                     addi $s4, $s4, -87
                                     j storeCharacter
                                     
                           checklow: #checking for spaces or tabs that are in between the substring inputs 
                                     
                                     beq $s4, 9, changeTab
                                     beq $s4, 10, changeNewLine
                                     beq $s4, 32, changeSpace
                                     blt $s4, 9, invalid
                                     bgt $s4, 10, invalid
                           
                           storeCharacter:
                                     beq $t7, 0, firstCharacter
                                     beq $t7, 1, secondCharacter
                                     beq $t7, 2, thirdCharacter
                                     beq $t7, 3, fourthCharacter
                           
                           firstCharacter:
                                     move $t2,$s4 #moving first character to first register
                                     j checkNextChar
     
                           secondCharacter:
                                     move $t3, $t2 #moving the first character to the second register 
                                     move $t2, $s4 #moving the second character to the first register
                                     j checkNextChar
                           
                           thirdCharacter:
                                     move $t4,$t3 #moving the first character to the third register
                                     move $t3,$t2 #moving the second character to the second register
                                     move $t2, $s4 #moving the third character to the first register 
                                     j checkNextChar
                           
                           fourthCharacter:
                                     move $t5,$t4 #moving the first character to the fourth register
                                     move $t4,$t3 #moving the second character to the third register
                                     move $t3, $t2 #moving the third character to the second register 
                                     move $t2, $s4 #moving the fourth character to the first register 
                                     j checkNextChar
                           checkNextChar:
                                     bgt $t7, 3, checkTrailing
                                     addi $t7, $t7, 1 #increments the counter 
                                     addi $t6, $t6, 1 #increments character counter
                                     lb $s4, 0($t6)
                                     j checkCharacterRange
                           
                    
                           
                           changeTab:
                                     li $s4, 150 #changing tab value to 150 (greater than 127)
                                     j checkTrailing 
                           
                           changeNewLine:
                                     li $s4, 152 #changing the newline character to 152 (greater than 127)
                                     j checkTrailing 
                           
                           changeSpace:
                                     li $s4, 151 #changing the space character to 151 (greater than 127)
                                     j checkTrailing 

                           checkTrailing:
                                     beq $s4, 150, increment2 #if there is a tab increment until it reaches a number or the end
                                     beq $s4, 151, increment2 #if there is a space increment until it reaches a number or the end
                                     blt $s4, 128, invalid #if there is a character that is not a space or tab then it is invalid 
                                     beq $s4, 152, calculate #if it reaches the /n character calculate 
                           
                           increment2:
                                     addi $t6, $t6, 1 #increments character counter
                                     lb $s4, 0($t6)
                                     beq, $s4, 9, changeTab #if tab, convert it to 150
                                     beq, $s4, 32, changeSpace #if space, convert it to 151
                                     beq, $s4, 10, changeNewLine #if /n, convert it to 152
                                     j checkTrailing
                
                           
                           calculate:
                                     li $t6, 30 #loading the base 
                                     li $t9, 900 #loading 32^2
                                     li $t8, 27000 #loading 32^3
                                     li $s5, 0 #initialize the register which will keep track of the sum
                                     
                                     one:
                                               move $s5,$t2 #move the value stored in register t2 to the sum register 
                                               beq $t7, 1, final #if there is only one value in the substring end
                                               bge $t7, 2, two #if there are two or more values in the substring continue converting 
                                     
                                     two:
                                               mult $t3, $t6 #multiplying value by 32 
                                               mflo $t1
                                               add $s5, $s5, $t1
                                               beq $t7, 2, final #if there are only two values in the substring end
                                               bge $t7, 3, three #if there are three or more values in the substring continue converting 

                                     three:
                                               mult $t4, $t9 #multiplying value by 32^2
                                               mflo $t1
                                               add $s5, $s5, $t1
                                               beq $t7, 3, final #if there are only three values in the substring end
                                               bge $t7, 4, four #if there are three or more values in the substring continue converting 
                                     
                                     four:
                                               mult $t5, $t8 #multiplying value by 32^3
                                               mflo $t1
                                               add $s5, $s5, $t1
                                               j final


                                    invalid:
                                              #sends invalid argument back to sub_a
                                              li $s3, -1 #$s3 is the return address 
                                              sw $s3, 0($sp)
                                              jr $ra
                                     
                                     final:
                                               #sends sum back to sub_a
                                               move $s3, $s5 #$s3 is the return address 
                                               
                                               #check the sum 
                                            #    li $v0, 1
                                            #    move $a0,$s3
                                            #    syscall
                                               sw $s3, 0($sp)
                                               jr $ra
                                               
                                               





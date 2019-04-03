
	.data
input:	.space 80
prompt:	.asciiz "\nSource > "
msg1:	.asciiz "\nResult > "
msg2:	.asciiz "\nReturn Value: >"
	.text
main:

#display the input prompt
        li $v0, 4		#system call for print_string
        la $a0, prompt		
        syscall

#read the input string
        li $v0, 8		#system call for read_string			
	la $a0, input		
	la $a1, 79		
	syscall


#call the change_letter
	la $a0, input
	jal change_letter
	move $s2, $v0 
	
		    	    
#display the output prompt and the string
        li $v0, 4		
        la $a0, msg1		
        syscall
        li $v0, 4		
        la $a0, input		
        syscall

	
#call the strlen func
	la $a0, input
	jal strlen
	move $s1,$v0
	
	li $v0, 4		#system call for print_string
        la $a0, msg2		
        syscall
        
        sub $s1, $s1, 1
	move $a0, $s1
	li $v0, 1
	syscall 
	
	
exit:	li 	$v0,10		#Terminate
	syscall

#----------------------------------------------------------------------------

strlen:
	sub $sp, $sp, 4
	sw $ra, 4($sp)
	
	li $t1, 0
count_loop:
	lbu $t2, ($a0)
	beqz $t2, strlen_exit
	addi $a0, $a0, 1
	addi $t1, $t1, 1
	j count_loop


strlen_exit:	
	move $v0, $t1
	lw $ra, 4($sp)
	add $sp, $sp, 4
	jr $ra  
#--------------------------------------------------------------------------

change_letter:
	sub $sp, $sp, 4
	sw $ra, 4($sp)

change_loop:
	lbu $t2, ($a0)
	beqz $t2, changeLetter_exit
	#branch if greater or equal to 48 and smaller than 58
	beq $t2, '0', change_to_asterisk # if ascii values is 0 jump 
	blt $t2, ':', checkGreater 
	bgt $t2, '0', checkLess
	addi $a0, $a0, 1
	j change_loop
	
checkGreater:
	bgt $t2, 47, change_to_asterisk
	addi $a0, $a0, 1
	j change_loop

checkLess:
	blt $t2, 58, change_to_asterisk
	addi $a0, $a0, 1
	j change_loop
	
change_to_asterisk:
	la $t2,42 
	sb $t2 ,0($a0)
	j change_loop
	
changeLetter_exit:	
	move $v0, $t1
	lw $ra, 4($sp)
	add $sp, $sp, 4
	jr $ra  
	

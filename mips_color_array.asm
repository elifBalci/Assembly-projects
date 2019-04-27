.eqv BMP_FILE_SIZE 120054 #change for 200*200  images
.eqv BYTES_PER_ROW 600

	.data
#space for the 600x50px 24-bits bmp image
.align 4
res:	.space 2
image:	.space BMP_FILE_SIZE
list:	.space 1280000 #40000 * 32 
file_name:	.asciiz "cur-02.bmp"
new_line: .asciiz "\n"
list_size:.word 40000
	.text
main:
	jal read_bmp
	
	li	$a0, 0	
	jal     get_color
	
	# args:	$t3 - list size , $t2 - 0, $t1 - list
	lw $t3, list_size
	li $t2, 0
	la $t1, list
	jal print_array

	li $v0, 10	#|
	syscall 	#|end program
	
#__________________________________________________________________________	
read_bmp:
#reads the contents of a bmp file into memory
#no args, no return value
	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,4($sp)
	sub $sp, $sp, 4		#push $s1
	sw $s1, 4($sp)
	
#open file
        la $a0, file_name	#file name 
        li $a1, 0		#flags: 0-read file
        li $a2, 0		#mode: ignored
        li $v0, 13		#open file 
        syscall
	move $s1, $v0      # save the file descriptor

	
#check for errors - if the file was opened
#...

#read file
	move $a0, $s1
	la $a1, image
	li $a2, BMP_FILE_SIZE
	li $v0, 14		#read from file
	syscall

#close file
	li $v0, 16
	move $a0, $s1
        syscall
	
	lw $s1, 4($sp)		#restore (pop) $s1
	add $sp, $sp, 4
	lw $ra, 4($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra

get_color:
	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,4($sp)

	la $t1, image + 10	#adress of file offset to pixel array
	lw $t2, ($t1)		#file offset to pixel array in $t2
	
	li  $t5, BMP_FILE_SIZE
	sub $t5, $t5, $t2 	# |how many green values are there 
	div $t5, $t5, 3		# |how many green values are there 
		
	la $t1, image		#adress of bitmap
	add $t2, $t1, $t2	#adress of pixel array in $t2
	
	la $t6, list      
#fill the array with green values
	add $t2, $t2, 1		 #first green 
	li $t3, 0		 # $t3 is the counter of loop
	li $t4, 0
loop_through_pixels:
	beq $t3, $t5, get_color_end
	mul $t4, $t3, 3		# $t4 = 3* $t3
	add $t4, $t2, $t4	# $t6 = $t4 + $t2
	lb $t1,($t4)		# load G 
	
	#save to array
	sb $t1, ($t6)
	add $t6, $t6, 4
	
	add $t3, $t3, 1
	j loop_through_pixels 
	
	
get_color_end:			
											
	lw $ra, 4($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra

# ============================================================================

# args:		$t3 - list size , $t2 - 0, $t1 - list
print_array: # print array content
	beq $t2, 40000, print_done  # check for array end
	lb $a0, ($t1)       # print list element
	li $v0, 1
	syscall
	
	la $a0, new_line        # print a newline
	li $v0, 4
	syscall
	
	addi $t2, $t2, 1      # advance loop counter
	addi $t1, $t1, 4      # advance array pointer
	b print_array               # repeat the loop
	
print_done:
		             # syscall #1 prints and integer to stdout
	lw $a0, ($t1)  	     # takes value via register $a0
	li $v0, 1      	     # takes 
	syscall 	     # via register $v0
	
	la $a0, new_line      # takes address of string via $a0
	li $v0, 4       # takes 
	syscall 	# via register $v0 syscall
	jr $ra
	
#____________________________________________________________________________________#





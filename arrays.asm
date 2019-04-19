	.data
list:	.space 1020
list_size:.word 255
new_line: .asciiz "\n"
	.text
main:	lw $s0, list_size    	# $s0 = array dimension
	la $s1, list      	# $s1 = array address
	li $t0, 0         	# $t0 = # elems init'd
	
	lw $a3, list_size	#|
	la $a1, list		#|for function call
	li $a2, 0		#|
	jal fill_array
	
	lw $a3, list_size	#|
	la $a1, list		#|for function call
	li $a2, 0		#|
	jal print_array
	
	li $v0, 10
	syscall 
	
#____________________________________________________________________________________#
	
# args:		$a3 - list size , $a2 - 0, $a1 - list
fill_array: # fill array content with zeros
	beq $a2, $a3, fill_array_done  # check for array end
	li $t4 55
	sw $t4, ($a1)
	#lw $a0, ($t1)       # print list element
	#li $v0, 1
	#syscall
	
	addi $a2, $a2, 1      # advance loop counter
	addi $a1, $a1, 4      # advance array pointer
	b fill_array               # repeat the loop
	
fill_array_done: 
		             # syscall #1 prints and integer to stdout
	lw $a0, ($a1)  	     # takes value via register $a0
	li $v0, 1      	     # takes 
	syscall 	     # via register $v0
	
	la $a0, new_line      # takes address of string via $a0
	li $v0, 4       # takes 
	syscall 	# via register $v0 syscall
	
	jr $ra
	
#____________________________________________________________________________________#

# args:		$a3 - list size , $a2 - 0, $a1 - list
print_array: # print array content
	beq $a2, $a3, print_done  # check for array end
	lw $a0, ($a1)       # print list element
	li $v0, 1
	syscall
	
	la $a0, new_line        # print a newline
	li $v0, 4
	syscall
	
	addi $a2, $a2, 1      # advance loop counter
	addi $a1, $a1, 4      # advance array pointer
	b print_array               # repeat the loop
	
print_done:
		             # syscall #1 prints and integer to stdout
	lw $a0, ($a1)  	     # takes value via register $a0
	li $v0, 1      	     # takes 
	syscall 	     # via register $v0
	
	la $a0, new_line      # takes address of string via $a0
	li $v0, 4       # takes 
	syscall 	# via register $v0 syscall
	jr $ra
	
#____________________________________________________________________________________#



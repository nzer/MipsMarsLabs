#[OP2] was implemented
.data
	msg_input: .asciiz "Enter string (max length - 10)\n"
	.align 2
	input: .space 11
	tire: .ascii "-"
.text	
	start:
	li $v0, 4
	la $a0, msg_input
	syscall
	li $v0, 8
	la $a0, input
	li $a1, 10
	syscall
	#reverse
	la $a0, input
	jal reverse
	lb $t1, input #load first byte
	lb $t2, tire
	beq $t1, $t2, quit
	#string out
	li $v0, 4
	la $a0, input
	syscall
	#quit
	quit:
	li $v0, 10
	syscall
	
	#$a0 - address
	reverse:
	move $t2, $a0
	move $t3, $zero #length
	#copy string to stack until null char
	reverse_to_stack_loop:
	lb $t1, ($a0)
	sb $t1, ($sp)
	addi $a0, $a0, 1
	addi $sp, $sp, -1
	addi $t3, $t3, 1
	bne $t1, $zero, reverse_to_stack_loop
	#now write back
	move $t4, $zero #index
	addi $sp, $sp, 2 #hack, ignore null terminator
	reverse_from_stack_loop:
	lb $t1, ($sp)
	sb $t1, ($t2)
	addi $t2, $t2, 1
	addi $sp, $sp, 1
	addi $t4, $t4, 1
	bne $t4, $t3, reverse_from_stack_loop
	move $t1, $zero
	sb $t1, ($t2) # last char is null terminator
	jr $ra

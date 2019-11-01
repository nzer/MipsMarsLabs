.data
	input_base: .asciiz "Type base\n"
	input_exp: .asciiz "Type power\n"
.text
	li $v0, 4
	la $a0, input_base
	syscall
	li $v0, 5
	syscall
	move $t1, $v0
	
	li $v0, 4
	la $a0, input_exp
	syscall
	li $v0, 5
	syscall
	move $t2, $v0

	#li $a0, 2
	#li $a1, 2
	move $a0, $t1
	move $a1, $t2
	jal pow
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

	# $a0 - base, $a1 exponent
	pow:
	# save $ra to stack
	addi $sp, $sp, -4
	sw $ra, ($sp)
	beq $a1, $zero, pow_zero # return 1 if exponent is zero
	addi $a1, $a1, -1
	jal pow
	mul $v0, $a0, $v0
	j pow_exit
	pow_zero:
	li $v0, 1
	j pow_exit
	pow_exit:
	# restore $ra from stack
	lw $ra, ($sp)
	addi $sp, $sp, 4
	# return
	jr $ra

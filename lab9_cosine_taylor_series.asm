.text
	li $a0, 14
	jal fact
	
	li $v0, 10
	syscall

	# cos(x)
	# args: $a0 - precision, $f12 - x
	# ret: $f0 - cosine
	cos:
	move $t0, $zero
	li $t1, 1
	mtc1 $t1, $f10 # initial value = 1
	cvt.d.w $f0, $f10
	cos_loop:
	# $f4 - current term, $f6 - x^2, $f8 - x!, $f10 - cosine value
	addi $t0, $t0, 1
	bge $t0, $a0, cos_loop
	jr $ra
	
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
	
	# args: $a0 - factorial
	# ret: $f0 - factorial value
	fact:
	move $t0, $zero
	li $t1, 1
	mtc1 $t1, $f0 # initial factorial value = 1
	cvt.d.w $f0, $f0
	bne $a0, $zero, fact_loop # continue to loop if factorial > 0
	jr $ra #return immediatly since 0! is defined to be 1
	fact_loop:
	addi $t1, $t0, 1
	mtc1 $t1, $f2
	cvt.d.w $f2, $f2
	mul.d $f0, $f0, $f2
	addi $t0, $t0, 1
	bne $t0, $a0, fact_loop
	jr $ra
	
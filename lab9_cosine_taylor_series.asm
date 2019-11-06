.data
	deg_to_rad: .double 0.0174533
.text
	main:
	li $v0, 5
	syscall
	li $t0, -1
	beq $t0, $v0, exit
	
	l.d $f0, deg_to_rad
	mtc1.d $v0, $f12
	cvt.d.w $f12, $f12
	mul.d $f12, $f12, $f0
	jal cos
	
	mov.d $f12, $f0
	li $v0, 3
	syscall
	
	exit:
	li $v0, 10
	syscall

	# cos(x)
	# args: $f12 - x
	# ret: $f0 - cosine
	cos:
	li $s0, 2 # index
	li $t1, 1
	mtc1 $t1, $f10 # initial value = 1
	cvt.d.w $f10, $f10
	li $s1, 0 # positive term bool
	cos_loop:
	# $f4 - current term, $f6 - x^2, $f8 - x!, $f10 - cosine value
	#POWER
	addi $sp, $sp, -4
	sw $ra, ($sp)
	mov.d $f20, $f12
	move $a1, $s0
	jal pow
	mov.d $f6, $f0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	#FACT
	addi $sp, $sp, -4
	sw $ra, ($sp)
	move $a0, $s0
	jal fact
	mov.d $f8, $f0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	#TERM
	div.d $f4, $f6, $f8
	abs.d $f4, $f4
	#negative if 0
	bnez $s1, skip_neg
	neg.d $f4, $f4
	li $s1, 1
	j skip_pos
	#positive if 1
	skip_neg:
	li $s1, 0
	skip_pos:
	
	#VALUE
	add.d $f10, $f10, $f4
	
	addi $s0, $s0, 2
	li $a0, 28
	ble $s0, $a0, cos_loop
	nop
	mov.d $f0, $f10
	jr $ra
	
	# $f20 - base, $a1 exponent
	# $f0 - return
	pow:
	mov.d $f0, $f20
	addi $a1, $a1, -1
	beqz $a1, pow_ret
	pow_loop:
	mul.d $f0, $f0, $f20
	addi $a1, $a1, -1
	bnez $a1, pow_loop
	pow_ret:
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
	

.data
	string: .asciiz "Hello"
	string_len: .word 5
	string_reversed: .asciiz "Hello"
.text
	la $a1, string
	la $a2, string_reversed
	lw $a3, string_len
	jal reverse
	la $a0, string_reversed
	jal print
	li $v0, 10
	syscall

	#$a1 - address $a2 - target address $a3 - length
	reverse:
	#find last address
	lw $t1, string_len
	#li $t2, 1
	#mul $t1, $t1, $t2
	add $a1, $a1, $t1
	addi $a1, $a1, -1
	#copy loop
	move $t1, $zero #index
	reverse_loop:
	lb $t2, ($a1)
	sb $t2, ($a2)
	addi $a1, $a1, -1
	addi $a2, $a2, 1
	addi $t1, $t1, 1
	bne $a3, $t1, reverse_loop
	jr $ra
	
	#$a0 - address
	print:
	li $v0, 4
	syscall
	jr $ra

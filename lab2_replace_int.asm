.data
	numbers: .word 21, 20, 51, 83, 20, 20
	length: .word 6
	x: .word 20
	y: .word 5
	
	space: .asciiz " "
	msg1: .asciiz "x="
	nl: .asciiz "\n"
.text
	lw $a0, length
	la $a1, numbers
	lw $a2, x
	lw $a3, y
	jal replace
	la $a1, numbers
	lw $a2, length
	jal print
	j exit
	
	# $a0 - length, $a1 - address, $a2 - search, $a3 - replacement
	replace:
	# $t0 - current index
	move $t0, $zero	
	loop:
	#t1 - current element
	lw $t1, 0($a1)
	bne $t1, $a2, skip
	sw $a3, ($a1) 
	skip:
	addi $a1, $a1, 4 #next address
	addi $t0, $t0, 1
	bne $t0, $a0, loop
	jr $ra
	
	#$a1 - address $a2 - length
	print:
	li $v0, 4 # print_string syscall code = 4 x=
	la $a0, msg1
	syscall
	move $t0, $zero	# $t0 - current index
	print_loop:
	li $v0, 1 # print int
	lw $a0, 0($a1)
	syscall
	li $v0, 4 # print space
	la $a0, space
	syscall
	addi $a1, $a1, 4 #next address
	addi $t0, $t0, 1 #increment index
	bne $t0, $a2, print_loop
	jr $ra
	
	exit:

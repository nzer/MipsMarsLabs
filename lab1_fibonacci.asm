.data
	fib: .word 0, 1, 0, 0, 0, 0
	line_end: '\n'
.text
	la $t0, fib # Pointer
	lw $t1, 0($t0) # n-2
	add $t0, $t0, 4
	lw $t2, 0($t0) # n-1
	
	# Fib number #1
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)
	
	# Fib number #2
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)
	
	# Fib number #3
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)
	
	# Fib number #4
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)
	
	# Fib number #5
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)

	# Fib number #6
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)
	
	# Fib number #7
	li $t3, 0
	add $t3, $t3, $t1
	add $t3, $t3, $t2
	 
	move $t1, $t2 # n-2
	move $t2, $t3 # n-1
	
	add $t0, $t0, 4 # move pointer and store
	sw $t3, 0($t0)
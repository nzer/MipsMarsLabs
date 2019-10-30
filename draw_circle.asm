.data
	DISPLAY: .space 16384  # 8*8*4, we need to reserve this space at the beginning of .data segment
	DISPLAYWIDTH: .word 64
	DISPLAYHEIGHT: .word 64
	RED: .word 0xff0000
	COLORS: .word 0xff0000, 0xff7f00, 0xffff00, 0x00ff00, 0x0000ff, 0x4b0082, 0x8b00ff
	
.text
   li $t6, 5
   loop:
   li $a0, 32
   li $a1, 32
   move $a2, $t6
   #load color
   subi $t7, $t6, 5
   sll $t7, $t7, 2 # mul by 4, $t7 is offset
   la $t8, COLORS
   add $t8, $t8, $t7 # add offset to base address
   lw $a3, ($t8)
   jal circleDraw

   addi $t6, $t6, 1   
   li $t7, 12 #ASSERT: $t7 - $t6 init must be 7
   bne $t6, $t7, loop
   #END LOOP
   
   li $v0, 10
   syscall
   
   #void circleRainbow(int x, int y, int radius, int color)
   # a0 - x, a1 - y, a2 - radius, a3 - color
   circleDraw:
	# s0 - x
	# s1 - y
	# s2 - r
	# s3 - color
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	# s4 - x
	# s5 - y
	# s6 - delta
	# s7 - error
	move $s4, $zero # x := 0
	move $s5, $s2 # y := R
	#delta := 1 - 2 * R
	li $s6, 2 
	mul $s6, $s6, $s2
	li $s7, 1
	sub $s6, $s7, $s6 
	move $s7, $zero #error := 0
	circleLoop:
	#draw
	# save $ra to stack
	addi $sp, $sp, -4
	sw $ra, ($sp)
	move $a2, $s3
	add $a0, $s0, $s4
	add $a1, $s1, $s5
	jal set_pixel_color
	add $a0, $s0, $s4
	sub $a1, $s1, $s5
	jal set_pixel_color
	sub $a0, $s0, $s4
	add $a1, $s1, $s5
	jal set_pixel_color
	sub $a0, $s0, $s4
	sub $a1, $s1, $s5
	jal set_pixel_color
	# restore $ra from stack
	lw $ra, ($sp)
	addi $sp, $sp, 4
	#draw end
	#Error
	# error = 2 * (delta + y) - 1
	# s4 - x
	# s5 - y
	# s6 - delta
	# s7 - error
	add $t4, $s6, $s5
	li $t5, 2
	mul $t4, $t4, $t5
	subi $t4, $t4, 1
	move $s7, $t4
	#Delta1
	bge $s6, $zero, skipDeltaError
	bgt $s7, $zero, skipDeltaError
	#delta += 2 * ++x + 1
	addi $s4, $s4, 1
	li $t4, 2
	mul $t4, $t4, $s4
	addi $t4, $t4, 1
	add $s6, $s6, $t4
	j circleLoopCont
	skipDeltaError:
	#Delta2
	ble $s6, $zero, skipDeltaError2
	ble $s7, $zero, skipDeltaError2
	#delta -= 2 * --y + 1
	subi $s5, $s5, 1
	li $t4, 2
	mul $t4, $t4, $s5
	addi $t4, $t4, 1
	sub $s6, $s6, $t4
	j circleLoopCont
	skipDeltaError2:
	#Delta3
	#delta += 2 * (++x - y--)
	addi $s4, $s4, 1 #++x 
	sub $t5, $s4, $s5 #++x - y--
	li $t4, 2 
	mul $t4, $t4, $t5 # 2 * (++x - y--)
	addi $s5, $s5, -1 #y--
	add $s6, $s6, $t4
	circleLoopCont:
	bge $s5, $zero, circleLoop
	jr $ra
	
   set_pixel_color:
	# Assume a display of width DISPLAYWIDTH and height DISPLAYHEIGHT
	# Pixels are numbered from 0,0 at the top left
	# a0: x-coordinate
	# a1: y-coordinate
	# a2: color
	# address of pixel = DISPLAY + (y*DISPLAYWIDTH + x)*4
	# y rows down and x pixels across
	# write color (a2) at arrayposition
	lw $t0, DISPLAYWIDTH
	mul $t0, $t0, $a1 	# y*DISPLAYWIDTH
	add $t0,$t0, $a0 	# +x
	sll $t0, $t0, 2 	# *4
	la $t1, DISPLAY 	# get address of display: DISPLAY
	add $t1, $t1, $t0	# add the calculated address of the pixel
	sw $a2, ($t1) 		# write color to that pixel
	jr $ra 			# return

.data
	msg_1: .asciiz "Enter integer:\n"
	msg_error: .asciiz "Overflow\n"
.text
  start:
  li $v0, 4
  la $a0, msg_1
  syscall
  li $v0, 5
  syscall
  move $s1, $v0
  
  li $v0, 4
  la $a0, msg_1
  syscall
  li $v0, 5
  syscall
  move $s2, $v0
  
  add $t0, $s1, $s2
  li $v0, 1
  move $a0, $t0
  syscall

.ktext 0x80000180
  #mfc0 $t0, $13
  #li $t1, 20
  #bne $t0, $t1, ex_throw
  li $v0, 4
  la $a0, msg_error
  syscall
  la $t0, start
  jalr $t0
  #li $v0, 10
  #syscall
  ex_throw:
  
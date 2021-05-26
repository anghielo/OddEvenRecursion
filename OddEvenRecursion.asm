# Assembly directives
.data
msg_stars: .asciiz "******************************************************************\n"
msg_greeting: .asciiz "This program will implement a recursive odd-even function in MIPS assembly.\n"
msg_newline: .asciiz "\n"
msg_space: .asciiz " "

msg_enter_integer: .asciiz "Enter integer: "
msg_the_answer_is: .asciiz "The answer is: "

divisor: .word 2
multiplier: .word 2


.text
main:
	jal procedureWelcomeMenu
	
	jal procedureUserInput
	
	# Move returned user input value to argument register location
	move $a0, $v0							# Move: $a0 = $v0
	
	jal procedureOddEvenRecursion
	
	# Move returned answer value to temporary register location
	move $t0, $v0							# Move: $t0 = $v0
	
	# Print msg_the_answer_is
	la $a0, msg_the_answer_is				# Load address: $a0 = @msg_the_answer_is
	li $v0, 4								# Load immediate code 4: print string service for $a0
	syscall									# Issue a system call to print
	
	# Move temporary register location to argument register location
	# Print number result
	move $a0, $t0							# Move $a0 = $t0
	li $v0, 1								# Load immediate code 1: print integer service for $a0
	syscall									# Issue a system call to print

	jal procedureExitMain


procedureWelcomeMenu:
	# Print msg_stars
	la $a0, msg_stars						# Load address: $a0 = @msg_stars
	li $v0, 4								# Load immediate code 4: print string service for $a0
	syscall									# Issue a system call to print

	# Print msg_greeting
	la $a0, msg_greeting					# Load address: $a0 = @msg_greeting
	li $v0, 4								# Load immediate code 4: print string service for $a0
	syscall									# Issue a system call to print

	# Print msg_stars
	la $a0, msg_stars						# Load address: $a0 = @msg_stars
	li $v0, 4								# Load immediate code 4: print string service for $a0
	syscall									# Issue a system call to print

	# Print msg_newline
	la $a0, msg_newline						# Load address: $a0 = @msg_newline
	li $v0, 4								# Load immediate code 4: print string service for $a0
	syscall									# Issue a system call to print

	jr $ra									# Jump register: return to caller


procedureUserInput:
	# Print msg_enter_integer
	la $a0, msg_enter_integer				# Load address: $a0 = @msg_enter_integer
	li $v0, 4								# Load immediate code 4: print string service for $a0
	syscall									# Issue a system call to print
	
	# Read integer
	li $v0, 5								# Load immediate code 5: $v0 = integer read from the user
	syscall									# Issue a system call to read integer
	
	jr $ra									# Jump register: return to caller

procedureOddEvenRecursion:
	# Add to stack
	addi $sp, $sp, -8						# Allocate memory in stack: $sp = $sp + (-8)
	sw $ra, 4($sp)							# Push value to stack: 4($sp) = $ra
	sw $a0, 0($sp)							# Push value to stack: 0($sp) = $a0
	
	# Base case
	beq $a0, 1, returnOne					# Branch equal: if ($a0 == 1) go to returnOne
		j else

	returnOne:
		addi $v0, $zero, 1					# Add immediate: $v0 = 0 + 1
		addi $sp, $sp, 8					# Deallocate memory in stack: $sp = $sp + 8
		jr $ra								# Jump register: return to caller

	else:
		# Load divisor to get remainder value 
		lw $t0, divisor						# Load word: $t0 = divisor
		divu $a0, $t0						# Divide Unsigned: $a0 / $t0 (store remainder in mfhi and quotient in mflo)
		
		# Move remainder to temporary location
		mfhi $t1							# Move from high to $t1
		
		# Setup argument to pass (n-1)
		addi $a0, $a0, -1					# Add immediate: $a0 = $a0 - 1
		
		# If remainder == 0 (even)
		beqz $t1, modEqualZero				# Branch equal zero: if ($t1 == 0) go to modEqualZero
			jal procedureOddEvenRecursion
			
			# Load multiplier to multiply values
			lw $t0, multiplier				# Load word: $t0 = multiplier
			
			# Complete the multiplication
			# (n-1) * 2
			multu $v0, $t0					# Multiply unsigned: $v0 * 2 (store value in mfhi and mflo)
			mflo $v0						# Move from low to $v0
			
			j beqzExit						# Jump to beqzExit

		modEqualZero:			
			jal procedureOddEvenRecursion
			
			# Complete the addition
			# (n-1) + 1
			add $v0, $v0, 1					# Add: $v0 = $v0 + 1

		beqzExit:

	# Remove from stack
	lw $a0, 0($sp)							# Pop value from stack: $a0 = 0($sp)
	lw $ra, 4($sp)							# Pop value from stack: $ra = 4($sp)
	addi $sp, $sp, 8						# Deallocate memory in stack: $sp = $sp + 8
	
	jr $ra									# Jump register: return to caller


procedureExitMain:
	# Exit program
	li $v0, 10								# Load immediate code 10: exit service for system
	syscall									# Issue a system call to stop program from running

# End of OddEvenRecursion.asm

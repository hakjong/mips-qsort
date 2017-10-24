## Quick sort
## 2012105056 Hakjong Son

######################## C code ###########################
#
#	void quick(int *arr, int left, int right) {
#		int l = left, r = right, p = left;
#		
#		while (l < r) {
#			while (arr[l] <= arr[p] && l < right)
#				l++;
#			while (arr[r] >= arr[p] && r > left)
#				r--;
#			if (l >= r) {
#				SWAP(arr[p], arr[r]);
#				quick(arr, left, r - 1);
#				quick(arr, r + 1, right);
#				return;
#			}
#			SWAP(arr[l], arr[r]);
#		}
#	}
#
###########################################################	
	
	.data
Array:		.word	86, 177, 40, 77, 60, 45, 136, 73, 57, 95, 8, 170, 98, 1, 158, 95, 150, 55, 68, 138, 85, 172, 61, 198, 135
Array_size:	.space	4
msg_before:	.asciiz	"before : "
msg_after:	.asciiz "after : "
msg_space:	.asciiz " "
msg_newL:	.asciiz "\n"

	.text
	.globl main

main:

# store the number of elements
	la		$t0, Array_size
	la		$t1, Array
	sub		$t2, $t0, $t1
	srl		$t2, $t2, 2
	sw		$t2, 0($t0)
	
# print "before : "
	li		$v0, 4
	la		$a0, msg_before
	syscall
# print Array
	jal		PRINT
	
# Call quick sort
	la		$a0, Array
	li		$a1, 0
	# a2 = Array_size - 1
	lw		$t0, Array_size
	addi	$t0, $t0, -1
	move	$a2, $t0
	# function call
	jal		QUICK
	
# print "after : "
	li		$v0, 4
	la		$a0, msg_after
	syscall
# print Array
	jal		PRINT

	
# end program
	li		$v0, 10
	syscall

PRINT:
## print Array
	la		$s0, Array
	lw		$t0, Array_size
Loop_main1:
	beq		$t0, $zero, Loop_main1_done
	# make space
	li		$v0, 4
	la		$a0, msg_space
	syscall
	# printing Array elements
	li		$v0, 1
	lw		$a0, 0($s0)
	syscall
	
	addi	$t0, $t0, -1
	addi	$s0, $s0, 4
	
	j		Loop_main1
	
Loop_main1_done:
	# make new line
	li		$v0, 4
	la		$a0, msg_newL
	syscall
	jr		$ra

QUICK:
## quick sort

# store $s and $ra
	addi	$sp, $sp, -24	# Adjest sp
	sw		$s0, 0($sp)		# store s0
	sw		$s1, 4($sp)		# store s1
	sw		$s2, 8($sp)		# store s2
	sw		$a1, 12($sp)	# store a1
	sw		$a2, 16($sp)	# store a2
	sw		$ra, 20($sp)	# store ra

# set $s
	move	$s0, $a1		# l = left
	move	$s1, $a2		# r = right
	move	$s2, $a1		# p = left

# while (l < r)
Loop_quick1:
	bge		$s0, $s1, Loop_quick1_done
	
# while (arr[l] <= arr[p] && l < right)
Loop_quick1_1:
	li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mult	$s0, $t7
	mflo	$t0				# t0 =  l * 4bit
	add		$t0, $t0, $a0	# t0 = &arr[l]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mult	$s2, $t7
	mflo	$t1				# t1 =  p * 4bit
	add		$t1, $t1, $a0	# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[l] <= arr[p]
	bgt		$t0, $t1, Loop_quick1_1_done
	# check l < right
	bge		$s0, $a2, Loop_quick1_1_done
	# l++
	addi	$s0, $s0, 1
	j		Loop_quick1_1
	
Loop_quick1_1_done:

# while (arr[r] >= arr[p] && r > left)
Loop_quick1_2:
	li		$t7, 4			# t7 = 4
	# t0 = &arr[r]
	mult	$s1, $t7
	mflo	$t0				# t0 =  r * 4bit
	add		$t0, $t0, $a0	# t0 = &arr[r]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mult	$s2, $t7
	mflo	$t1				# t1 =  p * 4bit
	add		$t1, $t1, $a0	# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[r] >= arr[p]
	blt		$t0, $t1, Loop_quick1_2_done
	# check r > left
	ble		$s1, $a1, Loop_quick1_2_done
	# r--
	addi	$s1, $s1, -1
	j		Loop_quick1_2
	
Loop_quick1_2_done:

# if (l >= r)
	blt		$s0, $s1, If_quick1_jump
# SWAP (arr[p], arr[r])
	li		$t7, 4			# t7 = 4
	# t0 = &arr[p]
	mult	$s2, $t7
	mflo	$t6				# t6 =  p * 4bit
	add		$t0, $t6, $a0	# t0 = &arr[p]
	# t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6				# t6 =  r * 4bit
	add		$t1, $t6, $a0	# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
# quick(arr, left, r - 1)
	# set arguments
	move	$a2, $s1
	addi	$a2, $a2, -1	# a2 = r - 1
	jal		QUICK
	# pop stack
	lw		$a1, 12($sp)	# load a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
# quick(arr, r + 1, right)
	# set arguments
	move	$a1, $s1
	addi	$a1, $a1, 1		# a1 = r + 1
	jal		QUICK
	# pop stack
	lw		$a1, 12($sp)	# load a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
# return
	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24	# Adjest sp
	jr		$ra

If_quick1_jump:

# SWAP (arr[l], arr[r])
	li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mult	$s0, $t7
	mflo	$t6				# t6 =  l * 4bit
	add		$t0, $t6, $a0	# t0 = &arr[l]
	# t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6				# t6 =  r * 4bit
	add		$t1, $t6, $a0	# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		Loop_quick1
	
Loop_quick1_done:
	
# return

	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24	# Adjest sp
	jr		$ra
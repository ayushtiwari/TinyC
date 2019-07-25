	.file	"asgn1.c"			# Source file name
	.section	.rodata			# Read only data section
	.align 8					# align with 8 byte boundary
.LC0:							# Label of fstring which will be printed later
	.string	"Enter the dimension of a square matrix: "
.LC1:							# Label of fstring for scanf
	.string	"%d"
	.align 8
.LC2:							# Label of fstring which will be printed later
	.string	"Enter the first matix (row-major): "
	.align 8
.LC3:							# Label of fstring which will be printed later
	.string	"Enter the second matix (row-major): "
.LC4:							# Label of fstring which will be printed later
	.string	"\nThe result matrix:"
.LC5:							# Label of fstring for scanf
	.string	"%d "
	.text						# Code starts
	.globl	main				# main is a global name
	.type	main, @function		# main starts
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp				# Save the current value of register rbp in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			# Store the value of rsp to rbp thereby initializing the stack frame
	.cfi_def_cfa_register 6
	subq	$4816, %rsp			# Allocate 4816 bytes of space on the stack

	###### Line 13 of the Program, the first print statement

	movl	$.LC0, %edi			# Load the address .LC0 to register edi for passing as argument
	movl	$0, %eax
	call	printf				# Push return address to the stack and jump to printf

	######...................#######

	###### Line 14 of the C Program, the scanf statement
	## After this the value of n will be stored at location current rbp-12

	leaq	-12(%rbp), %rax		# Make rax point to memory location rbp - 12
	movq	%rax, %rsi			# Make rsi point to wherever rax points
	movl	$.LC1, %edi			# Load the address .LC1 to register edi	for passing as argument
	movl	$0, %eax
	call	__isoc99_scanf		# Push return address to the stack and jump to scanf

	######...................#######

	###### Line 15 of the C Program, the printf statement
	## Ask the user to enter first matrix

	movl	$.LC2, %edi			# Load the address .LC2 to register edi for passing as argument
	movl	$0, %eax
	call	printf				# Push return address to the stack and jump to printf

	######...................#######

	###### Preparation to call ReadMat function

	# Move the value of n to eax
	movl	-12(%rbp), %eax		# Move the value pointed at address rbp - 12 to eax

	# Move the address to store array A to rdx
	leaq	-1616(%rbp), %rdx	# Make rdx point to address rbp - 1616

	movq	%rdx, %rsi			# Move value of rdx to rsi for passing as second arg to ReadMat
	movl	%eax, %edi			# Move value of eax to edi for passing as first arg to ReadMat
	call	ReadMat				# Push the return address to stack and

	######...................#######

	###### Line 17 of the C Program, the printf statement
	## Ask the user to enter second matrix

	movl	$.LC3, %edi			# Load the address .LC3 to register edi for passing as arg to printf
	movl	$0, %eax
	call	printf				# Push return address to stack and call printf

	######...................#######

	###### Preparation to call ReadMat function

	# Move the value of n to eax
	movl	-12(%rbp), %eax			# Move value at address rbp-12 to eax

	# Move the address to store array A to rdx
	leaq	-3216(%rbp), %rdx		# Move value at address rbp - 3216 to rdx

	movq	%rdx, %rsi			# Move value rdx to rsi for passing as second arg to ReadMat
	movl	%eax, %edi			# Move value of eax to edi to pass as first arg to ReadMat
	call	ReadMat				# Push return address to stack and jump to ReadMat

	######...................#######

	###### Preparation to call MatMult function

	# Move the value of n to eax
	movl	-12(%rbp), %eax			# Move value in rbp-12 to eax

	# Move the address to store C to rcx
	leaq	-4816(%rbp), %rcx		# Move address rbp - 4816 to rcx to pass as fourth arg to MatMult

	# Move the address of array B to rdx
	leaq	-3216(%rbp), %rdx		# Move address rbp - 3216 to rdx to pass as third arg to MatMult

	# Move the address of array A to rsi
	leaq	-1616(%rbp), %rsi		# Move address rbp - 1616 to rsi to pass as second arg to MatMult

	# Move the value of n to edi
	movl	%eax, %edi			# Move the value of eax to edi to pass as first arg to MatMult

	call	MatMult				# Push the return address to stack and call MatMult

	######...................#######

	###### Line 20 of the Program, the first puts statement

	movl	$.LC4, %edi			# Move the address .LC4 to edi
	call	puts				# Push the return address to stack and call puts

	######...................#######

	###### Start the for loop

	# rbp-4 stores the value of i
	movl	$0, -4(%rbp)		# Move the value of 0 to address rbp - 4
	jmp	.L2						# Jump to label .L2

.L5:
	###### Start the inner for loop

	# set the value of j to 0 --- rbp-8 stores j
	movl	$0, -8(%rbp)			# Make the value at address rbp-8 zero

	# Go to loop body
	jmp	.L3				# Jump to .L3
.L4:


	###### From this point onwards the code is to find the value of C[i][j] and load it to a register

	### Note : 1. C is stored in row major format
	### Note : 2. Each element in C is a word (4 bytes long)
	### NOte : 3. Each row of C is 20 words long

	### Therefore to access an element of C we can do this
	### Dereference ( Address of C * i * 80  +  4 * j)

	# Move the value of j to eax
	movl	-8(%rbp), %eax				# Move the value at address  rbp-8 to eax

	# Move the value of j to rcx
	movslq	%eax, %rcx					# Move doubleword from eax to rcx as quadword with sign extension

	# Move the value of i to eax
	movl	-4(%rbp), %eax				# Move the value at rbp-4 to eax

	# Move the value of i to rdx
	movslq	%eax, %rdx					# Move doubleword from eax to rdx as quadword with sign extension

	#######
	##! Important Note : at this point rcx = j and rdx = i
	########

	# Move the value of i to rax
	movq	%rdx, %rax					# Move the value of rdx to rax

	# Multipy i by 4, therefore rax = 4*i
	salq	$2, %rax					# Shift arithmetic left the value of rax i.e. rax = 4*rax

	# rax = 4*i + i = 5*i
	addq	%rdx, %rax					# Add the value of rdx to rax

	# rax = 4*5*i = 80*i
	salq	$2, %rax					# rax = 4*rax

	# rax = 80*i + j
	addq	%rcx, %rax					# rax = rcx + rax

	### Remember tha C is sotred at rbp-4816
	# Move the value at &C + 80*i + j + 4*j to eax
	# Now we have the value of eax as C[i][j]

	movl	-4816(%rbp,%rax,4), %eax	# *(rbp + rax*4 - 4816) goes to eax

	######...................#######


	###### Print statement of line 23 in C program, Printing C[i][j]

	movl	%eax, %esi					# Move the value of eax to esi to pass to function as second parameter
	movl	$.LC5, %edi					# Move the address .LC5 to edi to pass to function as first parameter
	movl	$0, %eax
	call	printf						# Push return address to stack and call printf

	######...................#######

	# Increment the value of j
	addl	$1, -8(%rbp)				# Add 1 to value at address rbp-8

.L3:

	# Move the value of n from memory to register eax
	movl	-12(%rbp), %eax			# Move the value at address rbp-12 to eax

	# See if n < j
	cmpl	%eax, -8(%rbp)			# Compare the value at eax to rbp-8

	# If condition satisfied
	jl	.L4							# if eax is smaller than value at address rbp-8 jump to .L4

	######...................####### End of inner for loop of main

	###### Line no. 23, Printing '\n'

	movl	$10, %edi				# if eax is greater, move 10 to edi to pass to putchar as its first arg
	call	putchar					# add 1 to value at address rbp-4

	######...................#######

	# Increment the value of i
	addl	$1, -4(%rbp)			# add 1 to value at address rbp - 4
.L2:

	# Move the value of 'n' to register eax
	movl	-12(%rbp), %eax			# Move the value at address rbp-12 to eax

	# Check if n < i
	cmpl	%eax, -4(%rbp)			# Compare the value at address rbp-4 to value in eax

	# If condition satisfied jump to inner loop
	jl	.L5							# if eax is less than value at address rbp-4 jump to .L5

	######...................####### End of outer for loop of main

	# If not get out of loop and return 0
	movl	$0, %eax				# if not, make eax = 0
	leave							# Set %rsp to %rbp then pop top of stack into %rbp
	.cfi_def_cfa 7, 8
	ret								# Pop return address from stack and jump there
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	ReadMat					# ReadMat is a global name
	.type	ReadMat, @function		# ReadMat start
ReadMat:
.LFB1:
	.cfi_startproc
	pushq	%rbp					# Save the previous base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# Make the value of rbp equal to rsp
	.cfi_def_cfa_register 6
	subq	$32, %rsp				# Allocate 32 bytes of space in memory


	######
	## Important Note : main function sends the matrix pointer in rsi
	##					and the value of n in edi
	######

	# Move the value of n to location current_rbp-20
	movl	%edi, -20(%rbp)			# Move the value of edi to address rbp-20

	# Move the value of pointer to data[][] to current_rbp-32
	movq	%rsi, -32(%rbp)			# Move the value of rsi to address rbp-32


	####
	# Note : At this point rbp-20 = n
	# Note : At this point rbp-32 ----> 2d array data
	####

	###### Begin the outer for loop of ReadMat

	# Set the value of i to 0
	movl	$0, -4(%rbp)			# Move the value 0 to address rbp-4
	jmp	.L8							# Jump to label .L8
.L11:

	###### Begin the inner for loop of ReadMat

	# Set j = 0
	movl	$0, -8(%rbp)			# Make the value at address rbp-8 0
	jmp	.L9							# Jump to label .L9
.L10:

	###### From this point onwards the code is to find the address of data[i][j] and load it to a register

	### Note : 1. data is stored in row major format
	### Note : 2. Each element in data is a word (4 bytes long)
	### NOte : 3. Each row of data is 20 words long

	### Therefore to access the address of element of data we can do this
	### Address of data * i * 80  +  4 * j

	# Move the value of i to eax
	movl	-4(%rbp), %eax			# Move the value at address rbp-4 to eax

	# Move the value of i to rdx
	movslq	%eax, %rdx				# Move the doubleword value of eax to rdx as quadword

	# Move the value of rdx to rax
	movq	%rdx, %rax				# Move the value at rdx to rax

	# rax = 4*i
	salq	$2, %rax				# rax = rax*4

	# rax = 4*i + i = 5*i
	addq	%rdx, %rax				# rax = rax + rdx

	# rax = 5*i * 16 = 80*i
	salq	$4, %rax				# rax = rax*16

	# rdx = rax
	movq	%rax, %rdx				# Move the value of rax to rdx

	# Move the pointer to d[0][0] to rax
	movq	-32(%rbp), %rax			# Move the value at address rbp-32 to rax

	# rdx = d + 80*i
	addq	%rax, %rdx				# Move the value of rax to rdx

	# Move the value of j to eax
	movl	-8(%rbp), %eax			# Move the value at address rbp-8 to eax

	# Move the value of j to rax
	cltq							# Convert doubleword in eax to quadword in rax

	# rax = 4*j
	salq	$2, %rax				# rax = rax*4

	# rax = rax + rdx = d + 80*i + 4*j
	addq	%rdx, %rax				# rax = rax + rdx

	####### This block represents the scanf Preparation in ReadMat

	movq	%rax, %rsi				# Move the value of rax to rsi to pass to function as seond parameter
	movl	$.LC1, %edi				# Move address .LC1 to edi to pass to function as first parameter
	movl	$0, %eax
	call	__isoc99_scanf			# Push return address to stack and call scanf

	######..........................#########

	# Increment the value of j
	addl	$1, -8(%rbp)			# Add 1 to value at address rbp-8
.L9:

	# Make eax = j
	movl	-8(%rbp), %eax			# Move the value at address rbp-8 to eax

	# Compare n and j
	cmpl	-20(%rbp), %eax			# Move the value at address rbp-20 to eax

	# If j < n jump to label .L10
	jl	.L10						# If less than jump to label .L10

	#######.................######### End of inner_for_loop of ReadMat

	# Increment i
	addl	$1, -4(%rbp)			# Add 1 to value at address rbp-4
.L8:

	# eax = i
	movl	-4(%rbp), %eax			# Move the value at address rbp-4 to eax

	# compare n and i
	cmpl	-20(%rbp), %eax			# Compare the value at address rbp-20 to eax

	# if i < n jump to inner_for_loop
	jl	.L11						# If less then jump to .L11

	# If false exit the loop and return
	leave							# Set %rsp to %rbp and pop the stack to %rbp
	.cfi_def_cfa 7, 8
	ret								# Jump to the return address stored in stack
	.cfi_endproc
.LFE1:
	.size	ReadMat, .-ReadMat
	.section	.rodata				# read only data
	.align 8						# aign with 8 bytes in memory
.LC6:								# label for f-string to be printed
	.string	"\nThe transpose of the second matrix:"
	.text							# code starts
	.globl	TransMat				# TransMat is a global name
	.type	TransMat, @function		# TransMat is a function
TransMat:
.LFB2:
	.cfi_startproc
	pushq	%rbp				# Save the value of previous base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			# Make the stack top as current base
	.cfi_def_cfa_register 6
	subq	$32, %rsp			# Allocate 32 bytes in memory to the function


	######
	# At this point you must know that the function TransMat was
	# Called by MatMult
	# The parameters passed were stored in rsi and edi
	# rsi stores address of B[0][0]
	# edi stores the value of n
	######


	# Move the value of n to rbp-20
	movl	%edi, -20(%rbp)			# Move the value at edi to address rbp-20

	# make rbp-32 point to B[0][0]
	movq	%rsi, -32(%rbp)			# Move the value at rsi to address rbp-32

	######## Begin outer_for_loop

	# Store i at rbp-4 and make it 0
	movl	$0, -4(%rbp)			# Move 0 to address rbp-4
	jmp	.L13				# Jump to .L13
.L16:
	######## Begin inner_for_loop
	# store j in address rbp-8 and make it zero
	movl	$0, -8(%rbp)			# Move the 0 to address rbp-8
	jmp	.L14						# Jump to .L14
.L15:

	###### From this point onwards the code is to find the address of data[i][j]
	###### data[j][i], thereafter swap the values stored at the adresses

	### Note : 1. Matrix data is stored in row major format
	### Note : 2. Each element in data is a word (4 bytes long)
	### NOte : 3. Each row of data is 20 words long

	### Therefore to access the address of element of data we can do this
	### Address of data * i * 80  +  4 * j

	# make eax = i
	movl	-4(%rbp), %eax			# Move the value at address rbp-4 to eax

	# rdx = i
	movslq	%eax, %rdx				# Move the doubleword in eax to rdx as quadword

	# rax = i
	movq	%rdx, %rax				# Move the value of rdx to rax

	# rax = 4*i
	salq	$2, %rax				# rax = rax * 4

	# rax = 4*i + i = 5*i
	addq	%rdx, %rax				# rax = rax + rdx

	# rax = 16 * 5 * i = 80*i
	salq	$4, %rax				# rax = rax * 16

	# rdx = 80*i
	movq	%rax, %rdx				# Move value in rax to rdx

	# rax = data
	movq	-32(%rbp), %rax			# Move the value at address rbp-32 to rax

	# rdx = data + 80*i
	addq	%rax, %rdx				# rdx = rdx + rax

	# eax = j
	movl	-8(%rbp), %eax			# Move the value at address rbp-8 to eax

	# rax = eax = j
	cltq							# Convert doubleword in eax to quadword in rax

	# eax = rdx + rax*4 = data + 80*i + 4*j
	movl	(%rdx,%rax,4), %eax		# eax = *(rdx + rax*4)

	# store the value of eax to rbp-12
	movl	%eax, -12(%rbp)			# *(rbp-12) = eax

	# eax = i
	movl	-4(%rbp), %eax			# eax = *(rbp-4)

	# rdx = i
	movslq	%eax, %rdx				# Move the doubleword in eax to rdx as quadword

	# rax = i
	movq	%rdx, %rax				# Move the value of rdx to rax

	# rax = 4*i
	salq	$2, %rax				# rax = rax * 4

	# rax = 4*i + i = 5*i
	addq	%rdx, %rax				# rax = rax + rdx

	# rax = 16*5*i = 80*i
	salq	$4, %rax				# rax = rax * 16

	# rdx = 80*i
	movq	%rax, %rdx				# Move the value at rax to rdx

	# rax = data
	movq	-32(%rbp), %rax			# Move the value at address rbp-32 to rax

	# rcx = address(data + 80*i)
	leaq	(%rdx,%rax), %rcx		# load the rdx + rax (address) to rcx

	# eax = j
	movl	-8(%rbp), %eax			# Move the value at address rbp-8 to eax

	# rdx = j
	movslq	%eax, %rdx				# Move the doubleword in eax to rdx as quadword

	# rax = j
	movq	%rdx, %rax				# Move the value of rdx to rax

	# rax = 4*j
	salq	$2, %rax				# rax = rax * 4

	# rax = 5*j
	addq	%rdx, %rax				# rax = rax + rdx

	# rax = 16*5*j = 80*j
	salq	$4, %rax				# rax = rax * 16

	# rdx = rax
	movq	%rax, %rdx				# rdx = rax

	# rax = data
	movq	-32(%rbp), %rax			# rax = *(rbp-32)

	# rdx = data + 80*j
	addq	%rax, %rdx				# rdx = rdx + rax

	# eax = i
	movl	-4(%rbp), %eax			# eax = *(rbp-4)

	# rax = eax = i
	cltq							# Convert doubleword in %eax to quadword in %rax

	# edx = rdx + rax*4 = data + 80*j + i
	movl	(%rdx,%rax,4), %edx		# edx = *(rdx + rax*4)

	# eax = j
	movl	-8(%rbp), %eax			# eax = *(rbp - 8)

	# rax = j
	cltq							# Convert doubleword in %eax to quadword in %rax

	### This is the 44th line of the code in C
	# value at rcx + rax*4 = edx
	# rcx + rax*4 = data + 80*i + 4*j
	# edx = value at data + 80*j + i
	# Therfore, data + 80*j + i  value is copied from data + 80*i + 4*j
	movl	%edx, (%rcx,%rax,4)		# *(rcx + rax*4) = edx

	# eax = j
	movl	-8(%rbp), %eax			# eax = *(rbp-8)

	# rdx = j
	movslq	%eax, %rdx				# rdx = eax

	# rax = j
	movq	%rdx, %rax				# rax = rdx

	# rax = 4*j
	salq	$2, %rax				# rax = 4 * rax

	# rax = 5*j
	addq	%rdx, %rax				# rax = rax + rdx

	# rax = 80*j
	salq	$4, %rax				# rax = 4*rax

	# rdx = 80*j
	movq	%rax, %rdx				# rdx = rax

	# rax = data
	movq	-32(%rbp), %rax			# rax = *(rbp-32)

	# rcx = address(data + 80*j)
	leaq	(%rdx,%rax), %rcx		# rcx = address (rdx + rax)

	# eax = i
	movl	-4(%rbp), %eax			# eax = *(rbp-4)

	# rax = eax = i
	cltq							# Convert doubleword in %eax to quadword in %rax

	# edx = value at data + 80*i + 4j
	movl	-12(%rbp), %edx			# *(rcx + rax*4) = edx

	# value at data + 80*j + 4i = value at data + 80*i + 4j
	movl	%edx, (%rcx,%rax,4)		# *(rcx + rax*4) = edx

	# increment j
	addl	$1, -8(%rbp)			# *(rbp-8) += 1

	######## End of inner_for_loop of TransMat
.L14:
	# Copy the value of j to register eax
	movl	-8(%rbp), %eax			# eax = *(rbp-8)

	# Compare the value of i with j
	cmpl	-4(%rbp), %eax			# Compare *(rbp-4) to eax

	# if j < i jump inside inner for loop
	jl	.L15						# Jump to label .L15

	addl	$1, -4(%rbp)			# add *(rbp-4) += 1
.L13:
	# Copy the value of i to register eax
	movl	-4(%rbp), %eax			# Move the value at address rbp-3 to eax

	# Compare the value of n with i
	cmpl	-20(%rbp), %eax			# Compare the value at address rbp-20 to value at eax

	# if i < n jump to inner_for_loop
	jl	.L16						# Jump to .L16 if less

	##### The following statement execute the print statement of TransMat

	movl	$.LC6, %edi				# Move the address .LC6 to edi to pass as argument to puts
	call	puts					# Push the return address to stack and call puts

	#####........................#####

	##### Outer for loop of Printing TransMat starts
	# i = o
	movl	$0, -4(%rbp)			# Move 0 to address rbp-4
	jmp	.L17						# Jump to .L17
.L20:
	# j = 0
	movl	$0, -8(%rbp)			# Move 0 to address rbp-8
	jmp	.L18						# Jump to .L18
.L19:

	###### From this point onwards the code is to find the address of data[i][j] and load it to a register

	### Note : 1. data is stored in row major format
	### Note : 2. Each element in data is a word (4 bytes long)
	### NOte : 3. Each row of data is 20 words long

	### Therefore to access the address of element of data we can do this
	### Address of data * i * 80  +  4 * j

	# eax = i
	movl	-4(%rbp), %eax			# Move the value at address rbp-4 to eax

	# rdx = i
	movslq	%eax, %rdx				# Move the doubleword value at eax to rdx as quadword

	# rax = i
	movq	%rdx, %rax				# Move the value at rdx to rax

	# rax = 4*i
	salq	$2, %rax				# rax = rax * 4

	# rax = 4*i+i= 5*i
	addq	%rdx, %rax				# rax = rax + rdx

	# rax = 16*5*i = 80*i
	salq	$4, %rax				# rax = rax * 16

	# rdx = rax = i
	movq	%rax, %rdx				# Move the value of rax to rdx

	# rax points to data
	movq	-32(%rbp), %rax			# Move the value at address rbp-32 to rax

	# rdx = data + 80*i
	addq	%rax, %rdx				# rdx = rax + rdx

	# eax = j
	movl	-8(%rbp), %eax			# Move the value at address rbp-8 to eax

	# rax = j
	cltq							# Convert doubleword in %eax to quadword in %rax

	# eax = value at data + 80*i + 4*j = data[i][j]
	movl	(%rdx,%rax,4), %eax		# Move the value at rdx + rax*4 to eax

	##### Prepare to print the value in eax that is data[i][j]
	movl	%eax, %esi				# Move the value of eax to esi
	movl	$.LC5, %edi				# Move address .LC5 to edi
	movl	$0, %eax
	call	printf					# Call printf

	#####..................#######

	# increment j
	addl	$1, -8(%rbp)			# Increment value at address rbp-8 by 1
.L18:
	# eax = n
	movl	-8(%rbp), %eax			# Move the value at address rbp-8 to eax

	# compare j and n
	cmpl	-20(%rbp), %eax			# Move the value at address rbp-20 to eax

	# if j < n jump to label
	jl	.L19						# Jump to label .L19

	#######..........######### End of inner for loop


	####### Prepare to print the '\n'
	movl	$10, %edi				# Move 10 to edi to pass to puchar
	call	putchar					# Push return pointer to stack and call puchar

	# increment i
	addl	$1, -4(%rbp)			# Add 1 to value at address at rbp-4
.L17:

	# eax = i
	movl	-4(%rbp), %eax			# Move the value at address rbp-4 to eax

	# compare n and i
	cmpl	-20(%rbp), %eax			# Compare the value at address rbp-20 to value at eax

	# if i < n jump to label
	jl	.L20						# If less jump to label .L20

	########.....................######### End of outer for loop

	leave							# Set %rsp to %rbp and pop top of stack into %rbp
	.cfi_def_cfa 7, 8

	# return to MatMult
	ret								# Return to the saved return address in stack
	.cfi_endproc
.LFE2:
	.size	TransMat, .-TransMat
	.globl	VectMult				# VectMult is a global name
	.type	VectMult, @function		# VectMult Starts
VectMult:
.LFB3:
	.cfi_startproc
	pushq	%rbp				# Push the current base pointer to stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			# Make rbp have the address of current stack top
	.cfi_def_cfa_register 6

	######
	# At this point you must know that the main function called this function
	# with rsi ---> secondMat array firstMat
	# with rdx ---> firstMat array secondMat
	# with edi = n
	######

	# Store the value of n at rbp-20
	movl	%edi, -20(%rbp)		# Move the value at edi to address rbp-20

	# rbp-32 stores address of firstMat
	movq	%rsi, -32(%rbp)		# *(rbp-32) = rsi

	# rbp-40 stores address of secondMat
	movq	%rdx, -40(%rbp)		# *(rbp-40) = rdx

	# Make result = 0
	movl	$0, -8(%rbp)		# *(rbp-8) = 0

	# Outer For Loop Begins
	# make i = 0
	movl	$0, -4(%rbp)		# *(rbp-4) = 0
	jmp	.L22					# Jump to label .L22
.L23:

	# eax = i
	movl	-4(%rbp), %eax		# eax = *(rbp-4)

	# rax = eax
	cltq						# Move the doubleword in eax to rdx as quadword

	# rdx = value at address 4*i
	leaq	0(,%rax,4), %rdx	# rdx = address (rax*4)

	# rax points to firstMat
	movq	-32(%rbp), %rax		# rax = *(rbp-32)

	# rax = firstMat + 4*i
	addq	%rdx, %rax			# rax = rdx + rax

	# edx = firstMat[i]
	movl	(%rax), %edx		# edx = *rax

	# eax = i
	movl	-4(%rbp), %eax		# eax = *(rbp-3)

	# rax = eax = i
	cltq						# Move the doubleword in eax to rdx as quadword

	# rcx = address of (rbp - 4*i)
	leaq	0(,%rax,4), %rcx	# rcx = address (rax*4)

	# rax points to secondMat
	movq	-40(%rbp), %rax		# rax = *(rbp-40)

	# rax = secondMat + 4*i
	addq	%rcx, %rax			# rax = rcx + rax

	# eax = secondMat[i]
	movl	(%rax), %eax		# eax = *(rax)

	# Multiply firstMat[i] with secondMat[i]
	imull	%edx, %eax			# eax = eax * edx

	# add answer to result
	addl	%eax, -8(%rbp)		# *(rbp-8) += eax

	# Increment i
	addl	$1, -4(%rbp)		# Increment *(rbp-4)
.L22:

	# eax = i
	movl	-4(%rbp), %eax		# eax = *(rbp-4)

	# compare n and i
	cmpl	-20(%rbp), %eax		# eax = *(rbp-20)

	# if i<n jump to label
	jl	.L23					# Jump to label .L23


	movl	-8(%rbp), %eax		# eax = *(rbp-8)
	popq	%rbp				# Pop rbp from stack
	.cfi_def_cfa 7, 8
	ret							# Jump to the saved return address from stack
	.cfi_endproc
.LFE3:
	.size	VectMult, .-VectMult
	.globl	MatMult				# matmult is global name
	.type	MatMult, @function	# function starts here
MatMult:
.LFB4:
	.cfi_startproc
	pushq	%rbp				# Push the previous base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			# Make rbp point to current stack top
	.cfi_def_cfa_register 6
	pushq	%rbx				# Push the current base pointer to stack
	subq	$56, %rsp			# Allocate 56 bytes of space in memory for this function
	.cfi_offset 3, -24

	######
	# At this point you must know that the main function called this function
	# with rsi ---> Matrix A
	# with rdx ---> Matrix B
	# with rcx ---> Matrix C
	# with edi = n
	######

	# Move the value of n to rbp-36
	movl	%edi, -36(%rbp)		# Move the value at edi to address rbp-36

	# Make rbp-48 point to A
	movq	%rsi, -48(%rbp)		# *(rbp-48) = rsi

	# Make rbp-56 point to B
	movq	%rdx, -56(%rbp)		# *(rbp-56) = rdx

	# Make rbp-64 point to C
	movq	%rcx, -64(%rbp)		# *(rbp-64) = rcx

	# Make rdx point to B
	movq	-56(%rbp), %rdx		# rdx = *(rbp-56)

	# Make eax = n
	movl	-36(%rbp), %eax		# eax = *(rbp-36)

	###### Prepare to call TransMat

	# Make rsi = address of B[0][0], Pass it as second argument
	movq	%rdx, %rsi			# rsi = rdx to pass to function as second param

	# Make eax = n, Pass it as first argument
	movl	%eax, %edi			# edi = eax to pass to TransMat as first param

	call	TransMat			# Push return address to stack and call TransMat

	#####..........................########

	##### Outer loop of MatMult starts

	# store i at rbp-20 and give it value 0
	movl	$0, -20(%rbp)		# *(rbp-20) = 0
	jmp	.L26					# Jump to label .L26
.L29:

	##### Inner loop of MatMult starts

	# store j at rbp-24 and give it value 0
	movl	$0, -24(%rbp)		# Make *(rbp-24) = 0
	jmp	.L27					# Jump to label .L27
.L28:

	###### From this point onwards the code is to find the address of M[i][j]
	###### and asign it the value returned by VectMult
	###### It will also find the adress of firstMat[i][0] and secondMat[j][0]

	### Note : 1. Matrix data is stored in row major format
	### Note : 2. Each element in M is a word (4 bytes long)
	### NOte : 3. Each row of M is 20 words long

	### Therefore to access the address of element of data we can do this
	### Address of M * i * 80  +  4 * j

	# eax = i
	movl	-20(%rbp), %eax		# eax = *(rbp-20)

	# rdx = eax = i
	movslq	%eax, %rdx			# Move the doubleword at eax to rdx as quadword

	# rax = i
	movq	%rdx, %rax			# rax = rdx

	# rax = 4*i
	salq	$2, %rax			# rax = rax*4

	# rax = 5*i
	addq	%rdx, %rax			# rax = rax + rdx

	# rax = 80*i
	salq	$4, %rax			# rax = rax * 16

	# rdx = rax = 80*i
	movq	%rax, %rdx			# rdx = rax

	# rax points to M
	movq	-64(%rbp), %rax		# rax = *(rbp-64)

	# rbx = M + 80*i
	leaq	(%rdx,%rax), %rbx	# rbx = address (rdx + rax)

	# eax = j
	movl	-24(%rbp), %eax		# eax = *(rbp-24)

	# rdx = j
	movslq	%eax, %rdx			# Move the doubleword at eax to rdx as quadword

	# rax = rdx = j
	movq	%rdx, %rax			# rax = rdx

	# rax = 4*j
	salq	$2, %rax			# rax = rax*4

	# rax = 5*j
	addq	%rdx, %rax			# rax = rax + rdx

	# rax = 80*j
	salq	$4, %rax			# rax = rax *16

	# rdx = 80*j
	movq	%rax, %rdx			# rdx = rax

	# rax points to secondMat
	movq	-56(%rbp), %rax		# rax = value at address(rbp-56)

	# rax = secondMat + 80*j
	addq	%rdx, %rax			# rax = rdx + rax

	# rsi = secondMat + 80*j
	movq	%rax, %rsi			# rsi = rax

	# eax = i
	movl	-20(%rbp), %eax		# eax = *(rbp-20)

	# rdx = i
	movslq	%eax, %rdx			# Move the doubleword at eax to rdx as quadword

	# rax = rdx = i
	movq	%rdx, %rax			# rax = rdx

	# rax = 4*i
	salq	$2, %rax			# rax = 4*rax

	# rax = 5*i
	addq	%rdx, %rax			# rax = rax + rdx

	# rax = 80*i
	salq	$4, %rax			# rax = 16*rax

	# rdx = rax
	movq	%rax, %rdx			# rdx = rax

	# rax points to firstMat
	movq	-48(%rbp), %rax		# rax = value at address (rbp-48)

	# rax = firstMat + 80*i
	addq	%rdx, %rax			# rax = rdx + rax

	# rcx = firstMat + 80*i
	movq	%rax, %rcx			# rcx = rax

	# eax = n
	movl	-36(%rbp), %eax		# eax = *(rbp-36)

	### Prepare to call VectMult

	movq	%rsi, %rdx			# rdx = rsi, pass to VectMult as third param
	movq	%rcx, %rsi			# rsi = rcx, pass to VectMult as second param
	movl	%eax, %edi			# edi = eax, pass to VectMult as first param
	call	VectMult			# Push return address to stack and call VectMult

	#### VectMult returns value in eax

	# edx = j
	movl	-24(%rbp), %edx		# Move the value at address rbp-24 to edx

	# rdx = j
	movslq	%edx, %rdx			# Move the doubleword at edx to rdx as quadword

	# store the value of eax to address rbx + rdx*4 = M + 80*i + 4*j
	movl	%eax, (%rbx,%rdx,4)		# *(rbp+rdx*4) = eax

	# Increment j
	addl	$1, -24(%rbp)		# Increment *(rbp-24)
.L27:

	# eax = j
	movl	-24(%rbp), %eax			# Move the value at address (rbp-24) to eax

	# compare n and j
	cmpl	-36(%rbp), %eax			# Compare the value at address (rbp-36) to eax

	# if j < n go back to inner loop
	jl	.L28						# Jump if less to label .L28

	###### End of inner for loop of MatMult

	# increment i by 1
	addl	$1, -20(%rbp)			# Increment *(rbp-20)
.L26:

	# eax = i
	movl	-20(%rbp), %eax				# Move the value at address rbp-20 to eax

	# Compare n with i
	cmpl	-36(%rbp), %eax				# Compare *(rbp-36) eax

	# if i < n jump to .L29
	jl	.L29							# Jump to label .L29

	######## End of outer for loop

	addq	$56, %rsp					# rsp = rsp + 56, deallocate memory
	popq	%rbx						# pop rbx from stack
	popq	%rbp						# pop rbp from stack
	.cfi_def_cfa 7, 8
	ret									# Return to the address stored at stack
	.cfi_endproc
.LFE4:
	.size	MatMult, .-MatMult
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-36)"
	.section	.note.GNU-stack,"",@progbits

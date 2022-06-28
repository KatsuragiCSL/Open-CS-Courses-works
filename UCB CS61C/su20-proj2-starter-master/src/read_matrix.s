.globl read_matrix

.data
test: .string "test\n"

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof,
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
		addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

		mv s0, a0
		mv s1, a1
		mv s2, a2

		# fopen
		mv a1, s0
		li a2, 0
		jal fopen
		# exit 50
		blt a0, x0, exit50

		# save a0 (file descriptor)
		mv s3, a0

		# fread 4 bytes into a1
		mv a1, s3
		mv a2, s1
		li a3, 4
		jal fread
		# exit 51
		blt a0, x0, exit51

		# fread 4 bytes into a2
		mv a1, s3
		mv a2, s2
		li a3, 4
		jal fread
		# exit 51
		blt a0, x0, exit51


		# mul *s1, *s2 -> malloc -> save the addr returned from malloc -> fread the matrix into the addr -> put addr into a0

		lw t1, 0(s1)
		lw t2, 0(s2)
		mul a0, t1, t2
		slli a0, a0, 2 # *4 for each int (4 bytes)


		jal malloc
		mv s4, a0 # addr from malloc

		mv a1, s3
		mv a2, s4
		lw t1, 0(s1)
		lw t2, 0(s2)
		mul a3, t1, t2
		slli a3, a3, 2 # *4 for each int (4 bytes)
		jal fread
		# exit 51
		blt a0, x0, exit51

		# close the file
		mv a1, s3
		jal fclose
		# exit 52
		blt a0, x0, exit52

		mv a0, s4


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
		addi sp, sp, 32


    ret

exit50:
		addi a0, x0, 50
		j exit

exit51:
		addi a0, x0, 51
		j exit

exit52:
		addi a0, x0, 52
		j exit

exit:
		addi a7, x0, 93
		ecall

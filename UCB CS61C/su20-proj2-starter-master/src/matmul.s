.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense,
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense,
#   this function exits with exit code 3.
#   If the dimensions don't match,
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, exit2
    blt a2, t0, exit2

    blt a4, t0, exit3
    blt a4, t0, exit3

    bne a2, a4, exit4


    # Prologue
    add t0, x0, x0 # outer loop counter
    add t1, x0, x0 # inner loop counter


outer_loop_start: #loop through rows of m0
    beq t0, a2, outer_loop_end



inner_loop_start: #loop through columns of m1
    beq t1, a5, inner_loop_end

    # save a0 - a4, t0, t1 and ra cuz need to call dot
    addi sp, sp, -32
    sw ra, 28(sp)
    sw a0, 24(sp)
    sw a1, 20(sp)
    sw a2, 16(sp)
    sw a3, 12(sp)
    sw a4, 8(sp)
    sw t0, 4(sp)
    sw t1, 0(sp)


    # prepare to call dot
    # length of vectors: c0 -> nothing need to do, a2 is fine
    # start of v0: m0 + t0*a2*4
    slli t2, a2, 2
    mul t2, t2, t0
    add a0, a0, t2
    # stride of v0: 1
    addi a3, x0, 1
    # start of v1: m1 + t1*4
    slli t3, t1, 2
    lw a1, 12(sp) #load a3(m1) to a1
    add a1, a1, t3
    # stride of v1: c1
    mv a4, a5

    jal dot

    # save the return value to t4
    mv t4, a0

    #restore a0 - a4, t0, t1 and ra
    lw ra, 28(sp)
    lw a0, 24(sp)
    lw a1, 20(sp)
    lw a2, 16(sp)
    lw a3, 12(sp)
    lw a4, 8(sp)
    lw t0, 4(sp)
    lw t1, 0(sp)


    # set (t0, t1) of d = a0
    # row
    slli t2, a5, 2
    mul t2, t2, t0
    add t2, a6, t2
    # column
    slli t3, t1, 2
    add t2, t2, t3
    # change the value in d
    sw t4, 0(t2)

    addi t1, t1, 1 # add 1 and go to the next column
    j inner_loop_start

inner_loop_end:
    add t1, x0, x0 # reset column counter
    addi t0, t0, 1 # go to next row
    j outer_loop_start


outer_loop_end:


    # Epilogue

    ret


exit2:
    addi a0, x0, 2
    j exit

exit3:
    addi a0, x0, 3
    j exit

exit4:
    addi a0, x0, 4
    j exit

exit:
    addi a7, x0, 93
    ecall

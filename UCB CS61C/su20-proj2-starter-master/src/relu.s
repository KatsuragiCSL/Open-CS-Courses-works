.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1,
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    # exit if length of vector < 1
    li t2, 1
    blt a1, t2, exit
    # save s0, s1, s2
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    add t0, x0, x0 #counter
    li t1, 4 #bytes

loop_start:
    beq a1, t0, loop_end
    mul t2, t0, t1 #offset from a0
    add t3, a0, t2 #addr of the value
    lw t4, 0(t3)
    bgt t4, x0, loop_continue #if the value > 0, nothing to do
    mul t4, x0, x0
    sw t4, 0(t3) #set the value to 0








loop_continue:
    addi t0, t0, 1
    j loop_start


loop_end:


    # Epilogue
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16

	ret

exit:
    addi a0, x0, 8
    addi a7, x0, 93
    ecall

.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1,
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
    li t2, 1
    blt a2, t2, exit5
    blt a3, t2, exit6

    mv t0, x0 #counter
    mv t6, x0 #sum
    li t1, 4 #bytes

loop_start:
    beq t0, a2, loop_end
    #calculate offset of v1
    mul t2, t0, a3
    mul t2, t2, t1
    add t2, a0, t2
    #calculate offset of v2
    mul t3, t0, a4
    mul t3, t3, t1
    add t3, a1, t3
    #add product to stored sum
    lw t2, 0(t2)
    lw t3, 0(t3)
    mul t4, t3, t2
    add t6, t6, t4
    #loop back
    addi t0, t0, 1
    j loop_start


loop_end:


    # Epilogue

    mv a0, t6
    ret

exit5:
    addi a0, x0, 5
    addi a7, x0, 93
    ecall

exit6:
    addi a0, x0, 6
    addi a7, x0, 93
    ecall

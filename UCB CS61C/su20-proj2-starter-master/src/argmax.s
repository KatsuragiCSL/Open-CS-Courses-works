.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1,
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    # exit with 7 if lenght of vector < 1
    li t2, 1
    blt a1, t2, exit
    # save s0, s1
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

    add t0, x0, x0 # counter
    mv t6, t0 #save the index
    # take first value
    lw t1, 0(a0)
    addi t2, x0, 4 #bytes

loop_start:
    beq t0, a1, loop_end
    mul t3, t0, t2 #offset
    add t4, a0, t3
    lw t5, 0(t4) # load the value

    bgt t5, t1, update_max



loop_continue:
    addi t0, t0, 1
    j loop_start

update_max:
    add t1, t5, x0
    mv t6, t0
    j loop_continue


loop_end:


    # Epilogue
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    mv a0, t6
    ret

exit:
    addi a0, x0, 7
    addi a7, x0, 93
    ecall

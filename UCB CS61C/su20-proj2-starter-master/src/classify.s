.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    #
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


# Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # check argc
    li t0, 5
    bne s0, t0, exit49

	# =====================================
    # LOAD MATRICES
    # =====================================







    # Load pretrained m0
    li a0, 8
    jal malloc
    mv s3, a0 # ptr to num of rows of m0

    lw a0, 4(s1) # ptr to file path
    mv a1, s3
    addi a2, s3, 4 # ptr to num of columns
    jal read_matrix

    mv s4, a0 # ptr to m0

    # Load pretrained m1
    li a0, 8
    jal malloc
    mv s5, a0 # ptr to num of rows of m1

    lw a0, 8(s1) # ptr to file path
    mv a1, s5
    addi a2, s5, 4 # ptr to num of columns
    jal read_matrix

    mv s6, a0 # ptr to m1



    # Load input matrix
    li a0, 8
    jal malloc
    mv s7, a0 # ptr to num of rows of input

    lw a0, 12(s1) # ptr to file path
    mv a1, s7
    addi a2, s7, 4 # ptr to num of columns
    jal read_matrix

    mv s8, a0 # ptr to input


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # 1. Linear layer

    # m0 dimensions
    lw a1, 0(s3)
    lw a2, 4(s3)
    # input dimensions
    mv a3, s8
    lw a4, 0(s7)
    lw a5, 4(s7)

    # size of m0 * input
    mul t0, a1, a5
    # malloc
    slli a0, t0, 2
    addi sp, sp -20
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw a5, 16(sp)
    jal malloc
    lw a5, 16(sp)
    lw a4, 12(sp)
    lw a3, 8(sp)
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp 20


    mv s9, a0 # ptr to malloc returned addr

    mv a6, a0
    mv a0, s4

    # matmul
    addi sp, sp, -4
    sw a6, 0(sp)
    jal matmul
    lw a6, 0(sp)
    addi sp, sp 4


    mv t0, a6 # ptr to m0 * input
    lw t1, 0(s3)
    lw t2, 4(s7)


    # 2. Nolinear layer
    # relu
    mv a0, t0
    mul a1, t1, t2

    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    jal relu
    lw t2 8(sp)
    lw t1 4(sp)
    lw t0 0(sp)
    addi sp, sp, 12



    # 3. linear layer
    # m1 dimensions
    lw a1, 0(s5)
    lw a2, 4(s5)
    # ReLU(m0*input) ptr
    mv a3, t0
    mv a4, t1
    mv a5, t2
    # size of the m1 * ReLU(m0 * input)
    mul t1, a1, a5
    # malloc
    slli a0, t1, 2

    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    jal malloc
    lw a5, 24(sp)
    lw a4, 20(sp)
    lw a3, 16(sp)
    lw a2, 12(sp)
    lw a1, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 28

    # matmul
    mv s0, a0
    mv a6, a0
    mv a0, s6 # ptr to m1

    addi sp, sp, -16
    sw t1, 0(sp)
    sw a1, 4(sp)
    sw a5, 8(sp)
    sw a6, 12(sp)
    jal matmul
    lw a6, 12(sp)
    lw a5, 8(sp)
    lw a1, 4(sp)
    lw t1, 0(sp)
    addi sp, sp, 16



    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1) # OUTPUT_PATH
    mv a2, a1
    mv a3, a5
    mv a1, a6

    # write matrix
    addi sp, sp, -8
    sw t1, 0(sp)
    sw a1, 4(sp)
    jal write_matrix
    lw a1, 4(sp)
    lw t1, 0(sp)
    addi sp, sp, 8






    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, a1
    mv a1, t1
    jal argmax
    mv s10, a0




    # Print classification
    bne s2, x0 done
    mv a1 s10
    jal print_int



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal done

exit49:
    addi a0, x0, 49
    j exit

exit:
    addi a7, x0, 93
    ecall

done:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    ret

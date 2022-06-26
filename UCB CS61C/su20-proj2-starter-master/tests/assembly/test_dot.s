.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9
stride0: .word 1
stride1: .word 1


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    addi s2 x0 9
    la s3, stride0
    lw s3, 0(s3)
    la s4, stride1
    lw s4, 0(s4)


    # Call dot function
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    jal ra, dot


    # Print integer result
    mv a1 a0
    jal ra print_int


    # Print newline
    li a1 '\n'
    jal ra print_char


    # Exit
    jal exit

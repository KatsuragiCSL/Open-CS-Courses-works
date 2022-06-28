.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    # malloc 4 bytes for s1
    li a0, 4
    jal malloc
    mv s1, a0

    # malloc 4 bytes for s2
    li a0, 4
    jal malloc
    mv s2, a0

    # read_matrix
    la a0, file_path
    mv a1, s1
    mv a2, s2
    jal read_matrix


    # Print out elements of matrix
    # a0 already the pointer to the matrix
    lw a1, 0(s1)
    lw a2, 0(s2)
    jal print_int_array



    # Terminate the program
    jal exit

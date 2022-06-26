.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output
r0: .word 3 #dimensions
c0: .word 3 #dimensions
r1: .word 3 #dimensions
c1: .word 3 #dimensions

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la a0, m0
    la a1, r0
    lw a1, 0(a1)
    la a2, c0
    lw a2, 0(a2)
    la a3, m1
    la a4, r1
    lw a4, 0(a4)
    la a5, c1
    lw a5, 0(a5)
    la a6, d

    # Call matrix multiply, m0 * m1
    jal matmul


    # Print the output (use print_int_array in utils.s)
    mv a0, a6 #pointer of array
    mv a1, a1 #num of rows
    mv a2, a5 #num of columns
    jal print_int_array




    # Exit the program
    jal exit

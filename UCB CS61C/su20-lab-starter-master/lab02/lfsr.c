#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t tmp;
    tmp = 1&(*reg);
    tmp ^= 1&(*reg >> 2);
    tmp ^= 1&(*reg >> 3);
    tmp ^= 1&(*reg >> 5);

    *reg >>= 1;
    *reg |= (tmp << 15); 
}

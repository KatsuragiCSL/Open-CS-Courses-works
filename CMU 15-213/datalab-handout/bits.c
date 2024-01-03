/* 
 * CS:APP Data Lab 
 * 
 * KatsuragiCSL
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
//1
/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
  /*xor = ~(a and b) and (a or b)
		= ~(a and b) and ~(~a and ~b)
  */
  return (~(x & y)) & (~(~x & ~y));
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
  /* tmin = 100...0 */
  int tmin;
  tmin = 1 << 31;
  return tmin;
}
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 2
 */
int isTmax(int x) {
  /* tmax + 1 = tmin
	 tmin ^ tmax = -1
	check whether ((x+1)^x) + 1 = 0
	exceptions: -1
    !(~x) = 1 if x = -1 else 0
  */
  return !(((x+1)^x) + 1) & !!(~x);
}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
  /* construct odd bits mask by shifting
     even bits mask =  ~ odd bits mask
     (x & odd bits mask) ^ even bits mask = -1
  */
  int oddMask, evenMask;
  oddMask = 0b10101010;
  oddMask = (oddMask << 8) | oddMask;
  oddMask = (oddMask << 16) | oddMask;
  evenMask = ~oddMask;
  
  int minusOne = (oddMask & x) ^ evenMask;
  return !(minusOne + 1);
}
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {
  return ~x+1;
}
//3
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
  /* split into 2 parts: x-0x30 >= 0? and 0x39 - x >=0?
     x-a can be done by x + negate(a)
     x>=0 can be done by checking the 31st bit: !(x>>31)
  */
  int firstPart = !((x + (~(0x30) + 1)) >> 31);
  int secondPart = !((0x39 + (~x + 1)) >> 31);
  return firstPart & secondPart;
}
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
  /* check if x = 0 => if no then return y & -1 = y else return z & -1 = z
     it can be done by returning (y & (mask)) ^ (z & (~mask)) where mask = -1 when x != 0 and 0 when x = 0
  */
  int mask = ((!!x)<<31)>>31;
  return (y & mask) ^ (z & (~mask));
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
  /* equiv. to check y-x >= 0
     different sign => over/ underflow
     same sign => OK

     different sign casses:
     - y >= 0, x < 0 => always true
     - y < 0, x >= 0 => always false
  */
  int sameSignCmp = !( (y + (~x + 1)) >> 31); // 1 iff y-x >=0;
  int signX = !(x >> 31); // 1 iff x >= 0
  int signY = !(y >> 31); // 1 iff y >= 0
  int isSameSign = !(signX ^ signY); // 1 iff same sign
  return (isSameSign & sameSignCmp) | (!signX & signY);
}
//4
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x) {
  /* negate(x) | x has 1 as its 31st bit when x != 0. Otherwise 0.
  */
  return (~((~x + 1) | x) >> 31) & 1;
}
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
  /* positive -> add a leading 0
     negative -> remove duplicated leading 1's
     e.g. 5 -> 0101 -> 4 bits
         -5 -> 111...1011 -> 1011 -> 4 bits
     Hence,
     positive -> pos of leading 1 + 1
     negative -> bit flip -> pos of leading 1 + 1
     To find pos of leading 1:
     binary search, shifting x to right by 16, 8, 4, 2, 1 and add it to the result if there is 1's.
  */
  int signX = x >> 31; // -1 if x < 0, 0 if x >= 0
  int xNormalized = (x & ~signX) | (~x & signX); // if x is negative, bit flip.
  
  int bin16 = (!!(xNormalized >> 16)) << 4; // 16 if higher 16 bits of x is non-zero, 0 otherwise.
  xNormalized >>= bin16;

  int bin8 = (!!(xNormalized >> 8)) << 3;
  xNormalized >>= bin8;

  int bin4 = (!!(xNormalized >> 4)) << 2;
  xNormalized >>= bin4;

  int bin2 = (!!(xNormalized >> 2)) << 1;
  xNormalized >>= bin2;

  int bin1 = !!(xNormalized >> 1);
  xNormalized >>= bin1;

  int bin0 = !!xNormalized;

  return bin16 + bin8 + bin4 + bin2 + bin1 + bin0 + 1;
}
//float
/* 
 * float_twice - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_twice(unsigned uf) {
  /* if uf is denorms, returns uf (+/-inf * 2 = +/-inf, NaN * 2 = NaN)
     if uf is norms, need to consider incrementing E when M >= 2
     no needs for rounding, cuz uf * 2 always ends with 0 and hence rounded to even
  */
  unsigned int sign = 0x80000000 & uf;
  unsigned int exp = 0x7f800000 & uf;
  unsigned int frac = 0x7fffff & uf;

  if (((~exp) & 0x7f800000) == 0) {
    return uf;
  } else {
    if (exp == 0) { // near 0, only increment exp if frac > 0.5
      if ((0x400000 & uf) != 0) {
        exp = 0x800000;
      }
      frac = frac << 1;
    } else { // always increment exp, if the result beyond the rangeand become inf, set frac to 0
      exp += 0x800000;
      if (((~exp) & 0x7f800000) == 0) {
        frac = 0;
      }
    }
  }
  return sign | exp | frac;
}
/* 
 * float_i2f - Return bit-level equivalent of expression (float) x
 *   Result is returned as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point values.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_i2f(int x) {
  /* 1. find pos of leftmost 1 (except sign bit), denote as i. exp = (30-i) + 127
     2. sign = 31st bit (count from right to left, starts from index 0)
     3. take the bits at pos [[i, i-22]] as frac
     4. rounding: if [[7, 0]] is greater than 2^7, or if [[7, 0]] = 127 and 8th bit = 1, then increment frac.
     exceptions: 0 and tmin
     don't need to consider the case when exp = 0, cuz x is int
  */
  unsigned int sign = 0x80000000 & x;
  unsigned int frac;
  unsigned int exp;

  if (x == 0) {
    return x;
  }
  if (x == 0x80000000) { // -2^31 -> sign = 1, exp = 31+127=158, frac = 0
    return sign | (158 << 23) | 0;
  }
  // normal cases
  if (sign) {
    x = -x;
  }
  int i = 30;
  while (!(x >> i)) {
    i--;
  }
  exp = i + 127;
  x = x << (31-i);
  frac = (x >> 8) & 0x7fffff; //first shift x so that the leading 1 is at the 31st bit, then ignore the lowest 8 bits
  // rounding
  if (((x & 0xff) > 128) || ( ((x & 0xff) == 128) && (frac & 1)) ) {
    frac += 1;
  }
  // check if M >= 2;
  if (frac >> 23) {
    exp += 1;
    frac = frac & 0x7fffff;
  }
  return sign | (exp << 23) | frac;
}
/* 
 * float_f2i - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int float_f2i(unsigned uf) {
  /* 1. check denorms: if exp = 111...1, return 0x80000000u.
     2. check denorms: if exp = 0, result always less than 0 so returns 0.
     3. norms: E = exp - 127. If E < 0, result < 0 and hence return 0. Else take the highest E bits of frac, followed by attaching a leading 1 (i.e 2^E + (frac << (23-E)))
        if E >= 31, overflows.
     4. attach the sign.
  */
  
  unsigned int sign = 0x80000000 & uf;
  unsigned int exp = 0x7f800000 & uf;
  unsigned int frac = 0x7fffff & uf;

  if (exp == 0b11111111) {
    return 0x80000000u;
  } else if (exp == 0) {
    return 0;
  } else {
    exp = exp >> 23;
    if (exp < 127) {
      return 0;
    } else {
      int E = exp - 127;
      if (E >= 31) {
        return 0x80000000u;
      }
      if (E > 23) { // no need to truncate frac
        int result = (frac << E) + 1<<E;
        return sign? -result: result;
      } else {
        frac = frac >> (23-E);
        int result = frac + 1<<E;
        return sign? -result: result;
      }
    }
  }
}

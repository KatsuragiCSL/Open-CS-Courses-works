/* 
 * trans.c - Matrix transpose B = A^T
 *
 * Each transpose function must have a prototype of the form:
 * void trans(int M, int N, int A[N][M], int B[M][N]);
 *
 * A transpose function is evaluated by counting the number of misses
 * on a 1KB direct mapped cache with a block size of 32 bytes.
 */ 
#include <stdio.h>
#include "cachelab.h"

int is_transpose(int M, int N, int A[N][M], int B[M][N]);

/* 
 * transpose_submit - This is the solution transpose function that you
 *     will be graded on for Part B of the assignment. Do not change
 *     the description string "Transpose submission", as the driver
 *     searches for that string to identify the transpose function to
 *     be graded. 
 */
char transpose_submit_desc[] = "Transpose submission";
void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{
    if (M == 32 && N ==32) {
        for (int i = 0; i < 32; i += 8) {
            for (int j = 0; j < 32; j += 8) {
                for (int ii = i; ii < i + 8; ii++) {
                    int tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8;
                    tmp1 = A[ii][j+0];
                    tmp2 = A[ii][j+1];
                    tmp3 = A[ii][j+2];
                    tmp4 = A[ii][j+3];
                    tmp5 = A[ii][j+4];
                    tmp6 = A[ii][j+5];
                    tmp7 = A[ii][j+6];
                    tmp8 = A[ii][j+7];

                    B[j+0][ii] = tmp1;
                    B[j+1][ii] = tmp2;
                    B[j+2][ii] = tmp3;
                    B[j+3][ii] = tmp4;
                    B[j+4][ii] = tmp5;
                    B[j+5][ii] = tmp6;
                    B[j+6][ii] = tmp7;
                    B[j+7][ii] = tmp8;
                }
            }
        }
    } else if (M == 64 && N == 64) {
        // main issue is the last 4 rows of B evicts the first 4 rows of B
        // solution: transpose the 4x4 submatrices in the 8x8 submatrix, put the 4x4 submatrix A_{12} in B_{12} (instead of B_{21}) cuz B_{21} is already in cache when writing B_{11}.
        // then move B_{12} to B_{21} (causing 4 cold misses) row by row and transfer A_{21} to B_{12} (another 4 cold misses)
        // finally transfer A_{22}
        int tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8;
        for (int i = 0; i < 64; i += 8) {
            for (int j = 0; j < 64; j += 8) {
                for (int ii = i; ii < i + 4; ii++) {
                    tmp1 = A[ii][j+0];
                    tmp2 = A[ii][j+1];
                    tmp3 = A[ii][j+2];
                    tmp4 = A[ii][j+3];
                    tmp5 = A[ii][j+4];
                    tmp6 = A[ii][j+5];
                    tmp7 = A[ii][j+6];
                    tmp8 = A[ii][j+7];

                    B[j+0][ii] = tmp1;
                    B[j+1][ii] = tmp2;
                    B[j+2][ii] = tmp3;
                    B[j+3][ii] = tmp4;
                    B[j+0][ii+4] = tmp5;
                    B[j+1][ii+4] = tmp6;
                    B[j+2][ii+4] = tmp7;
                    B[j+3][ii+4] = tmp8;
                }
                for (int jj = j; jj < j + 4; jj++) {
                    // A_{21} to B_{12}
                    tmp1 = A[i+4][jj];
                    tmp2 = A[i+5][jj];
                    tmp3 = A[i+6][jj];
                    tmp4 = A[i+7][jj];
                    // B_{12} to B_{21}
                    tmp5 = B[jj][i+4];
                    tmp6 = B[jj][i+5];
                    tmp7 = B[jj][i+6];
                    tmp8 = B[jj][i+7];

                    B[jj][i+4] = tmp1;
                    B[jj][i+5] = tmp2;
                    B[jj][i+6] = tmp3;
                    B[jj][i+7] = tmp4;
                    
                    B[jj+4][i+0] = tmp5;
                    B[jj+4][i+1] = tmp6;
                    B[jj+4][i+2] = tmp7;
                    B[jj+4][i+3] = tmp8;
                }
                for (int ii = i + 4; ii < i + 8; ii++) {
                    tmp1 = A[ii][j+4];
                    tmp2 = A[ii][j+5];
                    tmp3 = A[ii][j+6];
                    tmp4 = A[ii][j+7];

                    B[j+4][ii] = tmp1;
                    B[j+5][ii] = tmp2;
                    B[j+6][ii] = tmp3;
                    B[j+7][ii] = tmp4;
                }
            }
        }
    } else {
        for (int i = 0; i < N; i += 16) {
            for (int j = 0; j < M; j += 16) {
                for (int ii = i; ii < N && ii < i + 16; ii++) {
                    for (int jj = j; jj < M && jj < j + 16; jj++) {
                        int tmp = A[ii][jj];
                        B[jj][ii] = tmp;
                    }
                }
            }
        }
    }
}

/* 
 * You can define additional transpose functions below. We've defined
 * a simple one below to help you get started. 
 */ 

/* 
 * trans - A simple baseline transpose function, not optimized for the cache.
 */
char trans_desc[] = "Simple row-wise scan transpose";
void trans(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, tmp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            tmp = A[i][j];
            B[j][i] = tmp;
        }
    }    

}

/*
 * registerFunctions - This function registers your transpose
 *     functions with the driver.  At runtime, the driver will
 *     evaluate each of the registered functions and summarize their
 *     performance. This is a handy way to experiment with different
 *     transpose strategies.
 */
void registerFunctions()
{
    /* Register your solution function */
    registerTransFunction(transpose_submit, transpose_submit_desc); 

    /* Register any additional transpose functions */
    registerTransFunction(trans, trans_desc); 

}

/* 
 * is_transpose - This helper function checks if B is the transpose of
 *     A. You can check the correctness of your transpose by calling
 *     it before returning from the transpose function.
 */
int is_transpose(int M, int N, int A[N][M], int B[M][N])
{
    int i, j;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; ++j) {
            if (A[i][j] != B[j][i]) {
                return 0;
            }
        }
    }
    return 1;
}


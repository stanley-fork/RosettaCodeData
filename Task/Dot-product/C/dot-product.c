/*****************************************************************
 * arbitrary vector length/type dot/scalar product               *
 * as preprocessor macro with OpenMP SIMD and tree vectorize        *
 * CFLAGS="-march=native -O3 -std=<c|gnu>23                      *
 * -mfpmath=<your SIMD implementation>                           *
 * -ftree-vectorize -fopensmp-simd"                              *
 *****************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdalign.h>
#include <sys/param.h>


#define cnt(a) sizeof((a))/sizeof(typeof((a)[0]))
#define dot(a,b,t,n,i) \
({ \
t dst = (t)i; \
_Pragma("omp simd reduction(+:dst)") \
for(size_t j = 0; j < MIN(MIN(cnt(a),cnt(b)),n); j++) \
        dst += (t)((a)[j] * (b)[j]); \
dst; \
})

/* default floating point scalar */
typedef double flt;
/* default dot products for length 3/4
#define dot3(a,b) dot(a,b,flt,3,0)
#define dot4(a,b) dot(a,b,flt,4,0)

int main(int argc, char** argv)
{
        flt a[3] = { 1,  3, -5};
        flt b[3] = { 4, -2, -1};

        /**************************************************
         * cast output to double and use "%+e" allowing   *
         * homogeneous formatted indented output of any   *
         * numerical scalar return type of dot.           *
         **************************************************/
        printf("%+e\n", (double)dot3(a, b));

        return EXIT_SUCCESS;
}

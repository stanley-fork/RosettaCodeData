// $ gcc -O3 -march=native -fopenmp -o parabrutfor parabrutfor.c -lssl -lcrypto
// $ ./parabrutfor

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>
#include <openssl/sha.h>

typedef unsigned char byte;

static void parse_hash(const char* s, byte* out) {
    for (int i = 0; i < 32; i++) {
        unsigned int x;
        sscanf(&s[i * 2], "%2x", &x);
        out[i] = x;
    }
}

int main(void) {
    byte targets[3][32];
    parse_hash("1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad", targets[0]);
    parse_hash("3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b", targets[1]);
    parse_hash("74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f", targets[2]);

    const uint64_t (*tp)[4] = (const uint64_t (*)[4])targets;

    #pragma omp parallel for schedule(dynamic)
    for (int a = 0; a < 26; a++) {
        byte pw[6] = { 'a' + a, 'a', 'a', 'a', 'a', '\0' };
        byte digest[32];
        SHA256_CTX ctx;
        for (pw[1] = 'a'; pw[1] <= 'z'; pw[1]++)
            for (pw[2] = 'a'; pw[2] <= 'z'; pw[2]++)
                for (pw[3] = 'a'; pw[3] <= 'z'; pw[3]++)
                    for (pw[4] = 'a'; pw[4] <= 'z'; pw[4]++) {
                        SHA256_Init(&ctx);
                        SHA256_Update(&ctx, pw, 5);
                        SHA256_Final(digest, &ctx);
                        const uint64_t* dp = (const uint64_t*)digest;
                        for (int t = 0; t < 3; t++)
                            if (dp[0] == tp[t][0] && dp[1] == tp[t][1] &&
                                dp[2] == tp[t][2] && dp[3] == tp[t][3]) {
                                printf("%s => ", pw);
                                for (int i = 0; i < 32; i++) printf("%02x", digest[i]);
                                printf("\n");
                            }
                    }
    }
}

#include <atomic>
#include <cstdint>
#include <cstdio>
#include <future>
#include <iostream>
#include <string>
#include <vector>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#include <openssl/sha.h>
#pragma GCC diagnostic pop

// g++ -O3 -march=native pbf.cpp -o pbf -lssl -lcrypto

struct sha256 {
    unsigned char digest[SHA256_DIGEST_LENGTH];
    bool parse(const std::string& hash) {
        if (hash.length() != 64) return false;
        for (int i = 0; i < SHA256_DIGEST_LENGTH; ++i) {
            unsigned int x;
            if (sscanf(&hash[i * 2], "%2x", &x) != 1) return false;
            digest[i] = x;
        }
        return true;
    }
};

inline bool operator==(const sha256& a, const sha256& b) {
    auto ap = (const uint64_t*)a.digest, bp = (const uint64_t*)b.digest;
    return ap[0] == bp[0] && ap[1] == bp[1] && ap[2] == bp[2] && ap[3] == bp[3];
}

class password_finder {
    int length;
    std::vector<std::string> hashes;
    std::vector<sha256> digests;
    std::atomic<size_t> count;
    void find_passwords(char);
public:
    password_finder(int len) : length(len) {}
    void find_passwords(const std::vector<std::string>&);
};

void password_finder::find_passwords(char ch) {
    char passwd[6] = {ch, 'a', 'a', 'a', 'a', '\0'};
    unsigned char digest_buf[SHA256_DIGEST_LENGTH];
    const uint64_t* targets[3];
    for (size_t i = 0; i < hashes.size(); ++i)
        targets[i] = (const uint64_t*)digests[i].digest;

    SHA256_CTX ctx;
    do {
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        SHA256_Init(&ctx);
        SHA256_Update(&ctx, passwd, 5);
        SHA256_Final(digest_buf, &ctx);
        #pragma GCC diagnostic pop
        auto dp = (const uint64_t*)digest_buf;

        for (size_t m = 0; m < hashes.size(); ++m) {
            auto tp = targets[m];
            if (dp[0] == tp[0] && dp[1] == tp[1] && dp[2] == tp[2] && dp[3] == tp[3]) {
                if (count.fetch_sub(1, std::memory_order_relaxed) > 0)
                    printf("password: %s, hash: %s\n", passwd, hashes[m].c_str());
                if (count == 0) return;
                break;
            }
        }

        for (int i = 4; i >= 1; --i) {
            if (passwd[i] < 'z') { ++passwd[i]; goto next; }
            passwd[i] = 'a';
        }
        return;
        next:;
    } while (count > 0);
}

void password_finder::find_passwords(const std::vector<std::string>& h) {
    hashes = h;
    digests.resize(hashes.size());
    for (size_t i = 0; i < hashes.size(); ++i)
        if (!digests[i].parse(hashes[i])) return;
    count = hashes.size();
    std::vector<std::future<void>> futures;
    for (char c = 'a'; c <= 'z'; ++c)
        futures.push_back(std::async(std::launch::async, [this, c]() { find_passwords(c); }));
}

int main() {
    password_finder(5).find_passwords({
        "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
        "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
        "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"});
}

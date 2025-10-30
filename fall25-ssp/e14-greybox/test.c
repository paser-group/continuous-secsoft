#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>


static const uint64_t K[80] = {
  0x428a2f98d728ae22ULL,0x7137449123ef65cdULL,0xb5c0fbcfec4d3b2fULL,0xe9b5dba58189dbbcULL,
  0x3956c25bf348b538ULL,0x59f111f1b605d019ULL,0x923f82a4af194f9bULL,0xab1c5ed5da6d8118ULL,
  0xd807aa98a3030242ULL,0x12835b0145706fbeULL,0x243185be4ee4b28cULL,0x550c7dc3d5ffb4e2ULL,
  0x72be5d74f27b896fULL,0x80deb1fe3b1696b1ULL,0x9bdc06a725c71235ULL,0xc19bf174cf692694ULL,
  0xe49b69c19ef14ad2ULL,0xefbe4786384f25e3ULL,0x0fc19dc68b8cd5b5ULL,0x240ca1cc77ac9c65ULL,
  0x2de92c6f592b0275ULL,0x4a7484aa6ea6e483ULL,0x5cb0a9dcbd41fbd4ULL,0x76f988da831153b5ULL,
  0x983e5152ee66dfabULL,0xa831c66d2db43210ULL,0xb00327c898fb213fULL,0xbf597fc7beef0ee4ULL,
  0xc6e00bf33da88fc2ULL,0xd5a79147930aa725ULL,0x06ca6351e003826fULL,0x142929670a0e6e70ULL,
  0x27b70a8546d22ffcULL,0x2e1b21385c26c926ULL,0x4d2c6dfc5ac42aedULL,0x53380d139d95b3dfULL,
  0x650a73548baf63deULL,0x766a0abb3c77b2a8ULL,0x81c2c92e47edaee6ULL,0x92722c851482353bULL,
  0xa2bfe8a14cf10364ULL,0xa81a664bbc423001ULL,0xc24b8b70d0f89791ULL,0xc76c51a30654be30ULL,
  0xd192e819d6ef5218ULL,0xd69906245565a910ULL,0xf40e35855771202aULL,0x106aa07032bbd1b8ULL,
  0x19a4c116b8d2d0c8ULL,0x1e376c085141ab53ULL,0x2748774cdf8eeb99ULL,0x34b0bcb5e19b48a8ULL,
  0x391c0cb3c5c95a63ULL,0x4ed8aa4ae3418acbULL,0x5b9cca4f7763e373ULL,0x682e6ff3d6b2b8a3ULL,
  0x748f82ee5defb2fcULL,0x78a5636f43172f60ULL,0x84c87814a1f0ab72ULL,0x8cc702081a6439ecULL,
  0x90befffa23631e28ULL,0xa4506cebde82bde9ULL,0xbef9a3f7b2c67915ULL,0xc67178f2e372532bULL,
  0xca273eceea26619cULL,0xd186b8c721c0c207ULL,0xeada7dd6cde0eb1eULL,0xf57d4f7fee6ed178ULL,
  0x06f067aa72176fbaULL,0x0a637dc5a2c898a6ULL,0x113f9804bef90daeULL,0x1b710b35131c471bULL,
  0x28db77f523047d84ULL,0x32caab7b40c72493ULL,0x3c9ebe0a15c9bebcULL,0x431d67c49c100d4cULL,
  0x4cc5d4becb3e42b6ULL,0x597f299cfc657e2aULL,0x5fcb6fab3ad6faecULL,0x6c44198c4a475817ULL
};


static inline uint64_t rotr(uint64_t x, unsigned n) {
    return (x >> n) | (x << (64 - n));
}


#define CH(x,y,z)  ((x & y) ^ (~x & z))
#define MAJ(x,y,z) ((x & y) ^ (x & z) ^ (y & z))
#define SIG0(x) (rotr(x,28) ^ rotr(x,34) ^ rotr(x,39))
#define SIG1(x) (rotr(x,14) ^ rotr(x,18) ^ rotr(x,41))
#define LSIG0(x) (rotr(x,1) ^ rotr(x,8) ^ (x >> 7))
#define LSIG1(x) (rotr(x,19) ^ rotr(x,61) ^ (x >> 6))

typedef struct {
    uint64_t h[8];
    unsigned char buffer[128]; /* 1024-bit blocks */
    uint64_t bitlen_high; /* high 64 bits of bit length */
    uint64_t bitlen_low;  /* low 64 bits of bit length */
    size_t buffer_len;
} SHA512_CTX;

void sha512_init(SHA512_CTX *ctx) {
    ctx->h[0] = 0x6a09e667f3bcc908ULL;
    ctx->h[1] = 0xbb67ae8584caa73bULL;
    ctx->h[2] = 0x3c6ef372fe94f82bULL;
    ctx->h[3] = 0xa54ff53a5f1d36f1ULL;
    ctx->h[4] = 0x510e527fade682d1ULL;
    ctx->h[5] = 0x9b05688c2b3e6c1fULL;
    ctx->h[6] = 0x1f83d9abfb41bd6bULL;
    ctx->h[7] = 0x5be0cd19137e2179ULL;
    ctx->bitlen_high = 0;
    ctx->bitlen_low = 0;
    ctx->buffer_len = 0;
}


static void sha512_transform(SHA512_CTX *ctx, const unsigned char block[128]) {
    uint64_t W[80];
    uint64_t a,b,c,d,e,f,g,h;
    unsigned int t;


    for (t = 0; t < 16; ++t) {
        W[t] = ((uint64_t)block[t*8    ] << 56) |
               ((uint64_t)block[t*8 + 1] << 48) |
               ((uint64_t)block[t*8 + 2] << 40) |
               ((uint64_t)block[t*8 + 3] << 32) |
               ((uint64_t)block[t*8 + 4] << 24) |
               ((uint64_t)block[t*8 + 5] << 16) |
               ((uint64_t)block[t*8 + 6] <<  8) |
               ((uint64_t)block[t*8 + 7]);
    }
    for (t = 16; t < 80; ++t) {
        W[t] = LSIG1(W[t-2]) + W[t-7] + LSIG0(W[t-15]) + W[t-16];
    }

    /* init working vars */
    a = ctx->h[0]; b = ctx->h[1]; c = ctx->h[2]; d = ctx->h[3];
    e = ctx->h[4]; f = ctx->h[5]; g = ctx->h[6]; h = ctx->h[7];

    /* main loop */
    for (t = 0; t < 80; ++t) {
        uint64_t T1 = h + SIG1(e) + CH(e,f,g) + K[t] + W[t];
        uint64_t T2 = SIG0(a) + MAJ(a,b,c);
        h = g;
        g = f;
        f = e;
        e = d + T1;
        d = c;
        c = b;
        b = a;
        a = T1 + T2;
    }

    /* compute intermediate hash */
    ctx->h[0] += a; ctx->h[1] += b; ctx->h[2] += c; ctx->h[3] += d;
    ctx->h[4] += e; ctx->h[5] += f; ctx->h[6] += g; ctx->h[7] += h;
}

void sha512_update(SHA512_CTX *ctx, const unsigned char *data, size_t len) {
    uint64_t bits = (uint64_t)len * 8ULL;

    uint64_t prev_low = ctx->bitlen_low;
    ctx->bitlen_low += bits;
    if (ctx->bitlen_low < prev_low) ctx->bitlen_high++; /* carry */
    /* Also add any extra carry if bits caused overflow beyond 2^64 (unlikely for single call) */

    while (len > 0) {
        size_t to_copy = 128 - ctx->buffer_len;
        if (to_copy > len) to_copy = len;
        memcpy(ctx->buffer + ctx->buffer_len, data, to_copy);
        ctx->buffer_len += to_copy;
        data += to_copy;
        len -= to_copy;
        if (ctx->buffer_len == 128) {
            sha512_transform(ctx, ctx->buffer);
            ctx->buffer_len = 0;
        }
    }
}

void sha512_final(SHA512_CTX *ctx, unsigned char hash[64]) {
    /* append the '1' bit (0x80) and pad with zeros, reserve 16 bytes for length (128-bit) */
    unsigned char pad[256];
    size_t pad_len;
    /* append 0x80 */
    pad[0] = 0x80;
    /* compute padding length: we need total length mod 128 to be 112 bytes (i.e., room for 16 bytes length) */
    size_t rem = ctx->buffer_len;
    if (rem < 112) pad_len = 112 - rem;
    else pad_len = 128 + 112 - rem;
    /* first byte is 0x80, rest zeros */
    memset(pad + 1, 0, pad_len - 1);

    /* update with padding */
    sha512_update(ctx, pad, pad_len);

    /* append 128-bit big-endian length (bitlen_high:bitlen_low) */
    unsigned char lenbuf[16];
    /* high 64 bits */
    lenbuf[0] = (unsigned char)(ctx->bitlen_high >> 56);
    lenbuf[1] = (unsigned char)(ctx->bitlen_high >> 48);
    lenbuf[2] = (unsigned char)(ctx->bitlen_high >> 40);
    lenbuf[3] = (unsigned char)(ctx->bitlen_high >> 32);
    lenbuf[4] = (unsigned char)(ctx->bitlen_high >> 24);
    lenbuf[5] = (unsigned char)(ctx->bitlen_high >> 16);
    lenbuf[6] = (unsigned char)(ctx->bitlen_high >> 8);
    lenbuf[7] = (unsigned char)(ctx->bitlen_high);
    /* low 64 bits */
    lenbuf[8]  = (unsigned char)(ctx->bitlen_low >> 56);
    lenbuf[9]  = (unsigned char)(ctx->bitlen_low >> 48);
    lenbuf[10] = (unsigned char)(ctx->bitlen_low >> 40);
    lenbuf[11] = (unsigned char)(ctx->bitlen_low >> 32);
    lenbuf[12] = (unsigned char)(ctx->bitlen_low >> 24);
    lenbuf[13] = (unsigned char)(ctx->bitlen_low >> 16);
    lenbuf[14] = (unsigned char)(ctx->bitlen_low >> 8);
    lenbuf[15] = (unsigned char)(ctx->bitlen_low);

    sha512_update(ctx, lenbuf, 16);

    /* after final transform, output hash (big-endian) */
    for (int i = 0; i < 8; ++i) {
        hash[i*8    ] = (unsigned char)(ctx->h[i] >> 56);
        hash[i*8 + 1] = (unsigned char)(ctx->h[i] >> 48);
        hash[i*8 + 2] = (unsigned char)(ctx->h[i] >> 40);
        hash[i*8 + 3] = (unsigned char)(ctx->h[i] >> 32);
        hash[i*8 + 4] = (unsigned char)(ctx->h[i] >> 24);
        hash[i*8 + 5] = (unsigned char)(ctx->h[i] >> 16);
        hash[i*8 + 6] = (unsigned char)(ctx->h[i] >> 8);
        hash[i*8 + 7] = (unsigned char)(ctx->h[i]);
    }
}

/* Convenience: compute SHA-512 of data buffer */
void sha512_digest(const unsigned char *data, size_t len, unsigned char out[64]) {
    SHA512_CTX ctx;
    sha512_init(&ctx);
    sha512_update(&ctx, data, len);
    sha512_final(&ctx, out);
}

/* Print hex */
static void print_hex(const unsigned char *buf, size_t len) {
    for (size_t i = 0; i < len; ++i) printf("%02x", buf[i]);
    printf("\n");
}

/* Example main: read stdin and print sha512 hex */
int main(int argc, char **argv) {
    unsigned char hash[64];
    if (argc == 1) {
        /* read stdin to buffer in chunks */
        SHA512_CTX ctx;
        sha512_init(&ctx);
        unsigned char buf[4096];
        size_t n;
        while ((n = fread(buf, 1, sizeof(buf), stdin)) > 0) {
            sha512_update(&ctx, buf, n);
        }
        sha512_final(&ctx, hash);
        print_hex(hash, 64);
    } else {
        /* hash argv[1] string */
        sha512_digest((unsigned char*)argv[1], strlen(argv[1]), hash);
        print_hex(hash, 64);
    }
    return 0;
}

#include "cachelab.h"
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>

// flags
int v, s, E, b;
char t[1024];

//stats
int hits, misses, evictions;

// for LRU evictions. Every time cache access occurs it increments by 1.
unsigned int lruCounter;

//cacheline contains valid bit, tag and the cacheblock, but we don't need to implement the cache block in the simulator - we only care about hits/ misses/ evictions
// lru is a counter for LRU evictions.
typedef struct {
    int valid;
    int tag;
    int lru;
}cacheline_t;

typedef struct {
    int S; // 2^s
    int E;
    int b;
    cacheline_t** cache;
}cache_t;

cache_t Cache;
 
void printHelp() {
    printf(
        "Usage: ./csim [-hv] -s <s> -E <E> -b <b> -t <tracefile>\n"
        "-h: Optional help flag that prints usage info\n"
        "-v: Optional verbose flag that displays trace info\n"
        "-s <s>: Number of set index bits (S = 2**s is the number of sets)\n"
        "-E <E>: Associativity (number of lines per set)\n"
        "-b <b>: Number of block bits (B = 2**b is the block size)\n"
        "-t <tracefile>: Name of the valgrind trace to replay\n"
    );

}

/*
* @brief
* define the s E b value in the global cache object
* @params[in]
* _* : flags
*/
void initCache(int _s, int _E, int _b) {
    Cache.S = (1 << _s);
    Cache.E = E;
    Cache.b = (1 << _b);
}

/*
* @brief
* allocate memory for cachelines in the global cache object
*/
void mallocCache() {
    Cache.cache = (cacheline_t**)malloc(sizeof(cacheline_t*) * Cache.S);

    for (int i = 0; i < Cache.S; i++) {
        Cache.cache[i] = (cacheline_t*)malloc(sizeof(cacheline_t) * Cache.E);
    }

    for (int i = 0; i < Cache.S; i++) {
        for (int j = 0; j < Cache.E; j++) {
            cacheline_t cacheline = {
                .valid = 0,
                .tag = 0,
                .lru = 0
            };
            
            Cache.cache[i][j] = cacheline;
        }
    }
}

/*
* @brief
* cleanup the global cache object
*/
void freeCache() {
    for (int i = 0; i < Cache.S; i++) {
        free(Cache.cache[i]);
    }

    free(Cache.cache);
}

void hit(int setIndex, int lineIndex, int tag) {
    hits++;
    Cache.cache[setIndex][lineIndex].lru = ++lruCounter;
}

void miss(int setIndex, int lineIndex, int tag) {
    // don't need to increment misses here, just write the tag
    Cache.cache[setIndex][lineIndex].tag = tag;
    Cache.cache[setIndex][lineIndex].valid = 1;
    Cache.cache[setIndex][lineIndex].lru = ++lruCounter;
}

void evict(int setIndex, int tag) {
    evictions++;
    unsigned int min = 1 << 31;
    int idx = 0;
    for (int i = 0; i < Cache.E; i++) {
        if (Cache.cache[setIndex][i].lru < min) {
            idx = i;
            min = Cache.cache[setIndex][i].lru;
        }
    }

    // overwrite the LRU line
    Cache.cache[setIndex][idx].tag = tag;
    Cache.cache[setIndex][idx].valid = 1;
    Cache.cache[setIndex][idx].lru = ++lruCounter;
}

/*
* @brief
* update the valid bit, tag and lru counter when memory access occurs
*/
void updateCache(long int address) {
    // parse the address into valid bit + tag + block offset
    int tag = address >> (b + s);
    int setIndex = (address >> b) & ((1 << s) - 1);

    // iterate through the corr. cacheset to find a hit, otherwise miss.
    for (int i = 0; i < Cache.E; i++) {
        if (Cache.cache[setIndex][i].tag == tag) {
            if (Cache.cache[setIndex][i].valid) {
                hit(setIndex, i, tag);
                return;
            }
        }
    }

    // no hits, then miss. Check whether evicts (all lines are valid) or not
    misses++;
    for (int i = 0; i < Cache.E; i++) {
        if (!Cache.cache[setIndex][i].valid) {
            miss(setIndex, i, tag);
            return;
        }
    }

    // have to evicts
    evict(setIndex, tag);
}

/*
* @brief
* parse the line in trace file and simulate the cache access
* @params[in]
* _* : flags
*/
void accessCache(char operation, long int address) {
    // ignore I
    switch (operation)
    {
    case 'L':
        updateCache(address);
        break;
    case 'M':   // update twice : first read then write
        updateCache(address);
    case 'S':
        updateCache(address);
        break;
    }
}

/*
* @brief
* create the _ struct instance, open the trace files, parse lines, pass operations, addresses and sizes into the accessCache, which is the core of handling cache simulation
* @params[in]
* _* : flags
*/
void simulate(int _s, int _E, int _b, char t[]) {
    // init the cache
    initCache(_s, _E, _b);
    mallocCache();

    //read the trace
    FILE *pFile;
    pFile = fopen(t, "r");

    if (pFile == NULL) {
        printf("Error opening file.\n");
        exit(1);
    }

    char operation;
    long int address;
    int size;

    while(fscanf(pFile, " %c %lx,%d", &operation, &address, &size)>0) {
        accessCache(operation, address);
    }

    if (ferror(pFile)) { 
        printf("Error writing in file.\n"); 
        exit(1); 
    }
  
    fclose(pFile);

    freeCache();
}

int main(int argc, char** argv)
{
	int opt;
    while (-1 != (opt = getopt(argc, argv, "h::v::s:E:b:t:"))) {
        switch(opt) {
            case 'h':
                printHelp();
                break;
            case 'v':
                v = 1;
                break;
            case 's':
                s = atoi(optarg);
                break;
            case 'E':
                E = atoi(optarg);
                break;
            case 'b':
                b = atoi(optarg);
                break;
            case 't':
                strcpy(t, optarg);
                break;
            default:
                printf("Incorrect arguments.\n");
                break;
        }
    }
    simulate(s, E, b, t);
    printSummary(hits, misses, evictions);
    return 0;
}

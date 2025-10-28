#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
    int count = 100000;  
    srand((unsigned int) time(NULL));
    printf("Generating %d random numbers:\n", count);
    for (int i = 0; i < count; i++) {
        int r = rand();  
        printf("%d\n", r);
    }
    return 0;
}

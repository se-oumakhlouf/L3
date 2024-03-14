#include <stdio.h>
#include <stdlib.h>
#include "../../try.h"

int main(void) {
    int a, b, res;
    int size = 20;
    char input [size];
    do {
        fgets(input, size, stdin);
        res = sscanf(input, "%d %d", &a, &b);
        if (res != EOF && res == 2 )   res = 1;
        else                           res = 0; 
        if (res) printf("%d - %d = %d\n", a, b, a - b);
        else     printf("Usage :\n (int) (int)\n");
    } while(res);
    
    exit(EXIT_SUCCESS);
}
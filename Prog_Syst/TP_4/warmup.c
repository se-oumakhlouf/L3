#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>


int main (void) {
    printf("Bonjour\n");
    fork();
    printf("Au revoir\n");
    exit(EXIT_SUCCESS);
}

/*

    Bonjour
    Au revoir
    Au revoir

*/
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include "../../try.h"

int main (void) {    
    char buff[BUFSIZ];
    printf("Mon PID est %ld", (long) getpid());
    sprintf(buff, "My PID is %ld", (long) getpid());
    write(STDOUT_FILENO, buff, 1024);
    switch (try(fork()))
    {
    case 0: // Child
        printf("je suis l'enfant et mon PID est %ld", (long) getpid());
        sprintf(buff, "I am the child and my PID is %ld", (long) getpid());
        write(STDOUT_FILENO, buff, 1024);
        break;
    
    default: // Parent
        printf("je suis le parent et mon PID est %ld", (long) getpid());
        sprintf(buff, "I am the parent and my PID is %ld", (long) getpid());
        write(STDOUT_FILENO, buff, 1024);
        break;
    }
    puts("");
    exit(EXIT_SUCCESS);
}

// Je ne comprends pas vraiment pourquoi on obtient un tel affichage

// printf est bloquant (le programme attend que la sortie soit effectué avant de continuer l'éxécution)
// write n'est pas bloquant
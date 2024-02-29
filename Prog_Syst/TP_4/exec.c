#include <unistd.h>
#include <stdlib.h>
#include "../../try.h"
#include <sys/types.h>
#include <sys/wait.h>


void run_free() {
   printf("\n--> Running free\n");
    int wstatus;
    switch (try(fork()))
    {
    case 0: /* Child */
        try(execl("/bin/free", "", (char *) NULL));
        break;
    
    default: /* Parent */
        try(wait(&wstatus));
        if (WIFEXITED(wstatus))
            printf("--> Returned %d\n", WEXITSTATUS(wstatus));
        break;
    }
    exit(EXIT_SUCCESS);
}


void run_ps() {
   printf("\n--> Running ps\n");
    int wstatus;
    switch (try(fork()))
    {
    case 0: /* Child */
        try(execl("/bin/ps", "", (char *) NULL));
        break;
    
    default: /* Parent */
        try(wait(&wstatus));
        if (WIFEXITED(wstatus))
            printf("--> Returned %d\n", WEXITSTATUS(wstatus));
        break;
    }
    run_free();
    exit(EXIT_SUCCESS);
}

int main (void) {
    printf("\n--> Running ls\n");
    int wstatus;
    switch (try(fork()))
    {
    case 0: /* Child */
        try(execl("/bin/ls", "", (char *) NULL));
        break;
    
    default: /* Parent */
        try(wait(&wstatus));
        if (WIFEXITED(wstatus))
            printf("--> Returned %d\n", WEXITSTATUS(wstatus));
        break;
    }
    run_ps();
    exit(EXIT_SUCCESS);
}

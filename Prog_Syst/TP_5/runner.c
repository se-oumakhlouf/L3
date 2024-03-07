#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include "../../try.h"

/*  
    ./runner traceroute google.com      ->      OK
    ./runner traceroute tartiflette     ->      ERROR
*/

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage : %s COMMAND\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    int wstatus, fd;
    printf("--> Running `%s`\n", argv[1]);
    switch (try(fork()))
    {
    case 0: /* Child */
        fd = try(open("/dev/null", O_WRONLY));
        try(dup2(fd, STDOUT_FILENO));
        try(dup2(fd, STDERR_FILENO));
        try(close(fd));
        try(execvp(argv[1], argv + 1));
        break;
    
    default: /* Parent */
        try(wait(&wstatus));
        if (wstatus == 0)   {printf("\tOK\n");}
        else                {printf("\tERROR\n");}
        if (WIFEXITED(wstatus))
            printf("--> Returned %d\n", WEXITSTATUS(wstatus));
        break;
    }
    exit(EXIT_SUCCESS);
}
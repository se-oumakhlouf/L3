#include "../../try.h"
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <signal.h>

volatile sig_atomic_t flag = 0;

void handler(int sig) {flag = 1;}

int main(int argc, char **argv) {
    try(signal(SIGALRM, handler), SIG_ERR);
    sigset_t s; sigemptyset(&s);
    sigaddset(&s, SIGALRM);
    alarm(1);

    int n;
    size_t nb_bytes = 1024;
    char buff[nb_bytes];
    while ((n = try(read(STDIN_FILENO, buff, nb_bytes), -1)) > 0) {
        if (flag) {
            printf("%d B/s\n", n);
        }
    }
    

    exit(EXIT_SUCCESS);
}
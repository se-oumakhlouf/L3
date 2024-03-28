#include "../../try.h"
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <signal.h>

volatile sig_atomic_t flag = 0;

void handler(int sig) {
    flag = 1;
}

void show_size(struct winsize ws) {
    try(ioctl(STDIN_FILENO, TIOCGWINSZ, &ws));
    printf("Window size: %d x %d\n", ws.ws_col, ws.ws_row);
}

int main(void) {
    struct winsize ws;
    show_size(ws);
    try(signal(SIGWINCH, handler), SIG_ERR);
    while (1) {   
        if (flag) {
            show_size(ws); 
            flag = 0;
        }
    }
    exit(EXIT_SUCCESS);
}
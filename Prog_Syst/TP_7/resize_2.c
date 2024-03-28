#include "../../try.h"
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <signal.h>

volatile sig_atomic_t flag = 0;

void handler(int sig) {flag = 1;}

void header(int cols) {
    printf("%s", "┌");
    for (int i = 0; i < cols; i++, printf("%c",'-'));
    printf("%s", "┐\n");
}

void end(int cols) {
    printf("%s", "└");
    for (int i = 0; i < cols; i++, printf("%c",'-'));
    printf("%s", "┘\n");
}

void empty_line(int cols, int lines) {
    for (int j = 0; j < lines; j++) {
        printf("%s", "|");
        for (int i = 0; i < cols; i++, printf(" "));
        printf("%s", "|");
    }
}

void show_size(struct winsize ws) {
    try(ioctl(STDIN_FILENO, TIOCGWINSZ, &ws));
    int cols = ws.ws_col - 2, lines = ws.ws_row - 3;
    header(cols);
    empty_line(cols, lines);
    end(cols);
}

int main(void) {
    struct winsize ws;
    struct sigaction act;

    show_size(ws);

    act.sa_handler = handler;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;

    try(sigaction(SIGWINCH, &act, NULL));

    while (1) {   
        if (flag) {
            show_size(ws); 
            flag = 0;
        }
    }
    exit(EXIT_SUCCESS);
}
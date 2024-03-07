#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include "../../try.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage : %s file\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    int fd = try(open(argv[1], O_CREAT | O_TRUNC | O_WRONLY));
    try(dup2(fd, STDOUT_FILENO), -1);
    try(close(fd), -1);
    try(execlp("ls", "ls", "-l", (char *) NULL));
    exit(EXIT_SUCCESS);
}
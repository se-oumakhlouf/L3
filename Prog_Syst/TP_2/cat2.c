#include "../../try.h"
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
    int fd;
    if (argc >= 2) {
        printf("Test: %s\n", argv[1]);
        fd = try(open(argv[1], O_RDONLY));                  // open file in read-only mode
        close(fd);                                          // close stdin
    } else {
        int n;
        size_t nb_bytes = 1024;
        char buff[nb_bytes];
        n = try(read(STDIN_FILENO, buff, nb_bytes), -1);    // read from stdin | STFIN_FILENO = 0
        try(write(STDOUT_FILENO, buff, n), -1);             // write to stdout | STDOUT_FILENO = 1
    }
    return 0;
}
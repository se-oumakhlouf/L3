/* cat2.c */

#include "../../try.h"
#include <unistd.h>
#include <fcntl.h>

void process_file(char* file_name) {
    int fd, n;
    ssize_t nb_bytes = 2048;
    char buff[nb_bytes];

    if (file_name) {fd = try(open(file_name, O_RDONLY), -1);}       // open file in read-only mode
    else {fd = STDIN_FILENO;}                                       // if no file_name, use stdin as input

    // read until EOF, EOF can be simulated with Ctrl+D
    while ((n = try(read(fd, buff, nb_bytes), -1)) > 0) {           // read from stdin | STFIN_FILENO = 0
        try(write(STDOUT_FILENO, buff, n), -1);                     // write to stdout | STDOUT_FILENO = 1
    }

    if (file_name) {close(fd);}                                     // close file
}

int main(int argc, char *argv[]) {
    if (argc >= 2) {for (int i = 1; i < argc; i++)  process_file(argv[i]);} 
    else {process_file(NULL);}
    return 0;
}

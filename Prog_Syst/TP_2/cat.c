/* cat.c */

#include "../../try.h"
#include <unistd.h>

int main() {
    int n;
    size_t nb_bytes = 1024;
    char buff[nb_bytes];
    while ((n = try(read(STDIN_FILENO, buff, nb_bytes), -1)) > 0) {           // read from stdin | STDIN_FILENO = 0
        try(write(STDOUT_FILENO, buff, n), -1);                               // write to stdout | STDOUT_FILENO = 1
    }
    return 0;
}

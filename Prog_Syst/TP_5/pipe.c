#include "../../try.h"
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    int pipe_fd[2];
    try(pipe(pipe_fd), -1);

    switch (try(fork(), -1)) {
        case 0: /* Child */
            try(close(pipe_fd[0]), -1);
            char c;
            while (try(read(STDIN_FILENO, &c, 1), -1) > 0) {
                if (islower(c))
                    c = toupper(c);
                try(write(pipe_fd[1], &c, 1), -1);
            }
            try(close(pipe_fd[1]), -1); 
            return EXIT_SUCCESS;

        default: /* Parent */
            close(pipe_fd[1]); 
            char buffer[1024];
            ssize_t bytes_read;
            while ((bytes_read = try(read(pipe_fd[0], buffer, sizeof(buffer)), -1)) > 0) {
                try(write(STDOUT_FILENO, buffer, bytes_read), -1);
            }
            try(close(pipe_fd[0]), -1);
            return EXIT_SUCCESS;
    }
}

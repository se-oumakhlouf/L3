/* from correction */
#include <ctype.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "../try.h"

void handleSIGCHLD(int sig) {
  _exit(EXIT_SUCCESS);
}

int main(void) {
  char c;
  int p[2];
  try(signal(SIGCHLD, handleSIGCHLD), SIG_ERR);
  try(pipe(p));
  switch (try(fork())) {
  case 0:  // Child (reader)
    try(close(p[1]));
    for (int i = 0; i < 10 && try(read(p[0], &c, 1)) == 1; i++) {
      try(write(STDOUT_FILENO, &c, 1));
    }
    break;
  default: // Parent (writer)
    try(close(p[0]));
    while (try(read(STDIN_FILENO, &c, 1)) == 1) {
      c = toupper(c);
      try(write(p[1], &c, 1));
    }
    break;
  }
}

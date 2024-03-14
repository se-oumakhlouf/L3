/* from correction */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "../../try.h"

int main(void) {
  char c;
  int p[2];
  try(pipe(p));
  switch (try(fork())) {
  case 0:  // Child (writer)
    try(close(p[0]));
    while (try(read(STDIN_FILENO, &c, 1)) == 1) {
      c = toupper(c);
      try(write(p[1], &c, 1));
    }
    break;
  default: // Parent (reader)
    try(close(p[1]));
    while (try(read(p[0], &c, 1)) == 1) {
      try(write(STDOUT_FILENO, &c, 1));
    }
    break;
  }
}

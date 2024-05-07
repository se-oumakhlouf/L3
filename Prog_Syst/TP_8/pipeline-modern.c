#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include "../try.h"

// Pipeline architecture used by most modern shells.
// A pipeline of the form CMD1 | CMD2 | ... | CMD_n
// is represented by the following process hierarchy:
//
//  Waiter (normally the shell itself)
//  ├── Command 1
//  ├── Command 2
//  │   ...
//  └── Command n
//
// The process at the root of this tree simply waits for
// the last command to terminate, and then returns its
// exit status. Normally, this process would be the shell
// itself, but here it is the initial process of our program.

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "Usage: %s CMD1 [CMD2 [CMD3 ...]]\n", argv[0]);
    exit(EXIT_FAILURE);
  }
  pid_t lastPID;
  int prevPipe0;   // Read end of the previous pipe
  int nextPipe[2]; // Read and write ends of the next pipe
  for (int i = 1; i < argc; i++) {
    bool isFirstCmd = (i == 1);
    bool isLastCmd  = (i == argc - 1);
    if (!isLastCmd) {
      try(pipe(nextPipe));
    }
    switch (lastPID = try(fork())) {
    case 0:  // Child (executes i-th command)
      if (!isFirstCmd) {
        try(dup2(prevPipe0, STDIN_FILENO));
        try(close(prevPipe0));
      }
      if (!isLastCmd) {
        try(dup2(nextPipe[1], STDOUT_FILENO));
        try(close(nextPipe[0]));
        try(close(nextPipe[1]));
      }
      try(execlp(argv[i], argv[i], (char *) NULL));
      break;
    default: // Parent (continues loop)
      if (!isFirstCmd) {
        try(close(prevPipe0));
      }
      if (!isLastCmd) {
        try(close(nextPipe[1]));
        prevPipe0 = nextPipe[0];
      }
      break;
    }
  }
  // Parent (waits for last command)
  int wstatus;
  try(waitpid(lastPID, &wstatus, 0));
  return WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : EXIT_FAILURE;
}

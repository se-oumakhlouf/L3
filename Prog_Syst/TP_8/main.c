#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include "joblist.h"
#include "try.h"

#define PROMPT "$ "

static char *readCmdLine(void) {
  fprintf(stderr, "%s", PROMPT);
  char *result = NULL;
  size_t len = 0;
  if (getline(&result, &len, stdin) == -1) {
    fprintf(stderr, "\n");
    free(result);
    result = NULL;
  }
  else {
    len = strlen(result);
    if (len > 0 && result[len - 1] == '\n') {
      result[len - 1] = '\0';
    }
  }
  return result;
}

int builtinCD (int argc, char ** argv) {
  if (argc == 1) {
    chdir(getenv("HOME"));
    return 1;
  } else {
    chdir(argv[1]);
    return 1;
  }
  return 0;
}

int isCD(Job * job) {
  if (!strcmp(job->pipeline->head->args->array[0], "cd")){
    return 1;
  }
  return 0; 
}

int builtinEXIT(int argc, char ** argv) {
  if (argc > 1) exit(atoi(argv[1]));
  else // do something
    exit(EXIT_FAILURE);
}

int isEXIT(Job * job) {
  if (!strcmp(job->pipeline->head->args->array[0], "exit")){
    return 1;
  }
  return 0; 
}

int main(void) {
  int wstatus;
  while (true) {
    char *line = readCmdLine();
    if (!line) {
      break;
    }
    Job *job = newJobFromCmdLine(line);
    if (job) {
      // printJob(job);
      
      if (!strcmp(job->pipeline->head->args->array[0], "cd"))
        builtinCD(job->pipeline->head->args->size, job->pipeline->head->args->array);
      
      else if (!strcmp(job->pipeline->head->args->array[0], "exit"))
        builtinEXIT(job->pipeline->head->args->size, job->pipeline->head->args->array);
      
      else {
        switch (try(fork(), -1))
        {
        case 0: // child
          try(execvp(job->pipeline->head->args->array[0], job->pipeline->head->args->array));
          break;
        
        default:
          if (!job->bg) try(wait(&wstatus)); // &
          break;
        }
      }
      
      delJob(job);
    }
  }
  exit(EXIT_SUCCESS);
}

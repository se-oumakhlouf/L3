#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <fcntl.h>
#include "joblist.h"
#include "try.h"

#define PROMPT "$ "

int return_code = 0;

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
	if (argc == 1) 	return try(chdir(getenv("HOME")));
	else 			return try(chdir(argv[1]));
}

void builtinEXIT(int argc, char ** argv) {
	if (argc > 1) exit(atoi(argv[1]));
	else          exit(return_code);
}

int main(void) {
	int wstatus, fd;
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
				switch (try(fork(), -1)) {

					case 0: /* child */

						if (job->pipeline->head->redout) { /* > */
							if (job->pipeline->head->append) fd = try(open(job->pipeline->head->redout, O_WRONLY | O_CREAT | O_APPEND, 0666));
							else fd = try(open(job->pipeline->head->redout, O_WRONLY | O_CREAT | O_TRUNC, 0666));
							try(dup2(fd, STDOUT_FILENO));
							try(dup2(fd, STDERR_FILENO));
							try(close(fd));
						}

						if (job->pipeline->head->redin) { /* < */
							fd = try(open(job->pipeline->head->redin, O_RDONLY));
							try(dup2(fd, STDIN_FILENO));
							try(dup2(fd, STDERR_FILENO));
							try(close(fd));
						}
						
						try(execvp(job->pipeline->head->args->array[0], job->pipeline->head->args->array));
						break;
					
					default: /* parent */

						if (!job->bg) try(wait(&wstatus)); // &
						if (WIFEXITED(wstatus)) return_code = WEXITSTATUS(wstatus);
						else if(WIFSIGNALED(wstatus)) return_code = 128 + WTERMSIG(wstatus);
						break;
				}
			}
			
			delJob(job);
		}
	}
	exit(EXIT_SUCCESS);
}

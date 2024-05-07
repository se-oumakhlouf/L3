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
	int wstatus, fd, prev_p, next_p[2];
	pid_t lastPID;
	bool isFirstCmd = 0;
	bool isLastCmd = 0;
	try(pipe(next_p));

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

				for (Proc *proc = job->pipeline->head; proc != NULL; proc = proc->next) {

					isFirstCmd = job->pipeline->head == proc ? 1 : 0;
					isLastCmd = job->pipeline->tail == proc ? 1 : 0;
					if (!isLastCmd) try(pipe(next_p));
					
					switch (lastPID = try(fork())) {

						case 0: /* child */

							if (!isFirstCmd) {
								try(dup2(prev_p, STDIN_FILENO));
								try(close(prev_p));
							}

							if (!isLastCmd) {
								try(dup2(next_p[1], STDOUT_FILENO));
								try(close(next_p[0]));
								try(close(next_p[1]));
							}

							// Gestion des redirections d'entrée et de sortie pour chaque processus
							if (job->pipeline->head->redout) {
								if (job->pipeline->head->append) fd = try(open(job->pipeline->head->redout, O_WRONLY | O_CREAT | O_APPEND, 0666));
								else fd = try(open(job->pipeline->head->redout, O_WRONLY | O_CREAT | O_TRUNC, 0666));
								try(dup2(fd, STDOUT_FILENO));
								try(dup2(fd, STDERR_FILENO));
								try(close(fd));
							}

							if (job->pipeline->head->redin) {
								fd = try(open(job->pipeline->head->redin, O_RDONLY));
								try(dup2(fd, STDIN_FILENO));
								try(dup2(fd, STDERR_FILENO));
								try(close(fd));
							}

							try(execvp(job->pipeline->head->args->array[0], job->pipeline->head->args->array));
							break;
						
						default: /* parent (continues loop)*/
							if (!isFirstCmd) try(close(prev_p));
							if (!isLastCmd) {try(close(next_p[1])); prev_p = next_p[0];}
							break;
					}
				}
				/* parent (waits for last command) */
				if (!job->bg) try(waitpid(lastPID, &wstatus, 0)); // &
				if (WIFEXITED(wstatus)) return_code = WEXITSTATUS(wstatus);
				else if (WIFSIGNALED(wstatus)) return_code = 128 + WTERMSIG(wstatus);
			}
			delJob(job);
		}
	}
	exit(EXIT_SUCCESS);
}

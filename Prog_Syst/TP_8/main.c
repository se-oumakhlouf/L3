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
	int wstatus, fd, p[2], process_count, ended;
	try(pipe(p));
	while (true) {
		char *line = readCmdLine();
		if (!line) {
		break;
		}
		Job *job = newJobFromCmdLine(line);
		if (job) {
			// printJob(job);
			process_count = 0; ended = 0;
			
			if (!strcmp(job->pipeline->head->args->array[0], "cd"))
				builtinCD(job->pipeline->head->args->size, job->pipeline->head->args->array);
			
			else if (!strcmp(job->pipeline->head->args->array[0], "exit"))
				builtinEXIT(job->pipeline->head->args->size, job->pipeline->head->args->array);
			
			else {

				for (Proc *proc = job->pipeline->head; proc != NULL; proc = proc->next) {
					process_count++;
				}
				printf("process_count : %d\n", process_count);
				int pipes[process_count - 1][2];
				for (int i = 0; i < process_count - 1; i++) {
                    try(pipe(pipes[i]));
                }

				for (int i = 0; i < process_count; i++) {
					switch (try(fork(), -1)) {

						case 0: /* child */

							// Gestion des redirections d'entrée et de sortie pour chaque processus
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

							// Gestion des tubes pour rediriger l'entrée et la sortie
							if (i < process_count - 1) { /* sortie standard vers le tube */
								try(close(pipes[i][0]));
								try(dup2(pipes[i][1], STDOUT_FILENO));
								try(close(pipes[i][1]));
							}

							if (i > 0) { /* entrée standard depuis le tube */
								try(close(pipes[i - 1][1]));
								try(dup2(pipes[i - 1][0], STDIN_FILENO));
								try(close(pipes[i - 1][0]));
							}

							try(execvp(job->pipeline->head->args->array[0], job->pipeline->head->args->array));
							break;
						
						default: /* parent */
							printf("parent, process_count : %d\n", process_count);
							if (!job->bg) try(wait(&wstatus)); // &
							if (WIFEXITED(wstatus)) return_code = WEXITSTATUS(wstatus);
							else if (WIFSIGNALED(wstatus)) return_code = 128 + WTERMSIG(wstatus);
							break;
					}
				}
			}
			delJob(job);
		}
	}
	exit(EXIT_SUCCESS);
}

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include "../../try.h"

#define SIZE 50

int main(void) {
    int pipes[4][2];
    pid_t pids[4];
    
    for (int i = 0; i < 4; i++) {
        try(pipe(pipes[i]));
        pids[i] = try(fork());
        switch (pids[i])
        {
        case 0: /* Child */
            try(close(pipes[i][1]));
            try(dup2(pipes[i][0], STDIN_FILENO));

            switch (i)
            {
            case 0: /* add */
                execl("./add", "add", (char *) NULL);
                break;
            case 1: /* sub */
                execl("./sub", "sub", (char *) NULL);
                break;
            case 2: /* mult */
                execl("./mult", "mult", (char *) NULL);
                break;
            case 3: /* div */
                execl("./div", "div", (char *) NULL);
                break;
            default:
                perror("Opeation");
                exit(EXIT_FAILURE);
            }
            break;
        
        default: /* Parent */
            break;
        }
    }
    char command[SIZE];
    char exec[SIZE];
    int a, b, res, index;
    while(fgets(command, sizeof(command), stdin) != NULL) {
        res = sscanf(command, "%s %d %d", exec, &a, &b);
        if (res != 3 || res == EOF) printf("Usage :\n (command) (int) (int)\n");
        
        if (strcmp(exec, "add") == 0)       index = 0;
        else if (strcmp(exec, "sub") == 0)  index = 1;
        else if (strcmp(exec, "mult") == 0) index = 2;
        else if (strcmp(exec, "div") == 0)  index = 3;
        else                        perror("Operation");

        dprintf(pipes[index][1], "%d %d\n", a, b);

        scanf("%d", &res);
        printf("Resultat : %d\n", res);
    }

    for (int i = 0; i < 4; i++) {
        try(close(pipes[i][0]));
    }
        
    exit(EXIT_SUCCESS);

}
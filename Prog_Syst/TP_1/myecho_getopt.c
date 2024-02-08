#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char * argv[]) {
    extern char *optarg;
    extern int optind;
    struct 
    {
        char *sep;
        char *end;
    } cfg = {" ", "\n"};
    int opt;

    while((opt = getopt(argc, argv, "snS:")) != -1) {
        switch (opt)
        {
        case 's':
            cfg.sep = "";
            break;
        case 'n':
            cfg.end = "";
            break;
        case 'S':
            cfg.sep = optarg;
            break;
        default:
            fprintf(stderr, "Usage: %s [-S STRING] [-n] [-s]\n", argv[0]);
            exit(EXIT_FAILURE);
            break;
        }
    }

    char *sep = "";
    for (char **argp = argv + optind; *argp; argp++) {
        printf("%s%s", sep, *argp);
        sep = cfg.sep;
    }
    printf("%s", cfg.end);

    return 0;
}
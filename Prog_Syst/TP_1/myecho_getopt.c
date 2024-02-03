#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char * argv[]) {
    extern char *optarg;
    extern int optind;
    int opt;
    char separator[10] = " ";
    char fin[10] = "\n";

    while((opt = getopt(argc, argv, "snS:")) != -1) {
        switch (opt)
        {
        case 's':
            strcpy(separator, "");
            break;
        case 'n':
            strcpy(fin, "");
            break;
        case 'S':
            strcpy(separator, optarg);
            break;
        default:
            fprintf(stderr, "Invalid option : %s\nUsage: %s letters [-S separator] [-n] [-s] letters\n", argv[optind - 1], argv[0]);
            exit(EXIT_FAILURE);
            break;
        }
    }


    for (int i = optind; i < argc - 1; i ++) {
        printf("%s%s", argv[i], separator);
    }
    printf("%s%s", argv[argc - 1], fin);
    

    return 0;
}
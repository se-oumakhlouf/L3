/* stat.c */

#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include "../../try.h"

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s [pathname]\n", argv[0]);
        exit(EXIT_FAILURE);
    } else {
        struct stat buf;
        for (int i = 1; i < argc; i++) {
            try(stat(argv[i], &buf), -1);
            printf("Inode number: %ld\n", buf.st_ino);
            printf("File size: %ld\n", buf.st_size);
            printf("Last Modification: %ld\n", buf.st_mtime);
            printf("File type: ");
            if (S_ISREG(buf.st_mode))           printf("f\n");
            else if (S_ISDIR(buf.st_mode))      printf("d\n");
            else                                printf("?\n");
            if (i < argc - 1) printf("\n");
        }
    }
}

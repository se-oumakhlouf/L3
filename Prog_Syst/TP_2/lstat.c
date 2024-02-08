/* lstat.c */

#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include "../../try.h"


void process_path(char* pathname) {
    struct stat buf;
    int size;
    char* restrict readbuf;
    try(lstat(pathname, &buf), -1);
    printf("Inode number: %ld\n", buf.st_ino);
    printf("File size: %ld\n", buf.st_size);
    printf("Last Modification: %ld\n", buf.st_mtime);
    printf("File type: ");
    if (S_ISREG(buf.st_mode))           printf("f\n");
    else if (S_ISDIR(buf.st_mode))      printf("d\n");
    else if (S_ISLNK(buf.st_mode)) {
        printf("l\n");
        try(readbuf = malloc(buf.st_size + 2), NULL);
        size = try(readlink(pathname, readbuf, buf.st_size + 2), -1);
        readbuf[size] = '\0';
        printf("Linked to : %s\n", readbuf);
        process_path(readbuf);
        free(readbuf);
    }
    else                                printf("?\n");
    
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s [pathname]\n", argv[0]);
        exit(EXIT_FAILURE);
    } else {
        for (int i = 1; i < argc; i++) {
            process_path(argv[i]);
            if (i < argc - 1) printf("\n");
        }
    }
}

#include "../../try.h"
#include <unistd.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>

void process_dir(char* pathname, int recursive);

void process_path(char* pathname, int recursive) {
    struct stat buf;
    int size;
    char* restrict readbuf = NULL;
    printf("Path : %s\n", pathname);
    try(lstat(pathname, &buf), -1);
    printf("Inode number: %ld\n", buf.st_ino);
    printf("File size: %ld\n", buf.st_size);
    printf("Last Modification: %ld\n", buf.st_mtime);
    printf("File type: ");
    if (S_ISREG(buf.st_mode))           printf("f\n");
    else if (S_ISDIR(buf.st_mode)) {
        printf("d\n");
        if (recursive) process_dir(pathname, recursive);
    }
    else if (S_ISLNK(buf.st_mode)) {
        printf("l\n");
        try(readbuf = malloc(buf.st_size + 2), NULL);
        size = try(readlink(pathname, readbuf, buf.st_size + 2), -1);
        readbuf[size] = '\0';
        printf("Linked to : %s\n", readbuf);
        process_path(readbuf, recursive);
    }
    else                                printf("?\n");
    free(readbuf);
}

void process_dir(char* pathname, int recursive) {
    DIR* dirp = try(opendir(pathname), NULL);
    struct dirent* dirent;
    while ((dirent = readdir(dirp))) {
        if (strcmp(dirent->d_name, ".") == 0 || strcmp(dirent->d_name, "..") == 0) continue;
        printf("\n || Name : %s ||\n", dirent->d_name);
        // build the full path
        char file_path[8192];
        snprintf(file_path, sizeof(file_path), "%s/%s", pathname, dirent->d_name);
        process_path(file_path, recursive);
    }
    try(closedir(dirp), -1);
}

int is_directory(const char* pathname) {
    struct stat buf;
    try(lstat(pathname, &buf), -1);
    return S_ISDIR(buf.st_mode);
}

int is_file(const char* pathname) {
    struct stat buf;
    try(lstat(pathname, &buf), -1);
    return S_ISREG(buf.st_mode);
}

int main(int argc, char* argv[]) {

    extern char *optarg;
    extern int optind;
    int opt;
    int recusive = 0; // 0: false, 1: true

    while((opt = getopt(argc, argv, "R")) != -1) {
        switch (opt)
        {
        case 'R':
            recusive = 1;
            break;
        default:
            fprintf(stderr, "Usage: %s [-R] [FILE]...\n", argv[0]);
            exit(EXIT_FAILURE);
            break;
        }
    }

    if (argc == 1 || (argc == 2 && recusive)) {
        process_dir(".", recusive);
    } else {
        for (char** argp = argv + optind; *argp; argp++) {
            if (is_file(*argp))           process_path(*argp, recusive);
            else if (is_directory(*argp)) process_dir(*argp, recusive);
        }
    }
    exit(EXIT_SUCCESS);
}
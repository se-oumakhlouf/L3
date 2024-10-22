#include "../../try.h"
#include <unistd.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>

void process_path(char* pathname) {
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
    else if (S_ISDIR(buf.st_mode))      printf("d\n");
    else if (S_ISLNK(buf.st_mode)) {
        printf("l\n");
        try(readbuf = malloc(buf.st_size + 2), NULL);
        size = try(readlink(pathname, readbuf, buf.st_size + 2), -1);
        readbuf[size] = '\0';
        printf("Linked to : %s\n", readbuf);
        process_path(readbuf);
    }
    else                                printf("?\n");
    free(readbuf);
}

void process_dir(char* pathname) {
    DIR* dirp = try(opendir(pathname), NULL);
    struct dirent* dirent = try(readdir(dirp), NULL);
    printf("Name : %s\n", dirent->d_name);
    while ((dirent = readdir(dirp))) {
        printf("\n || Name : %s ||\n", dirent->d_name);
        // build the full path
        char file_path[8192];
        snprintf(file_path, sizeof(file_path), "%s/%s", pathname, dirent->d_name);
        process_path(file_path);
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
 
    if (argc == 1) {
        process_dir(".");
    } else {
        for (int i = 1; i < argc; i++) {
            if (is_file(argv[i]))           process_path(argv[i]);
            else if (is_directory(argv[i])) process_dir(argv[i]);
            if (i < argc - 1) printf("\n");
        }
    }
}
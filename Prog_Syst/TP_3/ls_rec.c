#include "../../try.h"
#include <unistd.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <pwd.h>
#include <grp.h>

struct Config
{
    int recursive;  // 0: false, 1: true
    int full;       // 0: false, 1: true (show all the information as in TP_2)    
    char *sep;
    int minusL;
    int minusN;
};

void process_dir(char* pathname, struct Config cfg);

void write_user(struct stat buf, struct Config cfg) {

    if (cfg.minusN) printf("%6u %6u", buf.st_uid, buf.st_gid);
    else {
        struct passwd *owner_info = getpwuid(buf.st_uid);
        const char *owner_name = owner_info ? owner_info->pw_name : "unknown";
        struct group *group_info = getgrgid(buf.st_gid);
        const char *group_name = group_info ? group_info->gr_name : "unknown";
        printf("%s %s", owner_name, group_name);
    }
}

void write_information(struct stat buf, struct Config cfg, char* pathname) {

    if (cfg.minusN || cfg.minusL) {
        printf("%6o ", buf.st_mode);
        struct tm *time = localtime(&buf.st_mtime);
        write_user(buf, cfg);
        printf("%6lu", buf.st_size);
        char month[4]; // Pour stocker le nom abrégé du mois (3 caractères + caractère nul)
        strftime(month, sizeof(month), "%b", time);
        printf("%2d %3s %2d:%2d ", time->tm_mday, month, time->tm_hour, time->tm_min);
        printf("%s\n", pathname);
    }

    else {printf("Path : %s \n", pathname); }

    if (cfg.full) {
        printf("Inode number: %ld\n", buf.st_ino);
        printf("File size: %ld\n", buf.st_size);
        printf("Last Modification: %ld\n", buf.st_mtime);
        printf("File type: ");
        if (S_ISREG(buf.st_mode))           printf("f\n\n");
        else if (S_ISDIR(buf.st_mode))      printf("d\n\n");
        else if (S_ISLNK(buf.st_mode))      printf("l\n\n");
        else                                printf("?\n\n");
    }
}

void process_path(char* pathname, struct Config cfg) {
    struct stat buf;
    int size;
    char* restrict readbuf = NULL;
    try(lstat(pathname, &buf), -1);
    write_information(buf, cfg, pathname);
    if (S_ISDIR(buf.st_mode) && cfg.recursive) {process_dir(pathname, cfg); printf("\n");}
    else if (S_ISLNK(buf.st_mode)) {
        try(readbuf = malloc(buf.st_size + 2), NULL);
        size = try(readlink(pathname, readbuf, buf.st_size + 2), -1);
        readbuf[size] = '\0';
        printf("Linked to : %s\n", readbuf);
        process_path(readbuf, cfg);
    }
    free(readbuf);
}

void process_dir(char* pathname, struct Config cfg) {
    DIR* dirp = try(opendir(pathname), NULL);
    struct dirent* dirent;
    while ((dirent = readdir(dirp))) {
        // ignore the parent of the parent
        if (strcmp(dirent->d_name, ".") == 0 || strcmp(dirent->d_name, "..") == 0) continue;
        if (!cfg.minusN && !cfg.minusL) printf("%s%s", dirent->d_name, cfg.sep);
        // build the full path
        char file_path[8192];
        snprintf(file_path, sizeof(file_path), "%s/%s", pathname, dirent->d_name);
        process_path(file_path, cfg);
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
    struct Config cfg = {0, 0, "  ", 0, 0};
    
    while((opt = getopt(argc, argv, "RF1ln")) != -1) {
        switch (opt)
        {
        case 'R':
            cfg.recursive = 1;
            break;
        case 'F':
            cfg.full = 1;
            break;
        case '1':
            cfg.sep = "\n";
            break;
        case 'l':   // name in char* (ls -l)
            cfg.minusL = 1;
            break;
        case 'n':   // name in numbers (ls -n)
            cfg.minusN = 1;
            break;
        default:
            fprintf(stderr, "Usage: %s [-R] [FILE]...\n", argv[0]);
            exit(EXIT_FAILURE);
            break;
        }
    }

    if (argc == optind) { // only options, no folder in the command
        process_dir(".", cfg);
    } else {
        for (char** argp = argv + optind; *argp; argp++) {
            if (is_file(*argp))           process_path(*argp, cfg);
            else if (is_directory(*argp)) process_dir(*argp, cfg);
        }
    }

    exit(EXIT_SUCCESS);
}
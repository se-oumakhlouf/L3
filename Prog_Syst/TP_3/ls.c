#include "../../try.h"
#include <unistd.h>
#include <dirent.h>
#include <sys/types.h>

int main(int argc, char* argv[]) {
    DIR* dirp;
    struct dirent* dirent;
    dirp = try(opendir("."), NULL);
    dirent = try(readdir(dirp), NULL);
    printf("Name : %s\n", dirent->d_name);
    try(closedir(dirp), -1);
}
#include <stdio.h>

int main(int argc, char * argv[]) {

    for (int i = 1; i < argc - 1; i ++) {
        printf("%s ", argv[i]);
    }
    printf("%s\n", argv[argc - 1]);

    return 0;
}
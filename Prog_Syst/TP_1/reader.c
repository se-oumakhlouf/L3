#include <stdio.h>
#include "try.h"

int main(int argc, char * argv[]) {

    for (int c; c != EOF; c = fgetc(stdin)) {
        try(fputc(c, stdout), EOF);
    }

    return 0;
}

/*
    man man > text.txt
    time ./reader < text.txt

    real : 0,005sec
    user : 0,002sec
    sys  : 0,000sec
*/
#include <stdio.h>

int main(int argc, char * argv[]) {

    setbuf(stdin, NULL);

    for (int c; c != EOF; c = fgetc(stdin)) {
        fputc(c, stdout);
    }

    return 0;
}

/*
    man man > text.txt
    time ./reader2 < text.txt

    real : 0,050sec
    user : 0,004sec
    sys  : 0,043sec

    L'exec est plus longue en désactivant le buffer
*/
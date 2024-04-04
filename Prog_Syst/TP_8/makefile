CC=gcc
LEX=flex
YACC=bison
CFLAGS=-c -Wall -Wextra -g
LDFLAGS=-Wall -Wextra -g -ll -ly
EXEC=mysh

$(EXEC): main.o joblist.o lexer.o parser.o
	$(CC) -o $@ $^ $(LDFLAGS)

main.o: main.c joblist.h try.h
	$(CC) -o $@ $< $(CFLAGS)

lexer.o: lexer.c joblist.h parser.h try.h
	$(CC) -o $@ $< $(CFLAGS)

parser.o: parser.c joblist.h
	$(CC) -o $@ $< $(CFLAGS)

joblist.o: joblist.c joblist.h parser.h try.h
	$(CC) -o $@ $< $(CFLAGS)

lexer.c: lexer.l
	$(LEX) -o $@ $<

parser.c parser.h: parser.y
	$(YACC) -d -o parser.c $<

.PHONY: clean mrproper test

clean:
	rm -rf lexer.c parser.[ch] *.o

mrproper: clean
	rm -f $(EXEC)

test: $(EXEC)
	@chmod u+x test
	./test ./$(EXEC)

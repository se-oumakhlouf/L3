# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g -fsanitize=leak

all : Symbols_Table

Symbols_Table : Symbols_Table.c Symbols_Table.h
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o

fclean: clean
	rm -rf Symbols_Table

re: fclean all

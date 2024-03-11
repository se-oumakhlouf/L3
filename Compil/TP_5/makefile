# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all : main.o Symbols_Table.o
	$(CC) -o exec $^ $(CFLAGS)

main.o: main.c Symbols_Table.h Symbols_Table.c
	$(CC) -o $@ -c $< $(CFLAGS)

Symbols_Table.o: Symbols_Table.c Symbols_Table.h
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf *.o

fclean: clean
	rm -rf exec

re: fclean all

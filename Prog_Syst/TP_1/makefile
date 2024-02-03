# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all : myecho_getopt reader reader2 myecho

myecho : myecho.c
	$(CC) -o $@ $< $(CFLAGS)

myecho_getopt : myecho_getopt.c
	$(CC) -o $@ $< $(CFLAGS)

reader : reader.c try.h
	$(CC) -o $@ $< $(CFLAGS)

reader2: reader2.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf myecho reader reader2 myecho_getopt

fclean: clean
	rm -rf text.txt

re: clean all

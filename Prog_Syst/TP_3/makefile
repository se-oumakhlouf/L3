# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all: ls

ls: ls.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f ls

re: clean all
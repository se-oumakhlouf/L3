# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all: ls ls_rec

ls: ls.c
	$(CC) $(CFLAGS) -o $@ $<

ls_rec: ls_rec.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f ls ls_rec

re: clean all
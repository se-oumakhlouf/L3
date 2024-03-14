# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all: dispatch add sub div mult 

add: add.c
	$(CC) $(CFLAGS) -o $@ $<

sub: sub.c
	$(CC) $(CFLAGS) -o $@ $<

div: div.c
	$(CC) $(CFLAGS) -o $@ $<

mult: mult.c
	$(CC) $(CFLAGS) -o $@ $<

dispatch: dispatch.c
	$(CC) $(CFLAGS) -o $@ $<

clean: 
	rm -f add sub mult div

fclean: clean
	rm -f dispatch

re: fclean all
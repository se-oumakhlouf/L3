# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all: exo1 exo1_2 exo2

exo1: resize.c
	$(CC) $(CFLAGS) -o $@ $<

exo1_2: resize_2.c
	$(CC) $(CFLAGS) -o $@ $<

exo2 : speed.c
	$(CC) $(CFLAGS) -o $@ $<

clean: 
	rm -f exo*

re: clean all
# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all: exo1 exo2 exo3

exo1: warmup.c 
	$(CC) $(CFLAGS) -o $@ $<

exo2: bilingue.c
	$(CC) $(CFLAGS) -o $@ $<

exo3: exec.c
	$(CC) $(CFLAGS) -o $@ $<

clean: 
	rm -f exo? run_ls

re: clean all
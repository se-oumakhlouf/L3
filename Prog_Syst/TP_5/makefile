# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all: exo? runner

exo1: redirection.c
	$(CC) $(CFLAGS) -o $@ $<

runner: runner.c
	$(CC) $(CFLAGS) -o $@ $<

exo3: pipe.c
	$(CC) $(CFLAGS) -o $@ $<

clean: 
	rm -f exo? runner

fclean: clean
	rm -f sortie*

re: fclean all
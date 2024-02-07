# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS= -Wall -g

all : cat cat2

cat: cat.c
	$(CC) -o $@ $< $(CFLAGS)

cat2: cat2.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf cat cat2

fclean: clean
	rm -rf *.txt

re: clean all

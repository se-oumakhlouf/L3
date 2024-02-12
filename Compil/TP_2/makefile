# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

all: exo1 exo2 exo3 exo4

exo1: lazy.o utils.o
	gcc -o lazy $^ -nostartfiles -no-pie

exo2: registers.o utils.o
	gcc -o registers $^ -nostartfiles -no-pie

exo3: cond.o utils.o
	gcc -o cond $^ -nostartfiles -no-pie

exo4: boucles.o utils.o
	gcc -o boucles $^ -nostartfiles -no-pie

lazy.o: lazy.asm
	nasm -f elf64 -o $@ $<

utils.o: utils.asm
	nasm -f elf64 -o $@ $<

registers.o: registers.asm
	nasm -f elf64 -o $@ $<

cond.o: cond.asm
	nasm -f elf64 -o $@ $<

boucles.o: boucles.asm
	nasm -f elf64 -o $@ $<

clean:
	rm -f *.o

fclean: clean
	rm -f lazy registers cond boucles

re: fclean all

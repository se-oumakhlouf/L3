# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

all: exo1 exo2

exo1: little_endian.o utils.o
	gcc -o exo1 $^ -nostartfiles -no-pie

exo2: allocation.o utils.o
	gcc -o exo2 $^ -nostartfiles -no-pie

little_endian.o: little_endian.asm
	nasm -f elf64 -o $@ $<

utils.o: utils.asm
	nasm -f elf64 -o $@ $<

allocation.o: allocation.asm
	nasm -f elf64 -o $@ $<

clean:
	rm -f *.o

fclean: clean
	rm -f exo?

re: fclean all

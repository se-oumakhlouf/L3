# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

all: exo1 exo2

exo1: carre.o carre_main.o utils.o
	gcc -o exo1 $^ -nostartfiles -no-pie

exo2: registres.o utils.o
	gcc -o exo2 $^ -nostartfiles -no-pie

carre_main.o: carre_main.asm carre.asm
	nasm -f elf64 -o $@ $<	

carre.o: carre.asm
	nasm -f elf64 -o $@ $<

registres.o: registres.asm utils.asm
	nasm -f elf64 -o $@ $<

utils.o: utils.asm
	nasm -f elf64 -o $@ $<

clean:
	rm -f *.o

fclean: clean
	rm -f exo?

re: fclean all

#include "Symbols_Table.h"
#include <stdio.h>

int main(int argc, char* argv[]) {
    /* test */
    Symbols_Table* table = init_table();
    Symbols* s1 =  make_symbols("tab", "array", 1010, 1020);
    Symbols* s2 =  make_symbols("tab2", "array", 10102020, 1020);
    add_symbol(table, s1);
    add_symbol(table, s2);
    add_symbol(table, s1);
    print_table(table);
    free_table(table);

    FILE * file = fopen("_anonymous.asm", "w");
    read_globals(" ", &table);
    fclose(file);
    return 0;
}
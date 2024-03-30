/* Exercice 2 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Symbols_Table.h"
#include "../../try.h"


Symbols_Table* init_table() {
    Symbols_Table* table = (Symbols_Table*)malloc(sizeof(Symbols_Table));
    table->size = 0;
    table->size_max = INIT_SIZE;
    return table;
}

void free_table(Symbols_Table * table) {
    for (int i = 0; i < table->size; i++) {
        free(table->tab[i].ident);
        free(table->tab[i].type);
    }
    free(table);
}

Symbols* make_symbols(char* ident, char* type, long int adresse, long int deplct) {
    Symbols* symbol = (Symbols*)malloc(sizeof(Symbols));
    if (symbol == NULL) {
        return NULL;
    }
    try(symbol->ident = strdup(ident), NULL);
    try(symbol->type = strdup(type), NULL);
    symbol->adresse = adresse;
    symbol->deplct = deplct;
    return symbol;
}

void add_symbol(Symbols_Table *table, Symbols *symbol) {
    if (isPresent(table, symbol)) {return;}
    if (table->size < table->size_max) {
        table->tab[table->size++] = *symbol;
        printf("added : %s\n", symbol->ident);
    } else {printf("The table is full\n");}
}

int isEqual(Symbols s1, Symbols s2) {
    if (strcmp(s1.ident, s2.ident) == 0) {return 1;} 
    return 0;
}

int isPresent(Symbols_Table *table, Symbols *symbol) {
    for (int i = 0; i < table->size; i++) {
        if (isEqual(table->tab[i], *symbol)) {
            printf("Equal : %s, %s\n", table->tab[i].ident, symbol->ident);
            return 1;
        }
    }
    return 0;
}

void print_table(Symbols_Table *table) {
    printf("\nSymbols Table:\n");
    printf("%-10s %-10s %-10s %-10s\n", "Ident", "Type", "Adresse", "Deplct");
    for (int i = 0; i < table->size; i++) {
        printf("%-10s %-10s %-10ld %-10ld\n", table->tab[i].ident, table->tab[i].type, table->tab[i].adresse, table->tab[i].deplct);
    }
    printf("\n");
}


int main(int argc, char* argv[]) {
    Symbols_Table* table = init_table();
    Symbols* s1 =  make_symbols("tab", "array", 1010, 1020);
    Symbols* s2 =  make_symbols("tab2", "array", 10102020, 1020);
    add_symbol(table, s1);
    add_symbol(table, s2);
    add_symbol(table, s1);
    print_table(table);
    free_table(table);
    return 0;
}

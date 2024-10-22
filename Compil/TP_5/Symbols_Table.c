/* Exercice 1 */
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


void read_globals(FILE *file, Symbols_Table *table) {
    char line[256];
    while (fgets(line, sizeof(line), file) != NULL) {
        // Ignorer les lignes vides
        if (strlen(line) <= 1) {
            continue;
        }
        // Appel de main
        if (strstr(line, "main") != NULL && strstr(line, "(") != NULL) {
            // Identifier la déclaration de variable globale
            char *identifier = strtok(line, " ;\n");
            char *type = strtok(NULL, " ;\n");
            if (identifier != NULL && type != NULL) {
                Symbols *symbol = (Symbols*)malloc(sizeof(Symbols));
                symbol->ident = strdup(identifier);
                symbol->type = strdup(type);
                symbol->adresse = 0;
                add_symbol(table, symbol);
            }
        }
    }
}




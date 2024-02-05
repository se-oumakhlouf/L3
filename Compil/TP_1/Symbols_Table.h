#ifndef __SYM__
#define __SYM__

#define INIT_SIZE 50

typedef struct Symbols
{
    char* ident; 
    char* type;
    long int adresse; /* Son adresse */
    long int deplct; /* Prochain emplacement mémoire */
} Symbols;

typedef struct Symbols_Table
{
    Symbols tab[INIT_SIZE];
    int size;
    int size_max;
} Symbols_Table;


Symbols_Table* init_table();

void free_table(Symbols_Table * table);

Symbols* make_symbols(char* ident, char* type, long int adresse, long int deplct);

void add_symbol(Symbols_Table *table, Symbols *symbol);

/* Return 1 if the symbol is already in the table, 0 otherwise */
int isPresent(Symbols_Table *table, Symbols *symbol);

/* Return 1 if s1 = s2, 0 otherwise */
int isEqual(Symbols s1, Symbols s2);

void print_table(Symbols_Table *table);

#endif
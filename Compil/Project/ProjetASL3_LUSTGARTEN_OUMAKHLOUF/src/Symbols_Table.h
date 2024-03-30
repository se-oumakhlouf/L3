#ifndef __SYM__
#define __SYM__

#define INIT_SIZE 2048



typedef enum Type
{
    FUNCTION,
    INT,
    CHAR,
    VOID
} Type;


typedef struct Symbol
{
    char* ident;
    Type type;
    int size;
    long int deplct;
} Symbol;


typedef struct Symbols_Table
{
    Symbol* tab[INIT_SIZE];
    long int index;
} Symbols_Table;


typedef struct Function_Table
{
    char* ident;
    Symbols_Table* header;
    Symbols_Table* body;
    struct Function_Table* next;
} Function_Table;


typedef struct Program_Table
{
    Symbols_Table* globals; /* pointer is lighter in memory */
    Function_Table* functions;
} Program_Table;










/*

Symbols_Table* init_table();

void free_table(Symbols_Table * table);

Symbols* make_symbols(char* ident, char* type, long int adresse, long int deplct);

void add_symbol(Symbols_Table *table, Symbols *symbol);

*/

/* Return 1 if the symbol is already in the table, 0 otherwise */
// int isPresent(Symbols_Table *table, Symbols *symbol);

/* Return 1 if s1 = s2, 0 otherwise */
// int isEqual(Symbols s1, Symbols s2);

// void print_table(Symbols_Table *table);


#endif
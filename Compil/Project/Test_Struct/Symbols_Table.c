/* Exercice 2 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Symbols_Table.h"
#include "../../../try.h"

// using try might be a bad idea, stops the program if malloc fails

int determine_size(Type type) {
    switch (type) {
        case INT: return 4;
        case CHAR: return 1;
        case VOID: return 0;
        // case FUNCTION: return ???;
        default: return -1;
    }
}

char* type_to_string(Type type) {
    switch (type) {
        case FUNCTION: return "FUNCTION";
        case INT: return "INT";
        case CHAR: return "CHAR";
        case VOID: return "VOID";
        default: return "UNKNOWN";
    }
}

int get_last_adress(Symbols_Table* sym_table) {
    if (sym_table->index == 0) {return 0;}
    return sym_table->tab[sym_table->index - 1]->deplct;
}

Symbol* make_symbol(char* ident, Type type, int adress_prev) {
    Symbol* symbol = try((Symbol*)malloc(sizeof(Symbol)), NULL);
    symbol->ident = try(strdup(ident), NULL);
    symbol->type = type;
    symbol->size = determine_size(type);
    symbol->deplct = adress_prev + symbol->size;
    return symbol;
}

Symbols_Table* init_Sym_table() {
    Symbols_Table* sym_table = try((Symbols_Table*)malloc(sizeof(Symbols_Table)), NULL);
    sym_table->index = 0;
    memset(sym_table->tab, 0, INIT_SIZE * sizeof(Symbol*));
    return sym_table;
}

Function_Table* init_Func_table(char* ident) {
    Function_Table* func_table = try((Function_Table*)malloc(sizeof(Function_Table)), NULL);
    func_table->next = NULL;
    func_table->ident = try(strdup(ident), NULL);
    func_table->header = init_Sym_table();
    func_table->body = init_Sym_table();
    return func_table;
}

Program_Table* init_Program_table() {
    Program_Table* prog_table = try((Program_Table*)malloc(sizeof(Program_Table)), NULL);
    prog_table->globals = init_Sym_table();
    prog_table->functions = NULL;
    return prog_table;
}

void free_symbol(Symbol* symbol) {
    free(symbol->ident);
    free(symbol);
}

void free_Sym_table(Symbols_Table* sym_table) {
    for (int i = 0; i < INIT_SIZE; i++) {
        if (sym_table->tab[i] != NULL) {
            free_symbol(sym_table->tab[i]);
        }
    }
    free(sym_table);
}

void free_Func_table(Function_Table* func_table) {
    free(func_table->ident);
    free_Sym_table(func_table->header);
    free_Sym_table(func_table->body);
    free(func_table);
}

void free_Program_table(Program_Table* prog_table) {
    free_Sym_table(prog_table->globals);
    Function_Table* func = prog_table->functions;
    while (func != NULL) {
        Function_Table* next = func->next;
        free_Func_table(func);
        func = next;
    }
    free(prog_table);
}

int isPresent(Symbols_Table* sym_table, Symbol* symbol) {
    for (int i = 0; i < sym_table->index; i++) {
        if (strcmp(sym_table->tab[i]->ident, symbol->ident) == 0) {
            return 1;
        }
    }
    return 0;
}

void add_symbol(Symbols_Table* sym_table, Symbol* symbol) {
    if (isPresent(sym_table, symbol)) {return;}
    sym_table->tab[sym_table->index++] = symbol;
}

void print_symbol(Symbol* symbol) {
    printf("\tIdent: %-10s\n", symbol->ident);
    printf("\t\tType: %-10s\n", type_to_string(symbol->type));
    printf("\t\tSize: %-10d\n", symbol->size);
    printf("\t\tDeplct: %-10ld\n", symbol->deplct);
}

void print_sym_table(Symbols_Table* sym_table) {
    for (int i = 0; i < sym_table->index; i++) {
        print_symbol(sym_table->tab[i]);
    }
}

void print_func_table(Function_Table* func) {
    printf("Ident: %-10s\n", func->ident);
    printf("Header:\n");
    print_sym_table(func->header);
    printf("Body:\n");
    print_sym_table(func->body);
}

void print_program_table(Program_Table* prog) {
    printf("Globals:\n");
    print_sym_table(prog->globals);
    Function_Table* func = prog->functions;
    while (func != NULL) {
        print_func_table(func);
        func = func->next;
    }
}


int main(int argc, char* argv[]) {
    Program_Table* prog_table = init_Program_table();
    Symbol* symbol = make_symbol("a", INT, get_last_adress(prog_table->globals));
    add_symbol(prog_table->globals, symbol);
    symbol = make_symbol("b", CHAR, get_last_adress(prog_table->globals));
    add_symbol(prog_table->globals, symbol);
    symbol = make_symbol("c", CHAR, get_last_adress(prog_table->globals));
    add_symbol(prog_table->globals, symbol);
    symbol = make_symbol("d", INT, get_last_adress(prog_table->globals));
    add_symbol(prog_table->globals, symbol);
    symbol = make_symbol("e", CHAR, get_last_adress(prog_table->globals));
    add_symbol(prog_table->globals, symbol);
    print_program_table(prog_table);
    free_Program_table(prog_table);
    return 0;
}

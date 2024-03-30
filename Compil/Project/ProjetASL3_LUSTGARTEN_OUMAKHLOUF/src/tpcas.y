%{
/* Projet Analyse Syntaxique 
LUSTGARTEN Leo | OUMAKHLOUF Selym */

#include <stdio.h>
#include <string.h>
#include "tree.h"

int yylex(void);
void yyerror(char* s);
int yyparse();

int treeOption = 0;
extern char *yytext;
extern int lineno;
extern int c;
extern int yylineno;

Node * arbre;
Node * node;
%}

%union {
        Node *node;
        char byte;
        int num;
        char ident[64];
        char comp[3];
        }

%type <node> Prog DeclVars Declarateurs DeclFoncts DeclFonct
%type <node> EnTeteFonct Parametres ListTypVar Corps SuiteInstr
%type <node> Instr Exp TB FB M E T F LValue Arguments ListExp
%token <byte> CHARACTER ADDSUB DIVSTAR
%token <num> NUM
%token <ident> IDENT
%token <comp> ORDER EQ TYPE
%token OR AND IF WHILE ELSE RETURN VOID
%expect 1

%%
Prog:  DeclVars DeclFoncts  {
                            $$ = makeNode(program);
                            arbre = $$;
                            addChild($$, $1);
                            addChild($$, $2);
                            }
    ;
DeclVars:
       DeclVars TYPE Declarateurs ';'   {
                                        $$ = $1;
                                        addChild($$, node = makeNode(type));
                                        addChild(node, $3);
                                        strcpy(node->data.comp, $2);
                                        }
    |   {$$ = makeNode(declarations);}
    ;
Declarateurs:
       Declarateurs ',' IDENT   {
                                $$ = $1;
                                addSibling($$, node = makeNode(ident));
                                strcpy(node->data.ident, $3);
                                }
    |  Declarateurs ',' IDENT '[' NUM ']'   {
                                            $$ = $1;
                                            addSibling($$, node = makeNode(ident_tab));
                                            strcpy(node->data.ident, $3);
                                            addChild($$, node = makeNode(num));
                                            node->data.num = $5;
                                            }
    |  IDENT    {$$ = makeNode(ident);
                strcpy($$->data.ident, $1);}
    |  IDENT '[' NUM ']'    {  
                            $$ = makeNode(ident_tab);
                            strcpy($$->data.ident, $1);
                            addChild($$, node = makeNode(num));
                            node->data.num = $3;
                            }
    ;
DeclFoncts:
       DeclFoncts DeclFonct {
                            $$ = $1;
                            addSibling($$, $2);
                            }
    |  DeclFonct    {$$ = $1;}
    ;
DeclFonct:
       EnTeteFonct Corps    {
                            $$ = makeNode(fonction);
                            addChild($$, $1);
                            addChild($$, $2);
                            }
    ;
EnTeteFonct:
       TYPE IDENT '(' Parametres ')'    {
                                        $$ = makeNode(heading);
                                        addChild($$, node = makeNode(type));
                                        strcpy(node->data.comp, $1);
                                        addChild($$, node = makeNode(ident));
                                        strcpy(node->data.ident, $2);
                                        addChild($$, $4);
                                        }
    |  VOID IDENT '(' Parametres ')' {
                                    $$ = makeNode(heading);
                                    addChild($$, makeNode(vide));
                                    addChild($$, node = makeNode(ident));
                                    strcpy(node->data.ident, $2);
                                    addChild($$, $4);
                                    }
    ;
Parametres:
       VOID     {
                $$ = makeNode(parametres);
                addChild($$, makeNode(vide));
                }
    |  ListTypVar   {
                    $$ = makeNode(parametres);
                    addChild($$, $1);
                    }
    ;
ListTypVar:
       ListTypVar ',' TYPE IDENT    {
                                    $$ = makeNode(type);
                                    strcpy($$->data.comp, $3);
                                    addSibling($$, $1);
                                    addChild($$, node = makeNode(ident));
                                    strcpy(node->data.ident, $4);
                                    }
    |  ListTypVar ',' TYPE IDENT '['']' {
                                        $$ = makeNode(type);
                                        strcpy($$->data.comp, $3);
                                        addSibling($$, $1);
                                        addChild($$, node = makeNode(ident_tab));
                                        strcpy(node->data.ident, $4);
                                        }
    |  TYPE IDENT   {
                    $$ = makeNode(type);
                    strcpy($$->data.comp, $1);
                    addChild($$, node = makeNode(ident));
                    strcpy(node->data.ident, $2);
                    }
    |  TYPE IDENT '['']'    {
                            $$ = makeNode(type);
                            strcpy($$->data.comp, $1);
                            addChild($$, node = makeNode(ident_tab));
                            strcpy(node->data.ident, $2);
                            }
    ;
Corps: '{' DeclVars SuiteInstr '}'  {
                                    $$ = makeNode(body);
                                    addChild($$, $2);
                                    addChild($$, $3);
                                    }
    ;
SuiteInstr: 
       SuiteInstr Instr {
                        if ($1 == NULL) {$$ = $2;}
                        else {$$ = $1; addSibling($$, $2);}
                        }
    | {$$ = NULL;}
    ;
Instr:
       LValue '=' Exp ';'   {
                            $$ = makeNode(affectation); 
                            addChild($$, $1); 
                            addChild($$, $3);
                            }
    |  IF '(' Exp ')' Instr {
                            $$ = makeNode(_if); 
                            addChild($$, $3);
                            addChild($$, $5);
                            }
    |  IF '(' Exp ')' Instr ELSE Instr  {
                                        $$ = makeNode(_if); 
                                        addChild($$, $3);
                                        addChild($$, $5);
                                        node = makeNode(_else);
                                        addSibling($$, node); 
                                        addChild(node, $7);
                                        }
    |  WHILE '(' Exp ')' Instr  {
                                $$ = makeNode(_while); 
                                addChild($$, $3);
                                addChild($$, $5);
                                }
    |  IDENT '(' Arguments  ')' ';' {
                                    $$ = makeNode(IDENTs);
                                    addChild($$, node = makeNode(ident));
                                    addChild($$, $3);
                                    strcpy(node->data.ident, $1);
                                    }
    |  RETURN Exp ';'   {
                        $$ = makeNode(_return);
                        addChild($$, $2);
                        }
    |  RETURN ';'   {$$ = makeNode(_return); }
    |  '{' SuiteInstr '}'   {$$ = $2;}
    |  ';'  {$$ = NULL;}
    ;
Exp :  Exp OR TB    {
                    $$ = makeNode(or);
                    addChild($$, $1);
                    addChild($$, $3);
                    }
    |  TB   {$$ = $1;}
    ;
TB  :  TB AND FB    {
                    $$ = makeNode(and);
                    addChild($$, $1);
                    addChild($$, $3);
                    }
    |  FB   {$$ = $1;}
    ;
FB  :  FB EQ M  {
                $$ = makeNode(eq);
                addChild($$, $1);
                addChild($$, $3);
                strcpy($$->data.comp, $2);
                }
    |  M    {$$ = $1;}
    ;
M   :  M ORDER E    {
                    $$ = makeNode(order);
                    addChild($$, $1);
                    addChild($$, $3);
                    strcpy($$->data.comp, $2);
                    }
    |  E    {$$ = $1;}
    ;
E   :  E ADDSUB T   {
                    $$ = makeNode(addsub);
                    addChild($$, $1);
                    addChild($$, $3);
                    $$->data.byte = $2;
                    }
    |  T    {$$ = $1;}
    ;    
T   :  T DIVSTAR F  {
                    $$ = makeNode(divstar);
                    $$->data.byte = $2;
                    addChild($$, $1);
                    addChild($$, $3);
                    }
    |  F    {$$ = $1;}
    ;
F   :  ADDSUB F {
                $$ = makeNode(addsubUnaire);
                $$->data.byte = $1;
                addChild($$, $2);
                }
    |  '!' F    {
                $$ = makeNode(exclamation); 
                addChild($$, $2);
                }
    |  '(' Exp ')'  {$$ = $2;}
    |  NUM  {
            $$ = makeNode(num);
            $$->data.num = $1;
            }
    |  CHARACTER    {
                    $$ = makeNode(charac);
                    $$->data.byte = $1;
                    }
    |  LValue   {$$ = $1;}
    |  IDENT '(' Arguments  ')' {
                                $$ = makeNode(ident);
                                strcpy($$->data.ident, $1);
                                addChild($$, $3);
                                }
    ;
LValue:
       IDENT    {
                $$ = makeNode(ident);
                strcpy($$->data.ident, $1);
                }
    |  IDENT '[' Exp ']'    {
                            $$ = makeNode(ident_tab);
                            strcpy($$->data.ident, $1);
                            addChild($$, $3);
                            }
    ;
Arguments:
       ListExp  {
                $$ = makeNode(args);
                addChild($$, $1);
                }
    |   {$$ = makeNode(args);}
    ;
ListExp:
       ListExp ',' Exp  {
                        $$ = $1;
                        addSibling($$, $3);
                        }
    |  Exp  {$$ = $1;}
    ;
%%

void afficherHelp(){
    printf("\n\n");
    printf("Utilisation : tpcas [OPTION]... [FICHIER]...\n");
    printf("Fait l'analyse syntaxique du fichier .tpc redirigé en entrée\n");
    printf("\n[OPTION]\n");
    printf("\t -t, --tree          afficher l'arbre abstrait du fichier analysé\n");
    printf("\t -h, --help          afficher l'aide et quitter \n");
    printf("\n[FICHIER]\n");
    printf("\tPour rediriger un fichier ajoutez \"< file.tpc\" à la ligne de commande\n");
    printf("\nExemple\n");
    printf("\t./pathToExec/tpcas -t < pathToFile/file.tpc\n\n");
    printf("État de sortie :\n");
    printf(" 0 en cas de succès (pas d'erreur syntaxique dans le fichier ou option qui met fin au programme)\n");
    printf(" 1 en cas de problème syntaxique dans le fichier\n");
    printf(" 2 en cas de problème divers, et affiche un message d'erreur (qui n'est pas lié à l'analyse syntaxique)\n");
    printf("\nSignalez les problèmes de traduction de à : <selym.oumakhlouf@edu.univ-effeil.fr> ou <leo.lustgarten@edu.univ-effeil.fr>\n");
    printf("\n\n");
}

int main(int argc, char* argv[]){
    int error;
    for (int i = 1; i < argc; i++){
        if (strcmp(argv[i], "-t") == 0 || strcmp(argv[i], "--tree") == 0){
            treeOption = 1;
        }
        else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0){
            afficherHelp();
            return 0;
        }
        else if (argv[i][0] == '-'){
            fprintf(stderr, "\n\ttpcas: \"%s\" n'est pas une option valide !\n", argv[i]);
            fprintf(stderr, "\tEntrez -h ou --help pour voir le manuel d'utilisation de tpcas\n\n");
            return 2;
        }
        else{
            fprintf(stderr, "\n\ttpcas: La ligne de commande entrée est invalide,\n");
            fprintf(stderr, "\tEntrez -h ou --help pour voir le manuel d'utilisation de tpcas\n\n");
            return 3;
        }
    }
    error = yyparse();
    if (treeOption && !error) printTree(arbre);
    return error;
}

void yyerror(char * s){
    fprintf(stderr, "   Error : %s\n", s);
    fprintf(stderr, "   line : %d, column : %d\n", lineno, c);
}
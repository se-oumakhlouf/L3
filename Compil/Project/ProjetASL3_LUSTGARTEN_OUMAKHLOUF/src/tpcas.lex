%{
/* Identification par analyse lexicale des lexèmes */
#include "tree.h"
#include "tpcas.h"
int lineno = 1;
int c = 0;
%}

%option nounput
%option noinput
%x COMMENT

%%

    /* Mot clés */
if              {c += strlen(yytext); return IF;}
while           {c += strlen(yytext); return WHILE;}
else            {c += strlen(yytext); return ELSE;}
return          {c += strlen(yytext); return RETURN;}

    /* Types */
int|char            {c += strlen(yytext); strcpy(yylval.comp, yytext); return TYPE;}
void                {c += strlen(yytext); return VOID;}

    /* Nombres */
[0-9]+              {c += strlen(yytext); yylval.num = atoi(yytext); return NUM;}

    /* Identificateur */
[a-zA-Z_][a-zA-Z_0-9]*  {c += strlen(yytext); strcpy(yylval.ident, yytext); return IDENT;}

    /* Caractère */
'[^']'|'\\[n|t|']'      {c += strlen(yytext); yylval.byte = yytext[1]; return CHARACTER;}

    /* Opérateurs arithmétiques */
[+-]        {c += strlen(yytext); yylval.byte = yytext[0]; return ADDSUB;}
[*/%]       {c += strlen(yytext); yylval.byte = yytext[0]; return DIVSTAR;}

    /* Comparateurs */
==|!=           {c += strlen(yytext); strcpy(yylval.comp, yytext); return EQ;}
\<|>|>=|\<=     {c += strlen(yytext); strcpy(yylval.comp, yytext); return ORDER;}

    /* And - Or */
&&          {c += strlen(yytext); return AND;}
\|\|        {c += strlen(yytext); return OR;}

    /* Autre lexèmes */
[=!(){};,\[\]]  {c += strlen(yytext); return yytext[0];} 

[ \t]*      {c += strlen(yytext); ;}
[\n]        {lineno++; c = 0;}

.           {return 1;}
<INITIAL><<EOF>>     {return 0;} /* besoin de <INITIAL> sinon flex détecte une redondance avec <<EOF>> de <COMMENT> */

    /* Commentaire */
\/\/.*              {c += strlen(yytext);}                 /* type // */

"/*"                {c += strlen(yytext); BEGIN(COMMENT);}   /* commentaire du C */
<COMMENT><<EOF>>    {return 1;}         /* Commentaire non fermé */
<COMMENT>"*/"       {c += strlen(yytext); BEGIN(INITIAL);}
<COMMENT>\t         {c += strlen(yytext);}
<COMMENT>.          {c += strlen(yytext);}
<COMMENT>\n         {lineno++; c = 0;}

%%
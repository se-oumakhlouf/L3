%{
  #include "joblist.h"
  #include "parser.h"
  #include "try.h"
%}

%option noinput nounput

SimpleWord [a-zA-Z0-9_\-+=.,:/@!%\[\]]+
SingleQuotedWord \'([^'])*\'
DoubleQuotedWord \"(\\.|[^\\"])*\"

%%

[ \t\n]+ {
  // NOP
}

"<" {
  return REDIN;
}

">" {
  return REDOUT;
}

">>" {
  return REDOUT_APP;
}

"|" {
  return PIPE;
}

"&" {
  return BG;
}

{SimpleWord}|{SingleQuotedWord}|{DoubleQuotedWord} {
  char *text = yytext;
  size_t len = strlen(text);
  if (text[0] == '\'' || text[0] == '"') {  // got a quoted word
    text[len - 1] = '\0';
    text += 1;
    len -= 2;
  }
  yylval.word = try(malloc(len + 1), NULL);
  strncpy(yylval.word, text, len + 1);
  return WORD;
}

. {
  return yytext[0];
}

%%

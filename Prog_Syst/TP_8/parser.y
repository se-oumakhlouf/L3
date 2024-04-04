%{
  #include <stdio.h>
  int yylex();
  void yyerror(const char *s);

  #include "joblist.h"
  extern Job *parsedJob;
%}

%define parse.error verbose

%union {
  char *word;
  Proc *proc;
  ProcList *procList;
  Job *job;
}

%token END 0
%token REDIN REDOUT REDOUT_APP PIPE BG
%token <word> WORD
%type <proc> Command
%type <procList> Pipeline
%type <job> Job

%destructor { free($$); } WORD
%destructor { delProc($$); } Command
%destructor { delProcList($$); } Pipeline
%destructor { delJob($$); } Job

%%

CmdLine:
  %empty {
    // NOP
  }|
  Job END {
    parsedJob = $1;
  };

Job:
  Pipeline {
    $$ = newJob();
    $$->pipeline = $1;
  }|
  Pipeline BG {
    $$ = newJob();
    $$->pipeline = $1;
    $$->bg = true;
  };

Pipeline:
  Command {
    $$ = newProcList();
    addProcToListTail($1, $$);
  }|
  Pipeline PIPE Command {
    $$ = $1;
    addProcToListTail($3, $$);
  };

Command:
  WORD {
    $$ = newProc();
    $$->args = newStrVec();
    addStrToVec($1, $$->args);
  }|
  Command WORD {
    $$ = $1;
    addStrToVec($2, $$->args);
  }|
  Command REDIN WORD {
    $$ = $1;
    free($$->redin);
    $$->redin = $3;
  }|
  Command REDOUT WORD {
    $$ = $1;
    free($$->redout);
    $$->redout = $3;
    $$->append = false;
  }|
  Command REDOUT_APP WORD {
    $$ = $1;
    free($$->redout);
    $$->redout = $3;
    $$->append = true;
  };

%%

void yyerror (const char *s) {
  fprintf (stderr, "%s\n", s);
}

# Makefile Projet Analyse Syntaxique
# LUSTGARTEN Leo | OUMAKHLOUF Selym

# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
LEXFLAGS=
CFLAGS=-Wall
LDFLAGS=-Wall -ll
BISONFLAGS=-d
EXEC=tpcas
PARS=$(EXEC)
LEX=$(EXEC)
BINDIR=bin
OBJDIR=obj
SRCDIR=src

$(BINDIR)/$(EXEC): $(OBJDIR)/$(PARS).o $(OBJDIR)/$(LEX).yy.o $(OBJDIR)/tree.o
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/$(PARS).o: $(SRCDIR)/$(PARS).c $(SRCDIR)/tree.h
	$(CC) -o $@ -c $< $(CFLAGS)

$(OBJDIR)/$(LEX).yy.o: $(SRCDIR)/$(LEX).yy.c $(SRCDIR)/$(PARS).h $(SRCDIR)/tree.h
	$(CC) -o $@ -c $< $(CFLAGS)

$(OBJDIR)/tree.o: $(SRCDIR)/tree.c $(SRCDIR)/tree.h
	$(CC) -o $@ -c $< $(CFLAGS)

$(SRCDIR)/$(PARS).c $(SRCDIR)/$(PARS).h: $(SRCDIR)/$(PARS).y
	bison $(BISONFLAGS) -o $(SRCDIR)/$(PARS).c $(SRCDIR)/$(PARS).y

$(SRCDIR)/$(LEX).yy.c: $(SRCDIR)/$(LEX).lex
	flex $(LEXFLAGS) -o $(SRCDIR)/$(LEX).yy.c $(SRCDIR)/$(LEX).lex

clean:
	rm -f $(BINDIR)/* $(OBJDIR)/* $(SRCDIR)/$(LEX).yy.* $(SRCDIR)/$(PARS).[och] rep/rapport.txt bin/* obj/*


/* tree.c */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
extern int lineno;       /* from lexer */

static const char *StringFromLabel[] = {
  "program",
  "type",
  "declarations",
  "ident",
  "fonction",
  "heading",
  "vide",
  "parametres",
  "body",
  "IDENTs", 
  "or", 
  "and",
  "eq", 
  "addsub",
  "order",
  "addsubUnaire",
  "exclamation",
  "num",
  "charac",
  "args",
  "divstar",
  "affectation",
  "instructions",
  "return",
  "if",
  "else",
  "while",
  "ident_tab",
  /* list all other node labels, if any */
  /* The list must coincide with the label_t enum in tree.h */
  /* To avoid listing them twice, see https://stackoverflow.com/a/10966395 */
};

Node *makeNode(label_t label) {
  Node *node = malloc(sizeof(Node));
  if (!node) {
    printf("Run out of memory\n");
    exit(1);
  }
  node->label = label;
  node-> firstChild = node->nextSibling = NULL;
  node->lineno=lineno;
  return node;
}

void addSibling(Node *node, Node *sibling) {
  Node *curr = node;
  while (curr->nextSibling != NULL) {
    curr = curr->nextSibling;
  }
  curr->nextSibling = sibling;
}

void addChild(Node *parent, Node *child) {
  if (parent->firstChild == NULL) {
    parent->firstChild = child;
  }
  else {
    addSibling(parent->firstChild, child);
  }
}

void deleteTree(Node *node) {
  if (node->firstChild) {
    deleteTree(node->firstChild);
  }
  if (node->nextSibling) {
    deleteTree(node->nextSibling);
  }
  free(node);
}

void printTree(Node *node) {
  static bool rightmost[128]; // tells if node is rightmost sibling
  static int depth = 0;       // depth of current node
  for (int i = 1; i < depth; i++) { // 2502 = vertical line
    printf(rightmost[i] ? "    " : "\u2502   ");
  }
  if (depth > 0) { // 2514 = L form; 2500 = horizontal line; 251c = vertical line and right horiz 
    printf(rightmost[depth] ? "\u2514\u2500\u2500 " : "\u251c\u2500\u2500 ");
  }
  
  switch (node->label) {

    case num:
      printf("%d\n", node->data.num);
      break;

    case ident_tab:
    case ident:
      printf("%s\n", node->data.ident);
      break;

    case type:
    case eq:
    case order:
      printf("%s\n", node->data.comp);
      break;

    case addsub:
    case addsubUnaire:
    case charac:
    case divstar:
      printf("%c\n", node->data.byte);
      break;

    default:
      printf("%s\n", StringFromLabel[node->label]);
      break;
  }
  
  depth++;
  for (Node *child = node->firstChild; child != NULL; child = child->nextSibling) {
    rightmost[depth] = (child->nextSibling) ? false : true;
    printTree(child);
  }
  depth--;
}

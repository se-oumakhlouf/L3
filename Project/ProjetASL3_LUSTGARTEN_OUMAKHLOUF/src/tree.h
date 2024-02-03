/* tree.h */

typedef enum {
  program,
  type,
  declarations,
  ident,
  fonction,
  heading,
  vide,
  parametres,
  body,
  IDENTs, 
  or, 
  and,
  eq, 
  addsub,
  order,
  addsubUnaire,
  exclamation,
  num,
  charac,
  args,
  divstar,
  affectation,
  instructions,
  _return,
  _if,
  _else,
  _while,
  ident_tab
  /* list all other node labels, if any */
  /* The list must coincide with the string array in tree.c */
  /* To avoid listing them twice, see https://stackoverflow.com/a/10966395 */
} label_t;

typedef struct Node {
  label_t label;
  struct Node *firstChild, *nextSibling;
  int lineno;
  union 
  {
    char byte;
    int num;
    char ident[64];
    char comp[3];
  } data;
  
} Node;

Node *makeNode(label_t label);
void addSibling(Node *node, Node *sibling);
void addChild(Node *parent, Node *child);
void deleteTree(Node*node);
void printTree(Node *node);

#define FIRSTCHILD(node) node->firstChild
#define SECONDCHILD(node) node->firstChild->nextSibling
#define THIRDCHILD(node) node->firstChild->nextSibling->nextSibling

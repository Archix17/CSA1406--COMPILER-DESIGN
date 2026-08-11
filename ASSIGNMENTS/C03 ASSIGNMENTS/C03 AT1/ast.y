%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Node {
    char *value;
    struct Node *left;
    struct Node *right;
};

struct Node *createNode(char *value, struct Node *left, struct Node *right)
{
    struct Node *newNode = (struct Node *)malloc(sizeof(struct Node));

    newNode->value = value;
    newNode->left = left;
    newNode->right = right;

    return newNode;
}

void preorder(struct Node *root)
{
    if (root != NULL)
    {
        printf("%s ", root->value);
        preorder(root->left);
        preorder(root->right);
    }
}

void inorder(struct Node *root)
{
    if (root != NULL)
    {
        inorder(root->left);
        printf("%s ", root->value);
        inorder(root->right);
    }
}

void postorder(struct Node *root)
{
    if (root != NULL)
    {
        postorder(root->left);
        postorder(root->right);
        printf("%s ", root->value);
    }
}

void printTree(struct Node *root, int space)
{
    if (root == NULL)
        return;

    space += 5;

    printTree(root->right, space);

    printf("\n");
    for (int i = 5; i < space; i++)
        printf(" ");

    printf("%s\n", root->value);

    printTree(root->left, space);
}

int yylex(void);
int yyerror(char *s);
%}

%union {
    char *str;
    struct Node *node;
}

%token <str> ID

%type <node> expr

%left '+'
%left '*'

%%

input:
      expr '\n'
      {
          printf("\nAbstract Syntax Tree:\n");
          printTree($1, 0);

          printf("\nPreorder Traversal: ");
          preorder($1);

          printf("\nInorder Traversal: ");
          inorder($1);

          printf("\nPostorder Traversal: ");
          postorder($1);

          printf("\n");
      }
      ;

expr:
      expr '+' expr
      {
          $$ = createNode(strdup("+"), $1, $3);
      }
    | expr '*' expr
      {
          $$ = createNode(strdup("*"), $1, $3);
      }
    | ID
      {
          $$ = createNode($1, NULL, NULL);
      }
    ;

%%

int yyerror(char *s)
{
    printf("Invalid expression\n");
    return 0;
}

int main()
{
    printf("Enter an arithmetic expression: ");
    yyparse();
    return 0;
}
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TYPES 20
#define MAX_VARS 20

struct Type {
    char name[20];
    char base[20];
};

struct Variable {
    char name[20];
    char type[20];
};

struct Type types[MAX_TYPES];
struct Variable variables[MAX_VARS];

int typeCount = 0;
int varCount = 0;

int yylex(void);
int yyerror(char *s);

void addType(char *name, char *base)
{
    strcpy(types[typeCount].name, name);
    strcpy(types[typeCount].base, base);
    typeCount++;
}

void addVariable(char *name, char *type)
{
    strcpy(variables[varCount].name, name);
    strcpy(variables[varCount].type, type);
    varCount++;
}

char *getVariableType(char *name)
{
    for (int i = 0; i < varCount; i++)
    {
        if (strcmp(variables[i].name, name) == 0)
            return variables[i].type;
    }

    return NULL;
}

char *getBaseType(char *type)
{
    for (int i = 0; i < typeCount; i++)
    {
        if (strcmp(types[i].name, type) == 0)
            return types[i].base;
    }

    return type;
}

void checkAssignment(char *left, char *right)
{
    char *leftType = getVariableType(left);
    char *rightType = getVariableType(right);

    printf("\nAssignment: %s = %s\n", left, right);
    printf("Type of %s = %s\n", left, leftType);
    printf("Type of %s = %s\n", right, rightType);

    if (strcmp(leftType, rightType) == 0)
        printf("Name Equivalence: Equivalent\n");
    else
        printf("Name Equivalence: Not Equivalent\n");

    if (strcmp(getBaseType(leftType), getBaseType(rightType)) == 0)
        printf("Structural Equivalence: Equivalent\n");
    else
        printf("Structural Equivalence: Not Equivalent\n");
}
%}

%union {
    char *str;
}

%token TYPE
%token INT
%token <str> ID

%%

program:
      declarations assignments
      ;

declarations:
      declarations declaration
    | declaration
    ;

declaration:
      TYPE ID '=' INT ';'
      {
          addType($2, "int");
          printf("Type declared: %s = int\n", $2);
      }
    | ID ID ';'
      {
          addVariable($2, $1);
          printf("Variable declared: %s %s\n", $1, $2);
      }
    ;

assignments:
      assignments assignment
    | assignment
    ;

assignment:
      ID '=' ID ';'
      {
          checkAssignment($1, $3);
      }
    ;

%%

int yyerror(char *s)
{
    printf("Syntax error\n");
    return 0;
}

int main()
{
    printf("Enter type and variable declarations:\n");
    yyparse();
    return 0;
}
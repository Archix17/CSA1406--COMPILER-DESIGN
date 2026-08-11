%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Variable
{
    char name[30];
    char type[10];
    float value;
};

struct Variable table[20];
int count = 0;

int yylex(void);
int yyerror(char *s);

void declareVariable(char *type, char *name)
{
    strcpy(table[count].type, type);
    strcpy(table[count].name, name);
    table[count].value = 0;
    count++;

    printf("Declared: %s %s\n", type, name);
}

int findVariable(char *name)
{
    int i;

    for (i = 0; i < count; i++)
    {
        if (strcmp(table[i].name, name) == 0)
            return i;
    }

    return -1;
}

void assignNumber(char *name, float value)
{
    int i = findVariable(name);

    if (i == -1)
    {
        printf("Variable not declared\n");
        return;
    }

    if (strcmp(table[i].type, "int") == 0)
    {
        table[i].value = (int)value;
        printf("Assigned %d to %s\n", (int)value, name);
    }
    else
    {
        table[i].value = value;
        printf("Assigned %.2f to %s\n", value, name);
    }
}

void assignVariable(char *left, char *right)
{
    int l = findVariable(left);
    int r = findVariable(right);

    if (l == -1 || r == -1)
    {
        printf("Variable not declared\n");
        return;
    }

    printf("\nAssignment: %s = %s\n", left, right);

    if (strcmp(table[l].type, table[r].type) == 0)
    {
        table[l].value = table[r].value;
        printf("No type conversion required.\n");
    }
    else if (strcmp(table[l].type, "float") == 0 &&
             strcmp(table[r].type, "int") == 0)
    {
        table[l].value = (float)((int)table[r].value);

        printf("Coercion performed: int -> float\n");
        printf("Converted value = %.2f\n", table[l].value);
    }
    else if (strcmp(table[l].type, "int") == 0 &&
             strcmp(table[r].type, "float") == 0)
    {
        table[l].value = (int)table[r].value;

        printf("Coercion performed: float -> int\n");
        printf("Converted value = %d\n", (int)table[l].value);
    }
}

%}

%union
{
    char *str;
    float num;
}

%token <str> TYPE_INT
%token <str> TYPE_FLOAT
%token <str> ID
%token <num> NUMBER

%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    TYPE_FLOAT ID ';'
    {
        declareVariable($1, $2);
    }

    | TYPE_INT ID ';'
    {
        declareVariable($1, $2);
    }

    | ID '=' NUMBER ';'
    {
        assignNumber($1, $3);
    }

    | ID '=' ID ';'
    {
        assignVariable($1, $3);
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
    printf("Enter declarations and assignments:\n");
    yyparse();

    return 0;
}
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(char *s);
%}

%token NUMBER

%left '+'
%left '*'

%%

input:
      expr '\n'
      {
          printf("Result = %d\n", $1);
      }
      ;

expr:
      expr '+' expr
      {
          $$ = $1 + $3;
      }
    | expr '*' expr
      {
          $$ = $1 * $3;
      }
    | NUMBER
      {
          $$ = $1;
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
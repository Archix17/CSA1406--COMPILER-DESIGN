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
          printf("\nFinal synthesized attribute value = %d\n", $1);
      }
      ;

expr:
      expr '+' expr
      {
          printf("Reduction: expr + expr -> %d + %d = %d\n",
                 $1, $3, $1 + $3);
          $$ = $1 + $3;
      }
    | expr '*' expr
      {
          printf("Reduction: expr * expr -> %d * %d = %d\n",
                 $1, $3, $1 * $3);
          $$ = $1 * $3;
      }
    | NUMBER
      {
          printf("Reduction: NUMBER -> %d\n", $1);
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
%option noyywrap

%{
#include "q3.tab.h"
#include <stdlib.h>
%}

%%

[0-9]+    {
              yylval = atoi(yytext);
              return NUMBER;
          }

[+]       return '+';

[*]       return '*';

[ \t]     ;

\n        return '\n';

.         return yytext[0];

%%
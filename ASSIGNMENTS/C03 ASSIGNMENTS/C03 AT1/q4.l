%option noyywrap

%{
#include "q4.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"type"              return TYPE;
"int"               return INT;

[a-zA-Z][a-zA-Z0-9]* {
    yylval.str = strdup(yytext);
    return ID;
}

"="                 return '=';
";"                 return ';';

[ \t\r\n]+          ;

.                   return yytext[0];

%%
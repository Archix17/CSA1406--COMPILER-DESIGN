%option noyywrap

%{
#include "ast.tab.h"
#include <string.h>
%}

%%

[a-zA-Z][a-zA-Z0-9]* {
    yylval.str = strdup(yytext);
    return ID;
}

[+]       return '+';

[*]       return '*';

[ \t]     ;

\n        return '\n';

.         return yytext[0];

%%
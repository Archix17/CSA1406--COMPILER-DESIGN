%option noyywrap

%{
#include "q5.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

"float" {
    yylval.str = strdup(yytext);
    return TYPE_FLOAT;
}

"int" {
    yylval.str = strdup(yytext);
    return TYPE_INT;
}

[0-9]+(\.[0-9]+)? {
    yylval.num = atof(yytext);
    return NUMBER;
}

[a-zA-Z][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}

"=" {
    return '=';
}

";" {
    return ';';
}

[ \t\r\n]+ {
}

. {
    return yytext[0];
}

%%
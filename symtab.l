%{
#include "y.tab.h"
%}

%%
int     { return INT; }
float   { return FLOAT; }
char    { return CHAR; }
double  { return DOUBLE; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }
[,;]    { return *yytext; }
[ \t\n] ;
.       ;
%%

int yywrap() {
    return 1;
}


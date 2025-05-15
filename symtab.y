%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char name[50];
    char type[10];
} Symbol;

Symbol symtab[100];
int count = 0;

void add_symbol(char *name, char *type) {
    strcpy(symtab[count].name, name);
    strcpy(symtab[count].type, type);
    count++;
}

void print_symbol_table() {
    printf("\n%-20s %-20s\n", "Identifier", "Data Type");
    printf("----------------------------------------\n");
    for (int i = 0; i < count; i++) {
        printf("%-20s %-20s\n", symtab[i].name, symtab[i].type);
    }
}

char current_type[10];

int yylex();
void yyerror(const char *s) {
    printf("Error: %s\n", s);
}
%}

%union {
    char *str;
}

%token <str> ID
%token INT FLOAT CHAR DOUBLE

%%

declarations:
    declarations declaration
    | declaration
    ;

declaration:
    type id_list ';'
    ;

type:
    INT     { strcpy(current_type, "int"); }
    | FLOAT { strcpy(current_type, "float"); }
    | CHAR  { strcpy(current_type, "char"); }
    | DOUBLE { strcpy(current_type, "double"); }
    ;

id_list:
    id_list ',' ID { add_symbol($3, current_type); }
    | ID           { add_symbol($1, current_type); }
    ;

%%

int main() {
    printf("Enter C declarations:\n");
    yyparse();
    print_symbol_table();
    return 0;
}


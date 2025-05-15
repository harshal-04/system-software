**Practical 1
Write a program using LEX specifications to implement lexical analysis phase of compiler to 
generate tokens of subset of ‘C’ program. 

Commands
 > lex file.l
 > cc lex.yy.c
 > ./a.out <input.c

 **Practical 2
 Write a LEX program to display word, character and line counts for a sample input text file 

 Commands
 > lex file.l
 > cc lex.yy.c
 > ./a.out <input.txt


 **Practical 3
Write a program using YACC specifications to implement syntax analysis phase of compiler to 
validate type and syntax of variable declaration in C program.

Commands 

> lex file.l
> yacc -d file.y
> cc lex.yy.c y.tab.c
> ./a.out 

**Practical 4
Write a program using YACC specifications to implement syntax analysis phase of compiler to 
recognize simple and compound sentences given in input file.  

Commands

> lex file.l
> yacc -d file.y
> cc lex.yy.c y.tab.c
> ./a.out

**Practical 5
Write a program to implement recursive descent parser(RDP) for sample language. 

Commands
> gcc rdp.c -o rdp
> ./rdp

**Practical 6
Write a program using YACC specifications to implement calulator to perform various 
arithmetic operations

Commands
> lex file.l
> yacc -d file.y
> cc lex.yy.c y.tab.c
> ./a.out

**Practical 7
Write a program using LEX and YACC to generate a symbol table
                    symboltable.l
                    
                    %{
                        #include "y.tab.h"
                        extern int yylval;
                        %}

                        %%
                        int             { return INT; }
                        float           { return FLOAT; }
                        [a-zA-Z_][a-zA-Z0-9_]*   { yylval = strdup(yytext); return ID; }
                        [ \t\n]+        ; // Ignore whitespaces
                        .               { return yytext[0]; }
                        %%

                    symboltable.y
                    %{
                        #include <stdio.h>
                        #include <stdlib.h>
                        #include <string.h>

                        typedef struct {
                            char name[100];
                            char type[10];
                        } Symbol;

                        Symbol symtab[100];
                        int symcount = 0;

                        void add_symbol(char *name, char *type) {
                            for (int i = 0; i < symcount; i++) {
                                if (strcmp(symtab[i].name, name) == 0)
                                    return; // Already exists
                            }
                            strcpy(symtab[symcount].name, name);
                            strcpy(symtab[symcount].type, type);
                            symcount++;
                        }

                        void display_symbols() {
                            printf("\nSymbol Table:\n");
                            printf("---------------------------\n");
                            printf("| %-10s | %-10s |\n", "Name", "Type");
                            printf("---------------------------\n");
                            for (int i = 0; i < symcount; i++) {
                                printf("| %-10s | %-10s |\n", symtab[i].name, symtab[i].type);
                            }
                            printf("---------------------------\n");
                        }

                        int yylex();
                        void yyerror(char *s) {
                            printf("Error: %s\n", s);
                        }
                        %}

                        %union {
                            char *str;
                        }

                        %token <str> ID
                        %token INT FLOAT
                        %type <str> type

                        %%

                        program:
                            declarations
                            {
                                display_symbols();
                            }
                        ;

                        declarations:
                            declarations declaration
                            | declaration
                        ;

                        declaration:
                            type ID ';'
                            {
                                add_symbol($2, $1);
                            }
                        ;

                        type:
                            INT   { $$ = "int"; }
                            | FLOAT { $$ = "float"; }
                        ;

                        %%

                        int main() {
                            yyparse();
                            return 0;
                        }

                    // Input For program 7

                        int a;
                        float b;
                        int c;



Commands         
> lex symboltable.l
> yacc -d symboltable.y
> cc lex.yy.c y.tab.c
> ./a.out

**Practical 8

Write a program using LEX and YACC to generate Intermediate code in the form of Three 
addresss and Quadruple form for assignment statement

                    intermediate.l
                    %{
                        #include "y.tab.h"
                        extern int yylval;
                        %}

                        %%
                        [a-zA-Z_][a-zA-Z0-9_]*    { yylval = strdup(yytext); return ID; }
                        [0-9]+                    { yylval = strdup(yytext); return NUM; }
                        "="                       { return '='; }
                        "+"                       { return '+'; }
                        "-"                       { return '-'; }
                        "*"                       { return '*'; }
                        "/"                       { return '/'; }
                        ";"                       { return ';'; }
                        [ \t\n]+                  ; // Ignore whitespace
                        .                         { return yytext[0]; }
                        %%

                    intermediate.y
                    %{
                        #include <stdio.h>
                        #include <stdlib.h>
                        #include <string.h>

                        typedef struct {
                            char result[10];
                            char arg1[10];
                            char arg2[10];
                            char op[2];
                        } Quad;

                        Quad quads[100];
                        int quadIndex = 0;
                        int tempVarCount = 0;

                        char* newTemp() {
                            char *temp = malloc(10);
                            sprintf(temp, "t%d", tempVarCount++);
                            return temp;
                        }

                        void insertQuad(char *res, char *arg1, char *arg2, char *op) {
                            strcpy(quads[quadIndex].result, res);
                            strcpy(quads[quadIndex].arg1, arg1);
                            strcpy(quads[quadIndex].arg2, arg2);
                            strcpy(quads[quadIndex].op, op);
                            quadIndex++;
                        }

                        void printIntermediateCode() {
                            printf("\nThree Address Code:\n");
                            for (int i = 0; i < quadIndex; i++) {
                                printf("%s = %s %s %s\n", quads[i].result, quads[i].arg1, quads[i].op, quads[i].arg2);
                            }

                            printf("\nQuadruples:\n");
                            printf("%-10s %-10s %-10s %-10s\n", "Op", "Arg1", "Arg2", "Result");
                            for (int i = 0; i < quadIndex; i++) {
                                printf("%-10s %-10s %-10s %-10s\n", quads[i].op, quads[i].arg1, quads[i].arg2, quads[i].result);
                            }
                        }

                        void yyerror(const char *s) {
                            fprintf(stderr, "Error: %s\n", s);
                        }
                        %}

                        %union {
                            char *str;
                        }

                        %token <str> ID NUM
                        %type <str> expr term factor

                        %%

                        stmt:
                            ID '=' expr ';' {
                                insertQuad($1, $3, "", "=");
                                printIntermediateCode();
                            }
                        ;

                        expr:
                            expr '+' term {
                                char *temp = newTemp();
                                insertQuad(temp, $1, $3, "+");
                                $$ = temp;
                            }
                            | expr '-' term {
                                char *temp = newTemp();
                                insertQuad(temp, $1, $3, "-");
                                $$ = temp;
                            }
                            | term {
                                $$ = $1;
                            }
                        ;

                        term:
                            term '*' factor {
                                char *temp = newTemp();
                                insertQuad(temp, $1, $3, "*");
                                $$ = temp;
                            }
                            | term '/' factor {
                                char *temp = newTemp();
                                insertQuad(temp, $1, $3, "/");
                                $$ = temp;
                            }
                            | factor {
                                $$ = $1;
                            }
                        ;

                        factor:
                            ID { $$ = $1; }
                            | NUM { $$ = $1; }
                        ;

                        %%

                        int main() {
                            yyparse();
                            return 0;
                        }

                        //input For program
                        a = b + c * d;
Commands

lex intermediate.l
yacc -d intermediate.y
gcc lex.yy.c y.tab.c -o intermediate -ll
./intermediate

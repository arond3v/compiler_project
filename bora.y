%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    char temp[3], label[3];
    char stack[100][3];
    int pos = -1;
    
%}
%union {
        long int4;              /* Constant integer value */
        float fp;               /* Constant floating point value */
        char *str;              /* Ptr to constant string (strings are malloc'd) */
    };

%token<str>LET BE WHILE PERFORM MOVETO IF ELSE THEN IS USE STOP YES NO AND OR OF NOT ADD SUB MUL DIV END SEP OPEN_CURLY CLOSE_CURLY UNARY LE GE EQ NE GT LT
%token<str>NUMBER DO
%token<str>ID
%token<str>FLOAT_NUM
%type<str>operation term var condition branch loop
%start start
%%
start       : statement 
statement   : statement expression END
            | expression END {printf("success\n");}
            ;
expression  : variable
            | operation
            | branch expression     {printf("%s:", stack[pos--]);}
            | loop expression       {printf("goto %s\n%s:",stack[pos--], stack[pos--]);}
            ;
variable    : LET ID BE NUMBER      {printf("%s = %s\n", $2, $4);}
            | LET ID BE FLOAT_NUM   {printf("%s = %s\n", $2, $4);}
            | LET ID BE ID          {printf("%s = %s\n", $2, $4);}
            ;
operation   : ADD operation SEP operation   {$$ = temp; temp[1]++; printf("%s = %s + %s\n", temp, $2, $4);}
            | SUB operation SEP operation   {$$ = temp; temp[1]++; printf("%s = %s - %s\n", temp, $2, $4);}
            | term
            ;
term        : MUL term SEP term
            | DIV term SEP term
            | var
            ;
var         :   NUMBER
            |   FLOAT_NUM
            |   ID
            ;
branch      : IF condition THEN  {
                    strcpy(stack[++pos], label);
                    stack[pos][1]++;
                    printf("if (%s) goto %s\ngoto %s\n%s:\n", $2, label,stack[pos],label);
                    label[1]++;
                    label[1]++;
                    }
            ;
loop        : WHILE condition DO {
                    strcpy(stack[++pos], label);
                    stack[pos][1]++;
                    strcpy(stack[pos + 1], stack[pos]);
                    stack[pos][1]++;
                    pos++;
                    printf("%s:\nif (%s) goto %s\ngoto %s\n%s:\n",stack[pos - 1], $2, label,stack[pos],label);
                    label[1]++;
                    label[1]++;
}
condition   :   YES     {$$ = "t10";}
            |   NO      {$$ = "t10";}
            ;


%%

int main() {
    temp[0] = 't';
    temp[1] = '0';
    temp[2] = '\0';
    label[0] = 'L';
    label[1] = '1';
    label[2] = '\0';
    yyparse();
    return 0;
}
int yyerror(const char* message) {
    fprintf(stderr, "Parser error: %s\n", message);
    return 0;
}

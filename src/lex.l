%{
    #include<stdio.h>
    #include "y.tab.h"
    int token_count = 0;
%}

%option yylineno

alpha [a-zA-Z]
digit [0-9]
unary "++"|"--"

%%
[\t]
"while"                     {return WHILE;}
"perform"                   {return PERFORM;}
"moveto"                    {return MOVETO;}
"if"                        {return IF;}
"else"                      {return ELSE;}
"then"                      {return THEN;}
"is"                        {return IS;}
"let"                       {return LET;}
"be"                        {return BE;}
"use"                       {return USE;}
"stop"                      {return STOP;}
"yes"                       {return YES;}
"no"                        {return NO;}
"do"                        {return DO;}
"and"                       {return AND;}
"or"                        {return OR;}
"of"                        {return OF;}
"not"                       {return NOT;}
"add"                       {return ADD;}
"subtract"                  {return SUB;}
"multiply"                  {return MUL;}
"divide"                    {return DIV;}
"."                         {return END;}
","                         {return SEP;}
"{"                         {return OPEN_CURLY;}
"}"                         {return CLOSE_CURLY;}
{digit}+                    {yylval.str = strdup(yytext); return NUMBER; }
{digit}+\.{digit}{1,6}      {yylval.str = strdup(yytext);return FLOAT_NUM; }
[a-zA-Z][a-zA-Z0-9]*        {yylval.str = strdup(yytext);return ID; }
{unary}                     {return UNARY; }
"<="                        {return LE; }
">="                        {return GE; }
"=="                        {return EQ; }
"!="                        {return NE; }
">"	                        {return GT; }
"<"	                        {return LT; } 
%%

int yywrap(void){
    return 1;
}

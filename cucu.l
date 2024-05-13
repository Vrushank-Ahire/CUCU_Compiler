%{
#include "y.tab.h"
#include <stdlib.h>
void yyerror(char *);
FILE *lexout;
%}

%%

"int" { fprintf(lexout, "Data Type: \t \t \t int\n"); return INT_TYPE; }
"char *" { fprintf(lexout, "Data Type: \t \t \t char\n"); return CHAR_TYPE; }
"while" { fprintf(lexout, "Control Statement: \t While\n"); return WHILE_STMT; }
"if" { fprintf(lexout, "Control Statement: \t If\n"); return IF_STMT; }
"else" { fprintf(lexout, "Control Statement: \t Else\n"); return ELSE_STMT; }
"return" { fprintf(lexout, "RETURN STATEMENT.\n"); return RETURN_STMT; }
"==" { fprintf(lexout, "Compare: \t \t \t \t ==\n"); return COMPARE_OP; }
"=" { fprintf(lexout, "Assign: \t \t \t \t =\n"); return ASSIGN_OP; }
"/*" { fprintf(lexout, "Open Comments\n"); return OPEN_COMMENT; }
"*/" { fprintf(lexout, "Close Comments\n"); return CLOSE_COMMENT; }
[A-Za-z][A-Za-z0-9_]* { fprintf(lexout, "Identifier: \t \t \t %s\n", yytext); yylval.str_value = strdup(yytext); return IDENTIFIER; }
[0-9_][A-Za-z]+ { fprintf(lexout, "Identifier: \t \t \t %s\n", yytext); yylval.str_value = strdup(yytext); return VAR_IDENTIFIER; }
"+" { fprintf(lexout, "Plus: \t \t \t \t \t +\n"); return PLUS_OP; }
"-" { fprintf(lexout, "Minus: \t \t \t \t -\n"); return MINUS_OP; }
"*" { fprintf(lexout, "Multiply: \t \t \t \t *\n"); return MULTIPLY_OP; }
"/" { fprintf(lexout, "Divide: \t \t \t \t /\n"); return DIVIDE_OP; }
"!=" { fprintf(lexout, "Logical: \t \t \t !=\n"); return NOT_EQUAL_OP; }
\( { fprintf(lexout, "Parenthesis: \t \t \t Open\n"); return OPEN_PAREN; }
\) { fprintf(lexout, "Parenthesis: \t \t \t Close\n"); return CLOSE_PAREN; }
[0-9]+ { fprintf(lexout, "Number: \t \t \t \t %s\n", yytext); yylval.int_value = atoi(yytext); return NUMBER; }
"{" { fprintf(lexout, "Open Curly Parenthesis: {\n"); return OPEN_BRACE; }
"}" { fprintf(lexout, "Closed Curly Parenthesis: }\n"); return CLOSE_BRACE; }
";" { fprintf(lexout, "Semicolon\n"); return SEMICOLON; }
"," { return COMMA; }
[\n] ;
.   ;
%%

int yywrap(void) { return 1; }
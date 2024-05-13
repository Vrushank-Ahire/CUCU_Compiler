%{
#include <stdio.h>
#include<stdlib.h>
#include <string.h>
#include <math.h>
int yylex();
void yyerror(char const *);
extern FILE *yyin, *yyout, *lexout;

struct Node {
    char* value;
    struct Node* next;
};

struct Node* create_node(char* value) {
    struct Node* new_node = (struct Node*)malloc(sizeof(struct Node));
    new_node->value = strdup(value);
    new_node->next = NULL;
    return new_node;
}

void insert_node(struct Node** head, char* value) {
    struct Node* new_node = create_node(value);
    new_node->next = *head;
    *head = new_node;
}

struct Node* find_node(struct Node* head, char* target) {
    struct Node* current = head;
    while (current != NULL) {
        if (strcmp(current->value, target) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

struct Node* head_ref;
%}

%token INT_TYPE CHAR_TYPE WHILE_STMT IF_STMT ELSE_STMT COMPARE_OP ASSIGN_OP NOT_EQUAL_OP OPEN_PAREN CLOSE_PAREN OPEN_BRACE CLOSE_BRACE SEMICOLON COMMA RETURN_STMT OPEN_COMMENT CLOSE_COMMENT

%union {
    int int_value;
    char* str_value;
    char* str_val;
    int int_val;
}

%token <str_val> IDENTIFIER VAR_IDENTIFIER
%token <int_val> NUMBER

%left PLUS_OP MINUS_OP
%left MULTIPLY_OP DIVIDE_OP
%left OPEN_PAREN
%left CLOSE_PAREN
%left CLOSE_BRACE
%left OPEN_BRACE

%%
programs : declaration
         | function_declaration
         | programs function_declaration
         | programs declaration
         | function_call
         | if_statement
         | programs if_statement
         | programs function_call
         | assignment
         | comment
         | programs comment
         | programs assignment
;

comment : OPEN_COMMENT element CLOSE_COMMENT { fprintf(yyout, "The comment has finished\n\n"); }
;

element : statements { fprintf(yyout, "This has been commented\n"); }
;

declaration : id id SEMICOLON { fprintf(yyout, "An error is present. Illegal data type\n"); }
            | id id assign_op expr SEMICOLON { fprintf(yyout, "An error is present. Illegal data type\n"); }
            | id SEMICOLON { fprintf(yyout, "An error is present. Illegal declaration without data type\n"); }
            | int_type var_id SEMICOLON { fprintf(yyout, "An integer variable has been declared\n"); }
            | char_type var_id SEMICOLON { fprintf(yyout, "A character variable has been declared\n"); }
            | int_type var_id assign_op expr SEMICOLON { fprintf(yyout, "An assignment statement has been declared\n"); }
            | char_type var_id assign_op expr SEMICOLON { fprintf(yyout, "An assignment statement has been declared\n"); }
;

var_id : IDENTIFIER { fprintf(yyout, "A Variable has been declared %s\n", $1);
                      if (find_node(head_ref, $1) == NULL) {
                          insert_node(&head_ref, $1);
                      } else {
                          fprintf(yyout, "\nAN ERROR HAS OCCURRED: VARIABLE REDECLARATION\n");
                      }
                    }
;

function_declaration : id id3 OPEN_PAREN args CLOSE_PAREN next { fprintf(yyout, "\nAn error is present. Illegal data type declaration"); }
                     | int_type id3 args CLOSE_PAREN next { fprintf(yyout, "\nExpected an open parenthesis before the arguments"); }
                     | int_type id3 OPEN_PAREN args next { fprintf(yyout, "\nExpected a close parenthesis after the arguments"); }
                     | int_type id3 OPEN_PAREN args CLOSE_PAREN next
                     | int_type id3 OPEN_PAREN CLOSE_PAREN next
                     | char_type id3 OPEN_PAREN CLOSE_PAREN next
                     | char_type id3 OPEN_PAREN args CLOSE_PAREN next
;

id3 : IDENTIFIER { fprintf(yyout, "Function name %s\n", $1); }
    | VAR_IDENTIFIER { fprintf(yyout, "\nAn error has occurred. Illegal variable declaration\n"); }
;

next : SEMICOLON
     | function_body
;

function_body : OPEN_BRACE statements CLOSE_BRACE
;

statements : statements statement
           | statement
;

statement : assignment
          | function_call
          | return_statement
          | if_statement
          | while_loop
          | declaration
          | function_declaration
;

while_loop : WHILE_STMT OPEN_PAREN logic CLOSE_PAREN function_body { fprintf(yyout, "A while loop has been defined\n"); }

return_statement : RETURN_STMT SEMICOLON
            | RETURN_STMT number SEMICOLON

function_call : id4 OPEN_PAREN parameters CLOSE_PAREN SEMICOLON
;

if_statement : IF_STMT OPEN_PAREN logic CLOSE_PAREN function_body { fprintf(yyout, "A conditional if has been defined"); }
;

logic : expr COMPARE_OP expr { fprintf(yyout, "Logical statement is completed\n"); }
      | expr NOT_EQUAL_OP expr
;

id4 : IDENTIFIER { fprintf(yyout, "Function %s has been called\n", $1); }
    | VAR_IDENTIFIER { fprintf(yyout, "An error has occurred. Illegal variable declaration\n"); }
;

parameters : expr
           | expr COMMA parameters
;

assignment : expr assign_op expr SEMICOLON
;

args : int_type var_id2
     | int_type var_id2 COMMA args
     | char_type var_id2
     | char_type var_id2 COMMA args
;

var_id2 : IDENTIFIER { fprintf(yyout, "Function argument: %s\n", $1); }
       | VAR_IDENTIFIER { fprintf(yyout, "An error has occurred. Illegal variable declaration\n"); }
;

int_type : INT_TYPE
;

char_type : CHAR_TYPE
;

id : IDENTIFIER { fprintf(yyout, "local_variable: %s\n", $1); }
   | VAR_IDENTIFIER { fprintf(yyout, "An error has occurred. Illegal variable declaration\n"); }
;

assign_op : ASSIGN_OP { fprintf(yyout, "assign: =\n"); }
;

expr : expr PLUS_OP term { fprintf(yyout, "Operator: +\n"); }
     | expr MINUS_OP term { fprintf(yyout, "Operator: -\n"); }
     | term
;

term : term MULTIPLY_OP factor { fprintf(yyout, "Operator: *\n"); }
     | term DIVIDE_OP factor { fprintf(yyout, "Operator: /\n"); }
     | factor
;

factor : OPEN_PAREN expr CLOSE_PAREN
       | id
       | number
       | SEMICOLON
;

number : NUMBER { fprintf(yyout, "Constant: %d\n", $1); }
;

%%

void yyerror(char const *str) {
    fprintf(stderr, "Error: %s\n", str);
}

int main(int argc, char *argv[]) {
    head_ref = NULL;
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Error opening input file");
        return 1;
    }
    yyout = fopen("parser.txt", "w");
    lexout = fopen("lexer.txt", "w");
    yyparse();
    fclose(yyin);
    fclose(yyout);
    fclose(lexout);
    return 0;
}
%{
	#include <stdio.h>

	int yylex(void);
	void yyerror (char const *s){
		fprintf(stderr, "%s\n");
	}
%}

/* Tokens definition */
%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_CHAR
%token TK_PR_STRING
%token TK_PR_IF
%token TK_PR_THEN
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_DO
%token TK_PR_INPUT
%token TK_PR_OUTPUT
%token TK_PR_RETURN
%token TK_PR_CONST
%token TK_PR_STATIC
%token TK_PR_FOREACH
%token TK_PR_FOR
%token TK_PR_SWITCH
%token TK_PR_CASE
%token TK_PR_BREAK
%token TK_PR_CONTINUE
%token TK_PR_CLASS
%token TK_PR_PRIVATE
%token TK_PR_PUBLIC
%token TK_PR_PROTECTED
%token TK_PR_END
%token TK_PR_DEFAULT
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_OC_SL
%token TK_OC_SR
%token TK_OC_FORWARD_PIPE
%token TK_OC_BASH_PIPE
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_LIT_CHAR
%token TK_LIT_STRING
%token TK_IDENTIFICADOR
%token TOKEN_ERRO

/* Operators precedence */
%left '+' '-'
%right '?'
%left ':'
/*%right '^' '='*/

/* Detailed error message */
%define parse.error verbose

%%

/*programa:*/
/*expression: '(' expression ')' |*/

/* Unary operators */
/*'+' expression |
'-' expression |
'!' expression |
'&' expression |
'*' expression |
'?' expression |
'#' expression |*/

/* Binary operators */
/*expression '+' expression |
expression '-' expression |
expression '*' expression |
expression '/' expression |
expression '%' expression |
expression '|' expression |
expression '&' expression |
expression '^' expression |
expression '<' expression |
expression '>' expression |
expression TK_OC_LE expression |
expression TK_OC_EQ expression |
expression TK_OC_GE expression |
expression TK_OC_NE expression |
expression TK_OC_AND expression |
expression TK_OC_OR expression |
expression TK_OC_SL expression |
expression TK_OC_SR expression |*/

/* Ternary */
expression: expression '?' expression ':' expression |

/* Arithmetic end-terms */
TK_LIT_INT | TK_LIT_FLOAT | 

/* Logic end-terms */
TK_LIT_TRUE | TK_LIT_FALSE;


%%
%{
	#include <stdio.h>

	extern int get_line_number(void);

	int yylex(void);

	void yyerror (char const *str){
		fprintf(stderr, "%s on line %d\n", str, get_line_number());
	}
%}

%code requires {
	#include "misc.h"
	#include "tree.h"
}

/* yylval type */
%union {
	ValorLexico valor_lexico;
	Tree* Tree;
}

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

/* Define types for semantic actions */
%type <valor_lexico> TK_LIT_TRUE
%type <valor_lexico> TK_LIT_FALSE
%type <valor_lexico> TK_LIT_INT
%type <valor_lexico> TK_LIT_FLOAT
%type <valor_lexico> TK_LIT_STRING
%type <valor_lexico> TK_LIT_CHAR
%type <valor_lexico> TK_IDENTIFICADOR
%type <Tree> expression
%type <Tree> function_call

/* Operators precedence */

%left TK_OC_SR TK_OC_SL
%left TK_OC_LE TK_OC_GE '>' '<'TK_OC_EQ TK_OC_NE
%left TK_OC_AND TK_OC_OR
%left '&' '|'
%right '!'
%left '+' '-'
%left '*' '/' '%' 
%left '(' ')'
%left '[' ']'
%right '^'
%right '?' ':' 
%right '#'
%right '='

/* Different associativity based in whether it's a binary or unary op */
%right UMINUS
%right UPLUS
%right UADDRESS
%right UPOINTER

/* Detailed error message */
%define parse.error verbose

%start program
%%

program: program function |
program global_var |
/* Empty */;

/* Global variables */
global_var: global_var_types ';' | 
TK_PR_STATIC global_var_types ';';

global_var_types: type TK_IDENTIFICADOR | type TK_IDENTIFICADOR '[' TK_LIT_INT ']' |
type TK_IDENTIFICADOR '[' '+' TK_LIT_INT ']';

/* Function definition */
function: header command_block;
header: type TK_IDENTIFICADOR '(' list_params ')' |
TK_PR_STATIC type TK_IDENTIFICADOR '(' list_params ')';

/* List of function parameters */
list_params: list_params ',' param | param | /* Empty */;
param: type TK_IDENTIFICADOR | TK_PR_CONST type TK_IDENTIFICADOR;

/* Simple commands */
simple_command: commands ';';

commands: var_declaration | attribution | input | output |
function_call | return | break | continue | command_block |
shifts | while | for | ifelse ;

/* Command block */
command_block: '{' command_list '}';
command_list: command_list simple_command | /* Empty */;

/* Shifts op */
shifts: TK_IDENTIFICADOR TK_OC_SL expression |
TK_IDENTIFICADOR TK_OC_SR expression |
TK_IDENTIFICADOR '[' expression ']' TK_OC_SL expression |
TK_IDENTIFICADOR '[' expression ']' TK_OC_SR expression;

/* Flow control */
while: TK_PR_WHILE '(' expression ')' TK_PR_DO command_block;
for: TK_PR_FOR '(' list_for ':' expression ':' list_for ')' command_block;
ifelse: TK_PR_IF '(' expression ')' command_block |
TK_PR_IF '(' expression ')' command_block TK_PR_ELSE command_block;

/* List of possible for commands */
list_for: list_for  ',' commands_for  | commands_for ;
commands_for: var_declaration | attribution | input | return |
break | continue | expression | shifts; 

/* Variable declaration */
var_declaration: var_params type TK_IDENTIFICADOR |
var_params type TK_IDENTIFICADOR TK_OC_LE initializations;

/* Possible variable initializations */
initializations: TK_IDENTIFICADOR | literals;

/* Literals */
literals: TK_LIT_TRUE | TK_LIT_FALSE |
TK_LIT_INT | TK_LIT_FLOAT |
TK_LIT_STRING | TK_LIT_CHAR;

/* Variable types */
type: TK_PR_INT | TK_PR_FLOAT | TK_PR_CHAR | TK_PR_BOOL | TK_PR_STRING;

/* Variable parameters */
var_params: TK_PR_STATIC | TK_PR_CONST | TK_PR_STATIC TK_PR_CONST | /* Empty */;

/* Attribution */
attribution: TK_IDENTIFICADOR '=' expression |
TK_IDENTIFICADOR '[' expression ']' '=' expression;

/* IO commands */
input: TK_PR_INPUT expression;
output: TK_PR_OUTPUT non_void_list;

/* Non-void list */
non_void_list: list ',' expression | expression;

/* Function call */
function_call: TK_IDENTIFICADOR '(' list ')';

/* List */
list: list ',' expression | expression | /* Empty */;

/* Control commands */
return: TK_PR_RETURN expression;
break: TK_PR_BREAK;
continue: TK_PR_CONTINUE;

/* Arithmetic and logical expressions */
expression: '(' expression ')' {$$ = $2;} |

/* Unary operators */
'+' expression %prec UPLUS {$$ = unary_node(PLUS_SIGN, $2);} |
'-' expression %prec UMINUS {$$ = unary_node(SIGN_INVERSION, $2);} |
'!' expression {$$ = unary_node(LOGICAL_NOT, $2);} |
'&' expression %prec UADDRESS {$$ = unary_node(ADDRESS, $2);} |
'*' expression %prec UPOINTER {$$ = unary_node(POINTER, $2);} |
'?' expression {$$ = unary_node(QUESTION_MARK, $2);} |
'#' expression {$$ = unary_node(HASHTAG, $2);} |

/* Binary operators */
expression '+' expression {$$ = binary_node(PLUS, $1, $3);} |
expression '-' expression {$$ = binary_node(MINUS, $1, $3);} |
expression '*' expression {$$ = binary_node(MULTIPLICATION, $1, $3);} |
expression '/' expression {$$ = binary_node(DIVISION, $1, $3);} |
expression '%' expression {$$ = binary_node(MOD, $1, $3);} |
expression '|' expression {$$ = binary_node(BITWISE_OR, $1, $3);} |
expression '&' expression {$$ = binary_node(BITWISE_AND, $1, $3);} |
expression '^' expression {$$ = binary_node(EXPONENT, $1, $3);} |
expression '<' expression {$$ = binary_node(LESSER, $1, $3);} |
expression '>' expression {$$ = binary_node(GREATER, $1, $3);} | 
expression TK_OC_LE expression {$$ = binary_node(LESS_OR_EQUAL, $1, $3);} |
expression TK_OC_EQ expression {$$ = binary_node(EQUAL, $1, $3);} |
expression TK_OC_GE expression {$$ = binary_node(GREATER_OR_EQUAL, $1, $3);} |
expression TK_OC_NE expression {$$ = binary_node(NOT_EQUAL, $1, $3);} |
expression TK_OC_AND expression {$$ = binary_node(LOGICAL_AND, $1, $3);} |
expression TK_OC_OR expression {$$ = binary_node(LOGICAL_OR, $1, $3);} |

/* Ternary */
expression '?' expression ':' expression {$$ = ternary_node(TERNARY, $1, $3, $5);} |

/* Vector */
TK_IDENTIFICADOR '[' expression ']' {
	Tree* identifier_node = make_node(IDENTIFIER, $1);
	$$ = binary_node(ARRAY, identifier_node, $3);} |

/* Function */
function_call {$$ = $1;} |

/* Arithmetic end-terms */
TK_LIT_INT {$$ = make_node(LITERAL, $1);} |
TK_LIT_FLOAT {$$ = make_node(LITERAL, $1);} | 

/* Logic end-terms */
TK_LIT_TRUE {$$ = make_node(LITERAL, $1);} | 
TK_LIT_FALSE {$$ = make_node(LITERAL, $1);} |

/* Identifier end-term*/
TK_IDENTIFICADOR {$$ = make_node(IDENTIFIER, $1);};

%%

%{
	#include <stdio.h>

	extern int get_line_number(void);
	int yylex(void);
	void yyerror (char const *str){
		fprintf(stderr, "%s on line %d\n", str, get_line_number());
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
%left '(' ')' '[' ']'
%left '+' '-'
%left '*' '/' '%'
%left TK_OC_SR TK_OC_SL
%left TK_OC_LE TK_OC_GE '>' '<'
%left TK_OC_EQ TK_OC_NE
%left TK_OC_AND TK_OC_OR
%left '&' '|'
%right '^'
%right '?' ':' 
%right '#' '!'
%right '='

/* Different associativity based in whether it's a binary or unary op */
%left UMINUS
%left UPLUS
%left UADRESS
%left UPOINTER

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
simple_command: commands ';' | while | for | ifelse;

commands: var_declaration | attribution | input | output |
function_call | return | break | continue | command_block |
shifts;

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
expression: '(' expression ')' |

/* Unary operators */
'+' expression %prec UPLUS |
'-' expression %prec UMINUS |
'!' expression |
'&' expression %prec UADRESS |
'*' expression %prec UPOINTER |
'?' expression |
'#' expression |

/* Binary operators */
expression '+' expression |
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

/* Ternary */
expression '?' expression ':' expression |

/* Vector */
TK_IDENTIFICADOR '[' expression ']' |

/* Function */
function_call |

/* Arithmetic end-terms */
TK_LIT_INT | TK_LIT_FLOAT | 

/* Logic end-terms */
TK_LIT_TRUE | TK_LIT_FALSE|

/* Identifier end-term*/
TK_IDENTIFICADOR;

%%
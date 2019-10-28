%{
	#include <stdio.h>

	extern int get_line_number(void);
	extern void *arvore;

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
%type <Tree> program body
%type <Tree> expression literals shifts
%type <Tree> function_call simple_command header function function_body
%type <Tree> break continue return
%type <Tree> attribution initializations var_init
%type <Tree> list commands_for command_block list_for command_list commands
%type <Tree> ifelse while for command_body

/* Operators precedence */

%right '='
%right '?' ':' 
%left TK_OC_AND TK_OC_OR
%left TK_OC_LE TK_OC_GE '>' '<'TK_OC_EQ TK_OC_NE
%left '&' '|'
%left TK_OC_SR TK_OC_SL
%right '!'
%left '+' '-'
%left '*' '/' '%' 
%left '(' ')'
%left '[' ']'
%right '^'
%right '#'


/* Different associativity based in whether it's a binary or unary op */
%right UMINUS
%right UPLUS
%right UADDRESS
%right UPOINTER

/* Detailed error message */
%define parse.error verbose

%start program
%%

program: body {
	arvore = $$;
};

body: function body {
	$$ = $1;
	insert_child($1,$2);
}|
global_var body {$$ = $2;} /* Because global_var can't be initialized */|
{$$ = NULL;}/* Empty */;

/* Global variables */
global_var: global_var_types ';' | 
TK_PR_STATIC global_var_types ';';

global_var_types: type TK_IDENTIFICADOR {free($2.token_val.str);}|
type TK_IDENTIFICADOR '[' TK_LIT_INT ']' {free($2.token_val.str); free($4.token_val.str);}|
type TK_IDENTIFICADOR '[' '+' TK_LIT_INT ']' {free($2.token_val.str);free($5.token_val.str);};

/* Function definition */
function: header function_body {
	insert_child($1,$2);
	$$ = $1;
};
header: type TK_IDENTIFICADOR '(' list_params ')' {$$ = make_node(IDENTIFIER, $2);}|
TK_PR_STATIC type TK_IDENTIFICADOR '(' list_params ')' {$$ = make_node(IDENTIFIER, $3);};

/* List of function parameters */
list_params: list_params ',' param | param | /* Empty */;
param: type TK_IDENTIFICADOR {free($2.token_val.str);}|
TK_PR_CONST type TK_IDENTIFICADOR {free($3.token_val.str);};

/* Simple commands */
simple_command: commands ';' {$$ = $1;};

commands: var_declaration {$$ = NULL;} | var_init {$$ = $1;} | attribution {$$ = $1;} 
| input {$$ = NULL;} | output {$$ = NULL;} | function_call {$$ = $1;} |
return {$$ = $1;} | break {$$ = $1;} | continue {$$ = $1;} | command_block {$$ = $1;} |
shifts {$$ = $1;} | while {$$ = $1;} | for {$$ = $1;} | ifelse {$$ = $1;} ;

/* Command block */
command_block: '{' command_list '}' {
	ValorLexico dummy;
	$$ = make_node(EMPTY_BLOCK, dummy);
	insert_child($$, $2);
};

/* Function body */
function_body: '{' command_list '}' { $$ = $2; };

/* Command body */
command_body: '{' command_list '}' {
	if($2 == NULL){
		ValorLexico dummy;
		$$ = make_node(EMPTY_BLOCK, dummy);
	} else {
		$$ = $2;
	}
}

/* List of commands */
command_list: simple_command command_list {
	if($1 == NULL) {
		$$ = $2;
	} else {
		$$ = $1;
		insert_child($1,$2);
	}
} | /* Empty */ {$$=NULL;} ;

/* Shifts op */
shifts: TK_IDENTIFICADOR TK_OC_SL expression {
	Tree* id = make_node(IDENTIFIER, $1);
	$$ = binary_node(SHIFT_LEFT, id, $3);
} |
TK_IDENTIFICADOR TK_OC_SR expression {
	Tree* id = make_node(IDENTIFIER, $1);
	$$ = binary_node(SHIFT_LEFT, id, $3);
}  |
TK_IDENTIFICADOR '[' expression ']' TK_OC_SL expression {
	Tree* id = make_node(IDENTIFIER, $1);
	Tree *array = binary_node(ARRAY, id, $3);
	$$ = binary_node(SHIFT_LEFT, array, $6);
} |
TK_IDENTIFICADOR '[' expression ']' TK_OC_SR expression {
	Tree* id = make_node(IDENTIFIER, $1);
	Tree *array = binary_node(ARRAY, id, $3);
	$$ = binary_node(SHIFT_RIGHT, array, $6);
};

/* Flow control */
while: TK_PR_WHILE '(' expression ')' TK_PR_DO command_body {
	$$ = binary_node(WHILE, $3, $6);
};

for: TK_PR_FOR '(' list_for ':' expression ':' list_for ')' command_body {
	$$ = quartenary_node(FOR, $3, $5, $7, $9);
};

ifelse: TK_PR_IF '(' expression ')' command_body {
	$$ = binary_node(IF, $3, $5);
} |
TK_PR_IF '(' expression ')' command_block TK_PR_ELSE command_body {
	$$ = ternary_node(IF_ELSE, $3, $5, $7);
};

/* List of possible for commands */
list_for: commands_for  ','  list_for {
	if($1 == NULL) {
		$$ = $3;
	} else {
		$$ = $1;
		insert_child($1,$3);
	}
}|
commands_for {$$ = $1;} ;

commands_for: var_declaration {$$ = NULL;} |
var_init {$$ = $1;} |
attribution {$$ = $1;} |
input {$$ = NULL;}|
return {$$ = $1;}|
break {$$ = $1;}|
continue {$$ = $1;}|
expression {$$ = $1;}|
shifts {$$ = $1;}; 

/* Variable declaration */
var_declaration: var_params type TK_IDENTIFICADOR {free($3.token_val.str);};
var_init: var_params type TK_IDENTIFICADOR TK_OC_LE initializations {
	Tree* id = make_node(IDENTIFIER, $3);
	$$ = binary_node(ASSIGNMENT, id, $5);
};

/* Possible variable initializations */
initializations: TK_IDENTIFICADOR {$$ = make_node(IDENTIFIER, $1);} |
literals {$$ = $1;} ;

/* Literals */
literals: TK_LIT_TRUE {$$ = make_node(LITERAL, $1);} |
TK_LIT_FALSE {$$ = make_node(LITERAL, $1);} |
TK_LIT_INT {$$ = make_node(LITERAL, $1);} |
TK_LIT_FLOAT {$$ = make_node(LITERAL, $1);} |
TK_LIT_STRING {$$ = make_node(LITERAL, $1);} |
TK_LIT_CHAR {$$ = make_node(LITERAL, $1);} ;

/* Variable types */
type: TK_PR_INT | TK_PR_FLOAT | TK_PR_CHAR | TK_PR_BOOL | TK_PR_STRING;

/* Variable parameters */
var_params: TK_PR_STATIC | TK_PR_CONST | TK_PR_STATIC TK_PR_CONST | /* Empty */;

/* Attribution */
attribution: TK_IDENTIFICADOR '=' expression {
	Tree* id = make_node(IDENTIFIER, $1);
	$$ = binary_node(ASSIGNMENT, id, $3);
} |
TK_IDENTIFICADOR '[' expression ']' '=' expression {
	Tree* id = make_node(IDENTIFIER, $1);
	Tree *array = binary_node(ARRAY, id, $3);
	$$ = binary_node(ASSIGNMENT, array, $6);
} ;

/* IO commands */
input: TK_PR_INPUT expression {free_tree($2);};
output: TK_PR_OUTPUT non_void_list;

/* Non-void list */
non_void_list: list ',' expression {free_tree($3); free_tree($1);}|
expression {free_tree($1);};

/* Function call */
function_call: TK_IDENTIFICADOR '(' list ')' {
	$$ = make_node(FUNCTION_CALL, $1);
	insert_child($$,$3);
};

/* List */
list: list ',' expression {$$ = $3; insert_child($$, $1);} |
expression {$$ = $1;}  |
{$$ = NULL;} /* Empty */;

/* Control commands */
return: TK_PR_RETURN expression {$$ = unary_node(RETURN, $2);} ;
break: TK_PR_BREAK {ValorLexico dummy; $$ = make_node(BREAK, dummy);} ;
continue: TK_PR_CONTINUE {ValorLexico dummy; $$ = make_node(CONTINUE, dummy);} ;

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
literals { $$ = $1; } |

/* Identifier end-term*/
TK_IDENTIFICADOR {$$ = make_node(IDENTIFIER, $1);};

%%

%{
	#include <stdlib.h>
	#include "parser.tab.h"

	int lineNumber = 1;
	int comment_found;

	int get_line_number(void){
		return lineNumber;
	}
%}

%x comment

digit 		[0-9]
letter 		[A-Za-z]
letter_ 	{letter}|[_]
delim 		[ \t\r]
signal		[+-]
sp_char		[,;:()\[\]{}\+\-|?\*@/<>=!&%#^.$~`]
ws 			{delim}+
id 			{letter_}({letter_}|{digit})*
integer		{digit}+
real		{integer}(\.{digit}+)?((E|e){integer})?
character	\'[^\n']?\'
str			\"(\\.|[^\\\n"])*\"
line_comm	"//".*
non_id		({integer}|{real}){id}+
dup_char	\'[^\n'][^\n']+\'

%%
"/*"		{
				comment_found = INITIAL;
				BEGIN(comment);
			}
			<comment>[^*\n]*
			<comment>"*"+[^*/\n]*
			<comment>\n 			lineNumber++;
			<comment>"*"+"/"		BEGIN(comment_found);
{line_comm}	{/* DO NOTHING */}
"int"		{return TK_PR_INT;}
"float"		{return TK_PR_FLOAT;}
"bool"		{return TK_PR_BOOL;}
"char"		{return TK_PR_CHAR;}
"string"	{return TK_PR_STRING;}
"if"		{return TK_PR_IF;}
"then"		{return TK_PR_THEN;}
"else"		{return TK_PR_ELSE;}
"while"		{return TK_PR_WHILE;}
"do"		{return TK_PR_DO;}
"input"		{return TK_PR_INPUT;}
"output"	{return TK_PR_OUTPUT;}
"return"	{return TK_PR_RETURN;}
"const"		{return TK_PR_CONST;}
"static"	{return TK_PR_STATIC;}
"foreach"	{return TK_PR_FOREACH;}
"for"		{return TK_PR_FOR;}
"switch"	{return TK_PR_SWITCH;}
"case"		{return TK_PR_CASE;}
"break"		{return TK_PR_BREAK;}
"continue"	{return TK_PR_CONTINUE;}
"class"		{return TK_PR_CLASS;}
"private"	{return TK_PR_PRIVATE;}
"public"	{return TK_PR_PUBLIC;}
"protected"	{return TK_PR_PROTECTED;}
"end"		{return TK_PR_END;}
"default"	{return TK_PR_DEFAULT;}
"<="		{return TK_OC_LE;}
">="		{return TK_OC_GE;}
"=="		{return TK_OC_EQ;}
"!="		{return TK_OC_NE;}
"&&"		{return TK_OC_AND;}
"||"		{return TK_OC_OR;}
">>"		{return TK_OC_SR;}
"<<"		{return TK_OC_SL;}
"%>%"		{return TK_OC_FORWARD_PIPE;}
"%|%"		{return TK_OC_BASH_PIPE;}
"true"		{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Literal;
	yylval.valor_lexico.token_val.literal_type = LiteralBool;
	yylval.valor_lexico.token_val.int_value = 1;
	yylval.valor_lexico.token_val.str = strdup(yytext);
	return TK_LIT_TRUE;
}
"false"		{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Literal;
	yylval.valor_lexico.token_val.literal_type = LiteralBool;
	yylval.valor_lexico.token_val.int_value = 1;
	yylval.valor_lexico.token_val.str = strdup(yytext);
	return TK_LIT_FALSE;
}
{sp_char}	{return yytext[0];}
{id}		{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Identifier;
	yylval.valor_lexico.token_val.str = strdup(yytext);
	return TK_IDENTIFICADOR;
}

{integer}	{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Literal;
	yylval.valor_lexico.token_val.literal_type = LiteralInt;
	yylval.valor_lexico.token_val.int_value = atoi(yytext);
	yylval.valor_lexico.token_val.str = strdup(yytext);
	return TK_LIT_INT;
}

{real}		{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Literal;
	yylval.valor_lexico.token_val.literal_type = LiteralFloat;
	yylval.valor_lexico.token_val.float_value = atof(yytext);
	yylval.valor_lexico.token_val.str = strdup(yytext);
	return TK_LIT_FLOAT;
}

{character}	{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Literal;
	yylval.valor_lexico.token_val.literal_type = LiteralChar;
	yylval.valor_lexico.token_val.str = remove_quotes(yytext);
	return TK_LIT_CHAR;
}

{str}		{
	yylval.valor_lexico.line_number = lineNumber;
	yylval.valor_lexico.token_type = Literal;
	yylval.valor_lexico.token_val.literal_type = LiteralString;
	yylval.valor_lexico.token_val.str = remove_quotes(yytext);
	return TK_LIT_STRING;
}
{ws}		{/* DO NOTHING */}
[\n]		{lineNumber++;}
{non_id}	{return TOKEN_ERRO;}
{dup_char}	{return TOKEN_ERRO;}
.			{return TOKEN_ERRO;}

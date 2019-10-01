#include "misc.h"

/* Removes double quotes from strings and single quotes from chars */
char* remove_quotes(char *str_base){
	char *lexeme = strdup(str_base); /* Just to avoid doing malloc */
	int init_length = strlen(str_base);

	memmove(lexeme, str_base+1, init_length-1);
	lexeme[init_length-2] = '\0';

	return lexeme;
}
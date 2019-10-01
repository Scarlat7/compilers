#include <string.h>
#include <stdio.h>
#include "enum.h"

typedef struct VALOR_LEXICO {
	int line_number;		/* Line in which this token appears */
	TokenType token_type;	/* This token's type (defined in enum.h) */
	struct TOKEN_VALUE {	/* Token's value */
		LiteralType literal_type;	/* char, str, bool, int or float (defined in enum.h) */
		union {
			int int_value;	/* Also serves for bool value false = 0, true otherwise */
			float float_value;
		};
		char *str;			/* The token's value is by default the lexeme */
	} token_val;
} ValorLexico;

char* remove_quotes(char *str_base);
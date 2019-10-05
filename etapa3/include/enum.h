/* Enumerations for data types */

#ifndef ENUM_H
#define ENUM_H

typedef enum { 
	LiteralChar,
	LiteralString,
	LiteralBool,
	LiteralInt,
	LiteralFloat
} LiteralType;

typedef enum {
	PROGRAM,
	FUNCTION,
	ASSIGNMENT,
	IF,
	IF_ELSE,
	WHILE,
	FOR,
	RETURN,
	BREAK,
	CONTINUE,
	LESS_OR_EQUAL,
	GREATER_OR_EQUAL,
	EQUAL,
	NOT_EQUAL,
	GREATER,
	LESSER,
	LOGICAL_OR,
	LOGICAL_AND,
	LOGICAL_NOT,
	BITWISE_AND,
	BITWISE_OR,
	SHIFT_LEFT,
	SHIFT_RIGHT,
	IDENTIFIER,
	ARRAY,
	LITERAL,
	TERNARY, /*Maybe it's the same as the ifelse?*/
	PLUS,
	MINUS,
	MULTIPLICATION,
	DIVISION,
	MOD,
	SIGN_INVERSION,
	PLUS_SIGN,
	ADDRESS,
	POINTER,
	QUESTION_MARK,
	HASHTAG,
	EXPONENT,
	LIST_PARAM,
	LIST_FOR
} TypeAST;

#endif

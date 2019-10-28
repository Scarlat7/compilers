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
	PROGRAM, //0
	FUNCTION, //1
	ASSIGNMENT, //2
	IF, //3
	IF_ELSE, //4
	WHILE, //5
	FOR, //6
	RETURN, //7
	BREAK, //8
	CONTINUE, //9
	LESS_OR_EQUAL, //10
	GREATER_OR_EQUAL, //11
	EQUAL, //12
	NOT_EQUAL, //13
	GREATER, //14
	LESSER, //15
	LOGICAL_OR, //16
	LOGICAL_AND, //17
	LOGICAL_NOT, //18
	BITWISE_AND, //19
	BITWISE_OR, //20
	SHIFT_LEFT, //21
	SHIFT_RIGHT, //22
	IDENTIFIER, //23
	ARRAY, //24
	LITERAL, //25
	TERNARY, //26
	PLUS, //27
	MINUS, //28
	MULTIPLICATION, ///29
	DIVISION, //30
	MOD, //31
	SIGN_INVERSION, //32
	PLUS_SIGN, //33
	ADDRESS, //34
	POINTER, //35
	QUESTION_MARK, //36
	HASHTAG, //37
	EXPONENT, //38
	LIST_PARAM, //39
	LIST_FOR, //40
	FUNCTION_CALL, //41
	EMPTY_BLOCK //42
} TypeAST;

#endif

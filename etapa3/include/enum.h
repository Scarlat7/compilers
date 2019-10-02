/* Enumerations for data types */

#ifndef ENUM_H
#define ENUM_H

typedef enum { 
	ReservedWord,
	SpecialChar,
	CompoundOperator,
	Identifier,
	Literal
} TokenType;

typedef enum { 
	LiteralChar,
	LiteralString,
	LiteralBool,
	LiteralInt,
	LiteralFloat
} LiteralType;

typedef enum {
	Program,
	Function,
	Assignment,
	If,
	While,
	For,
	Return,
	Break,
	Continue,
	LessOrEqual,
	GreaterOrEqual,
	Equal,
	NotEqual,
	And,
	Or,
	Greater,
	Lesser,
	ShiftLeft,
	ShiftRight,
	ID,		/* Identifier */
	Array,
	Lit,	/* Literal */
	Ternary, /*Maybe it's the same as the ifelse?*/
	ArithmeticPlus,
	ArithmeticMinus,
	ArithmeticMultiply,
	ArithmeticDivision,
	ArithmeticMod,
	SignInversion,
	LogicalOr,
	LogicalAnd,
	LogicalNot,
	Address,
	Pointer,
	QuestionMark,
	Hashtag,
	Exponent
} TypeAST;

#endif
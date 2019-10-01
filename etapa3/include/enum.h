/* Enumerations for data types */

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
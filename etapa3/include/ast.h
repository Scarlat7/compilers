#ifndef AST_H
#define AST_H

#include "enum.h"
#include "tree.h"

typedef struct AST_NODE	{
	TypeAST type;
	Tree *node;
} ast_node;


#endif
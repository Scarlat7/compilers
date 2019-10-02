#ifndef TREE_H
#define TREE_H

#include <stdlib.h>
#include "enum.h"

/* 	
	The AST is an N-ary tree with children represented
	by a linked list with the first element being first_child
	and the pointer to the next element being next_sibling
*/
typedef struct N_TREE {
	void* value; /* This node' s value */
	TypeAST type;
	int nb_children; /* Number of children */
	struct N_TREE *first_child, *last_child;	/* First and last childre */
	struct N_TREE *next_sibling; /* Pointer to the next sibling */

} Tree;

Tree* new_tree();
Tree* make_node(TypeAST type, void *value);
void insert_child(Tree *parent, Tree *child);
Tree* make_unary_node(TypeAST type, Tree* node);
Tree* make_binary_node(TypeAST type, Tree* node, Tree* node2);
Tree* make_ternary_node(TypeAST type, Tree* node, Tree* node2, Tree *node3);
void print_tree_depth(Tree *tree, int level);
void print_spaces(int spaces);

#endif
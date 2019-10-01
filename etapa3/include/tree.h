#include <stdlib.h>

/* 	
	The AST is an N-ary tree with children represented
	by a linked list with the first element being first_child
	and the pointer to the next element being next_sibling
*/
struct N_TREE {
	void* value; /* This node' s value */
	int nb_children; /* Number of children */
	Tree *first_child, *last_child;	/* First and last childre */
	Tree *next_sibling; /* Pointer to the next sibling */

} Tree;
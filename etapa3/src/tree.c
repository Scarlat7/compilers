#include <stdio.h>
#include "enum.h"
#include "tree.h"

	/* BEWARE!!! NOTHING IN HERE HAS BEEN TESTED YET */

Tree* new_tree(){
	return make_node(Program, NULL);
}

Tree* make_node(TypeAST type, void *value){
	Tree* new_node = malloc(sizeof(Tree));
	new_node->type = type;
	new_node->value = value;
	new_node->first_child = NULL;
	new_node->last_child = NULL;
	new_node->next_sibling = NULL;
	new_node->nb_children = 0;
	return new_node;
}

void insert_child(Tree *parent, Tree *child){
	if(parent == NULL || child == NULL){
		fprintf(stderr,"[Function: %s] Impossible to insert child to tree, null pointer encountered.\n", __func__);
		exit(-1);
	}

	if(parent->nb_children == 0){
		parent->first_child = child;
		parent->last_child = child;
		parent->nb_children += 1;
	}else{
		/* Always inserts at end, because it's way easier than the alternative */
		parent->last_child->next_sibling = child;
		parent->last_child = child;
		parent->nb_children += 1;
	}
}

Tree* make_unary_node(TypeAST type, Tree* node){
	Tree *parent = make_node(type, NULL);
	insert_child(parent, node);
	return parent;
}

Tree* make_binary_node(TypeAST type, Tree* node, Tree* node2){
	Tree *parent = make_node(type, NULL);
	insert_child(parent, node);
	insert_child(parent, node2);
	return parent;
}

Tree* make_ternary_node(TypeAST type, Tree* node, Tree* node2, Tree *node3){
	Tree *parent = make_node(type, NULL);
	insert_child(parent, node);
	insert_child(parent, node2);
	insert_child(parent, node3);
	return parent;
}

void print_tree_depth(Tree *tree, int level){
	if(tree != NULL){
		Tree* current = tree->first_child;
		print_tree_depth(current, level+1);
		print_spaces(level);
		printf("%p[%d]: %p\n",tree,tree->nb_children,tree->value);
		while(current->next_sibling != NULL){
			current = current->next_sibling;
			print_tree_depth(current,level+1);
		}
	}
}

void print_spaces(int spaces){
	while(spaces-- > 0)
		printf(" ");
}
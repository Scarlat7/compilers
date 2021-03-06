#include "tree.h"

	/* BEWARE!!! NOTHING IN HERE HAS BEEN TESTED YET */

Tree* new_tree(){
	ValorLexico dummy;
	return make_node(PROGRAM, dummy);
}

Tree* make_node(TypeAST type, ValorLexico value){
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
	if(parent == NULL){
		fprintf(stderr,"[Function: %s] Impossible to insert child to tree, null pointer encountered.\n", __func__);
		exit(-1);
	}

	if(child == NULL){
		return;
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

Tree* unary_node(TypeAST type, Tree* node){
	ValorLexico dummy;
	Tree *parent = make_node(type, dummy);
	insert_child(parent, node);
	return parent;
}

Tree* binary_node(TypeAST type, Tree* node, Tree* node2){
	ValorLexico dummy;
	Tree *parent = make_node(type, dummy);
	insert_child(parent, node);
	insert_child(parent, node2);
	return parent;
}

Tree* ternary_node(TypeAST type, Tree* node, Tree* node2, Tree *node3){
	ValorLexico dummy;
	Tree *parent = make_node(type,dummy);
	insert_child(parent, node);
	insert_child(parent, node2);
	insert_child(parent, node3);
	return parent;
}

Tree* quartenary_node(TypeAST type, Tree* node, Tree* node2, Tree *node3, Tree *node4){
	ValorLexico dummy;
	Tree *parent = make_node(type,dummy);
	insert_child(parent, node);
	insert_child(parent, node2);
	insert_child(parent, node3);
	insert_child(parent, node4);
	return parent;
}

Tree* cinquieme_node(TypeAST type, Tree* node, Tree* node2, Tree *node3, Tree *node4, Tree *node5){
	ValorLexico dummy;
	Tree *parent = make_node(type,dummy);
	insert_child(parent, node);
	insert_child(parent, node2);
	insert_child(parent, node3);
	insert_child(parent, node4);
	insert_child(parent, node5);
	return parent;
}

void free_tree(Tree* tree){
	if(tree != NULL){
		Tree* temp;
		Tree* current = tree->first_child;
		while(current != NULL ){
			temp = current->next_sibling;
			free_tree(current);
			current = temp;
		}
		if(tree->type == LITERAL || tree->type == IDENTIFIER ||
			tree->type == FUNCTION_CALL){
			free(tree->value.token_val.str);

		}
		free(tree);
	}
}

void print_tree_depth(Tree *tree, int level, FILE *file)
{
	if (tree != NULL)
	{
		if (file != NULL)
		{
			Tree *current = tree->first_child;
			if(current == NULL && level == 0){
				fprintf(file, "%p,\n", tree);
				return;
			}

			// Go through all siblings
			while (current != NULL)
			{
				fprintf(file, "%p, %p\n", tree, current);
				//print_spaces(2*level);
				//printf("%p[%d]: %d\n",tree,tree->nb_children,tree->type);
				print_tree_depth(current, level + 1, file);
				current = current->next_sibling;
			}
		}
	}
}

void print_spaces(int spaces){
	while(spaces-- > 0)
		printf(" ");
}
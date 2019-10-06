#include "interface.h"

void libera(void *arvore){
	free_tree((Tree*) arvore);
}

void exporta(void *arvore){
	print_tree_depth(arvore,0);
}
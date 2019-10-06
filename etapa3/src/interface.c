#include "interface.h"

void libera(void *arvore){
	free_tree((Tree*) arvore);
}

void exporta(void *arvore){
	FILE *file;
	file = fopen("e3.csv", "w");
	print_tree_depth(arvore, 0, file);
	fclose(file);
}
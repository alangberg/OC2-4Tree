#include "cuatrotree.h"

//---------AUXILIARES---------

ctNode* chequearCaso(ctNode* currNode, int indice, uint32_t newVal){
	if(currNode->child[indice] != NULL){
		return ct_aux_search(currNode->child[indice], newVal);
	}else{
		ctNode* nuevoNodo = malloc(sizeof(ctNode));
		currNode->child[indice] = nuevoNodo;
		nuevoNodo->father = currNode;
		nuevoNodo->len = 0;
		int i;
		for(i = 0; i < 4; i++){
			nuevoNodo->child[i] = NULL;
		}
		return nuevoNodo;
	}
}

ctNode* ct_aux_search(ctNode* currNode, uint32_t newVal){
	if(currNode->len == 1 && currNode->value[0] == newVal) return NULL;
	if(currNode->len == 2 && (currNode->value[0] == newVal || currNode->value[1] == newVal)) return NULL;
	if(currNode->len == 3 && (currNode->value[0] == newVal || currNode->value[1] == newVal || currNode->value[2] == newVal)) return NULL;
	if(currNode->len != 3){
		return currNode;
	}else{
		if(newVal < (currNode->value[0])){ 				//Hijo a revisar = child[0]
			return chequearCaso(currNode, 0, newVal);
		}else if(newVal > (currNode->value[2])){ 		//Hijo a revisar = child[3]
			return chequearCaso(currNode, 3, newVal);
		}else if(newVal < (currNode->value[1])){ 		//Hijo a revisar = child[1]
			return chequearCaso(currNode, 1, newVal);
		}else{ 											//Hijo a revisar = child[2]	
			return chequearCaso(currNode, 2, newVal);
		}
	}
}

void ct_aux_fill(ctNode* currNode, uint32_t newVal){
	if(currNode->len == 0){
		currNode->value[0] = newVal;
	}else if(currNode->len == 1){
		if(currNode->value[0] < newVal){
			currNode->value[1] = newVal;
		}else{
			currNode->value[1] = currNode->value[0];
			currNode->value[0] = newVal;
		}
	}else{ //currNode->len == 2
		if(currNode->value[1] < newVal){
		 currNode->value[2] = newVal;	
		}else if(currNode->value[0] > newVal){
			currNode->value[2] = currNode->value[1];
			currNode->value[1] = currNode->value[0];	  
			currNode->value[0] = newVal;
		}else{
			currNode->value[2] = currNode->value[1];
			currNode->value[1] = newVal;
		}   
	}
	currNode->len++;
}


//---------FUNCIONES---------

void ct_add(ctTree* ct, uint32_t newVal){
	if(ct->size == 0){
		ctNode* raiz = malloc(sizeof(ctNode));
		ct->root = raiz;
		raiz->father = NULL;
		raiz->value[0] = newVal;
		raiz->len = 1;
		int i;
		for(i = 0; i<4; i++){
			raiz->child[i] = NULL;
		}
		ct->size++;
	}else{
		ctNode* nodo = ct_aux_search(ct->root, newVal);
		if(nodo != NULL){
			ct_aux_fill(nodo, newVal);
			ct->size++;
		}
	}
}



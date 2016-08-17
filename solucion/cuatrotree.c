#include "cuatrotree.h"

//---------AUXILIARES---------

ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){


}

void ct_aux_fill(ctNode* currNode, uint32_t newVal){


}


//---------FUNCIONES---------

void ct_add(ctTree* ct, uint32_t newVal){
	ctNode* nodo = ct_aux_search(ct->root, 0, newVal);
	ct_aux_fill(nodo, newVal);
	ct->size++;
}



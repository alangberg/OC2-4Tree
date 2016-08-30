#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){

    ctTree* pepito;
    ct_new(&pepito);
    ct_add(pepito, 4);
    ct_add(pepito, 5);
    ct_add(pepito, 10);
    ct_add(pepito, 19);
    ct_add(pepito, 20);
    ct_add(pepito, 30);
    ct_add(pepito, 39);
    ct_add(pepito, 40);
    ct_add(pepito, 50);
    ct_add(pepito, 60);

    ctIter* it = ctIter_new(pepito);
    ctIter_first(it);
    
    char* name = "prueba.txt";
    FILE* pFile = fopen( name, "w" );
    
    ct_print(pepito, pFile);
        
    fclose( pFile );

    ctIter_delete(it);
    ct_delete(&pepito);
    return 0;    
}
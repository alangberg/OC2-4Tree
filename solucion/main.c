#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){

	ctTree* pepito;
	ct_new(&pepito);
	ct_add(pepito, 5);
	ct_add(pepito, 4);
  	ct_add(pepito, 8);
  	ct_add(pepito, 1);
	ct_add(pepito, 5);
  	ct_add(pepito, 5);
  	ct_add(pepito, 8);

 
    char* name = "prueba.txt";
    FILE *pFile = fopen( name, "a" );
    
    fprintf(pFile,"-\n");
        
    fclose( pFile );
    ct_delete(&pepito);
    return 0;    
}
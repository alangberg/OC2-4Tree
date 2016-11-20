; FUNCIONES de C
  extern malloc
  extern free
  extern fprintf
   
; FUNCIONES
  global ct_new
  global ct_delete
  global ct_print
  global ctIter_new
  global ctIter_delete
  global ctIter_first
  global ctIter_next
  global ctIter_get
  global ctIter_valid

; /** defines offsets y size **/
  ;-----ctTree-----
  %define TREE_OFFSET_ROOT             0
  %define TREE_OFFSET_CANT             8
  %define TREE_OFFSET_SIZE             12

  ;-----NODE-----
  %define NODE_OFFSET_FATHER           0 
  %define NODE_OFFSET_VALUE_0          8
  %define NODE_OFFSET_VALUE_1          12
  %define NODE_OFFSET_VALUE_2          16
  %define NODE_OFFSET_LEN              20
  %define NODE_OFFSET_CHILD_0          21
  %define NODE_OFFSET_CHILD_1          29
  %define NODE_OFFSET_CHILD_2          37
  %define NODE_OFFSET_CHILD_3          45
  %define NODE_SIZE                    53

  ;-----ITERADOR-----
  %define ITER_OFFSET_TREE             0
  %define ITER_OFFSET_NODE             8
  %define ITER_OFFSET_CURR             16
  %define ITER_OFFSET_COUNT            17
  %define ITER_SIZE                    21 
  ;-----ETC-----
  %define NULL                         0
  %define tam_int                      4
  %define tam_pointer                  8


section .data
formato : db "%d",10,0
formatovacio : db "%s",10,0
msj : db "El arbol esta vacio",10,0


section .text

; =====================================
; void ct_new(ctTree** pct);
ct_new:
  push rbp
  mov rbp, rsp
  push r12
  sub rsp, 8

    mov r12, rdi
    mov rdi, TREE_OFFSET_SIZE                        ;seteo el parametro que va a entrar en malloc()
    call malloc                               ;pido memoria para tdt (empieza en rax)
    mov qword [rax+TREE_OFFSET_ROOT], NULL    ;seteo la raiz del nuevo arbol.
    mov dword [rax+TREE_OFFSET_CANT], 0       ;seteo la cantidad de nodos en 0 (este campo es una dword -> 4 bytes)
    mov [r12], rax

  add rsp, 8
  pop r12
  pop rbp
  ret

; ; =====================================
; void borrarNodos(ctNode* pct);
borrarNodos:
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 8

    mov rbx, rdi
    cmp rbx, NULL ;si pct es null, no hago nada
    je .fin

    mov rdi, [rbx + NODE_OFFSET_CHILD_0]
    call borrarNodos
    mov rdi, [rbx + NODE_OFFSET_CHILD_1]
    call borrarNodos
    mov rdi, [rbx + NODE_OFFSET_CHILD_2]
    call borrarNodos
    mov rdi, [rbx + NODE_OFFSET_CHILD_3]
    call borrarNodos

  .borrarActual: ;ya borre los subarboles, ahora borro el nodo pct
    mov rdi, rbx
    call free  
  
  .fin:
  add rsp, 8    
  pop rbx
  pop rbp
  ret

; ; =====================================

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 8

    mov rbx, [rdi] ;me guardo el puntero a la estructura
    mov rdi, [rbx + TREE_OFFSET_ROOT]
    cmp rdi, NULL  ;si ya la raiz es null, no hago nada
    je .fin

    call borrarNodos

  .fin:
    mov rdi, rbx
    call free
  add rsp, 8
  pop rbx
  pop rbp
  ret

; ; =====================================
; ; void ct_aux_print(ctNode* node, FILE *pFile);
ct_aux_print:
  push rbp
  mov rbp, rsp
  push rbx
  push r12

    mov rbx, rdi
    mov r12, rsi
    
    cmp rbx, NULL ;si el nodo es null, no hago nada
    je .fin

    mov rdi, [rbx + NODE_OFFSET_CHILD_0]
    mov rsi, r12
    call ct_aux_print

    mov rdi, r12
    mov rsi, formato
    mov edx, [rbx + NODE_OFFSET_VALUE_0]
    call fprintf 

    mov rdi, [rbx + NODE_OFFSET_CHILD_1]
    mov rsi, r12
    call ct_aux_print

    cmp byte [rbx + NODE_OFFSET_LEN], 1
    je .fin

    mov rdi, r12
    mov rsi, formato
    mov edx, [rbx + NODE_OFFSET_VALUE_1]
    call fprintf

    mov rdi, [rbx + NODE_OFFSET_CHILD_2]
    mov rsi, r12
    call ct_aux_print

    cmp byte [rbx + NODE_OFFSET_LEN], 2
    je .fin

    mov rdi, r12
    mov rsi, formato
    mov edx, [rbx + NODE_OFFSET_VALUE_2]
    call fprintf

    mov rdi, [rbx + NODE_OFFSET_CHILD_3]
    mov rsi, r12
    call ct_aux_print
  
  .fin:
  pop r12    
  pop rbx
  pop rbp
  ret

; ; =====================================
; ; void ct_print(ctTree* ct, FILE *pFile);
ct_print:
  push rbp
  mov rbp, rsp
  push rbx
  push r12

    mov rbx, rdi
    mov r12, rsi

    cmp qword [rbx + TREE_OFFSET_ROOT], NULL
    je .esVacio
    mov rdi, [rbx + TREE_OFFSET_ROOT]
    call ct_aux_print
    jmp .fin

  .esVacio:
    mov rdi, r12
    mov rsi, formatovacio
    mov rdx, msj
    call fprintf

  .fin:
  pop r12
  pop rbx
  pop rbp
  ret

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 8

    mov rbx, rdi        ;me guardo el puntero al arbol
    mov rdi, ITER_SIZE
    call malloc
    mov [rax + ITER_OFFSET_TREE], rbx
    mov qword [rax + ITER_OFFSET_NODE], NULL
    mov byte [rax + ITER_OFFSET_CURR], 0
    mov dword [rax + ITER_OFFSET_COUNT], 0

  add rsp, 8
  pop rbx
  pop rbp
  ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
  jmp free

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
  push rbp
  mov rbp, rsp

    mov rsi, [rdi+ ITER_OFFSET_TREE]
    mov rsi, [rsi + TREE_OFFSET_ROOT]
    
    cmp rsi, NULL
    je .fin

  .ciclo:
    cmp qword [rsi + NODE_OFFSET_CHILD_0], NULL
    je .fin
    mov rsi, [rsi + NODE_OFFSET_CHILD_0]
    jmp .ciclo

  .fin:
    mov [rdi + ITER_OFFSET_NODE], rsi
    mov byte [rdi + ITER_OFFSET_CURR], 0
    mov dword [rdi + ITER_OFFSET_COUNT], 1
  
  pop rbp
  ret

;void call ctIter_aux_up(ctIter* ctIt)
ctIter_aux_up:
          push rbp
          mov rbp,rsp
          push rbx
          push r12
          push r13
          sub rsp,8
          
          mov rbx,rdi                       ;guardo la dir de rdi en rbx para no perderla
          mov r12,[rbx+ITER_OFFSET_NODE]    ;copio a rbx la direccion del nodo al que apunta el iterador
          mov r13,[r12+NODE_OFFSET_FATHER]  ;copio a r12 la direccion del padre del nodo al que apunta el iterador
          mov rdi,r12                       ;copio rdi la dir el nodo al que apunta el iterador
          mov rsi,r13                       ;copio a rsi la dir del padre del nodo al que apunta el iterador
          call ctIter_aux_isIn   

          cmp rax,0
          je .Voyacurrent0 ;si rax devolvio 0 es porque el nodo actual es el hijo0 del padre entonces el siguiente elemento del iterador debe apuntar al value[0] del padre
          cmp rax,1
          je .Voyacurrent1
          cmp rax,2
          je .Voyacurrent2
          cmp rax,3             ;si rax devolvio 3 es porque el nodo actual es el hijo3 del padre y ya recorrio todos los nodos
          je .recursionarriba   ;tengo que subir hasta arriba de todo con llamadas recursivas

          .Voyacurrent0:
          mov rdi,rbx
          mov [rdi+ITER_OFFSET_NODE],r13
          mov byte [rdi+ITER_OFFSET_CURR],0
          jmp .fin

          .Voyacurrent1:
          mov rdi,rbx
          mov [rdi+ITER_OFFSET_NODE],r13
          mov byte [rdi+ITER_OFFSET_CURR],1
          jmp .fin

          .Voyacurrent2:
          mov rdi,rbx
          mov [rdi+ITER_OFFSET_NODE],r13
          mov byte [rdi+ITER_OFFSET_CURR],2
          jmp .fin

          .recursionarriba:
          mov rdi,rbx
          mov [rdi+ITER_OFFSET_NODE],r13
          cmp qword [rdi+ITER_OFFSET_NODE],NULL  ;tengo que fijarme si puedo subir
          je .fin                                ;en el caso donde no subo es cuando el padre es null q es la raiz
          call ctIter_aux_up

          .fin:
          add rsp,8
          pop r13
          pop r12
          pop rbx
          pop rbp
          ret
;ctIter_aux_down(crIter* ctIt)
ctIter_aux_down:
          push rbp
          mov rbp,rsp
          push rbx
          sub rsp,8

          mov rbx,[rdi+ITER_OFFSET_NODE] ;copio a rbx la dir del nodo al que apunta el iterador
            .ciclo:
            cmp qword [rbx+NODE_OFFSET_CHILD_0],NULL  ;mientras la dir del hijo[0] no sea cero bajar
            je .fin
            mov rbx,[rbx+NODE_OFFSET_CHILD_0]         ;mientras haya hijo[0] , actualizar el puntero a nodo del iterador
            mov [rdi+ITER_OFFSET_NODE],rbx
            jmp .ciclo

          .fin:
          mov byte [rdi+ITER_OFFSET_CURR],0     ;como bajo a la hoja con el elemento mas chico el current se actualiza al indice 0
          add rsp,8
          pop rbx
          pop rbp
          ret

; =====================================
; unint 32_t ctIter_aux_isIn(ctNode* current, ctNode* father)
ctIter_aux_isIn:
  
            cmp rsi,NULL
            je .fin
            
            cmp [rsi+NODE_OFFSET_CHILD_0],rdi  ;si la direccion del hijo[0] del padre coincide con el nodo actual , entonces subir por el hijo[0] en padre
            je .Esdelhijo0

            cmp [rsi+NODE_OFFSET_CHILD_1],rdi
            je .Esdelhijo1

            cmp [rsi+NODE_OFFSET_CHILD_2],rdi
            je .Esdelhijo2

            cmp [rsi+NODE_OFFSET_CHILD_3],rdi
            je .Esdelhijo3

            .Esdelhijo0:
            mov rax,0
            ret

            .Esdelhijo1:
            mov rax,1
            ret

            .Esdelhijo2:
            mov rax,2
            ret

            .Esdelhijo3:
            mov rax,3
            .fin:
            ret

; void ctIter_next(ctIter* ctIt);
;rdi<-- puntero al iterador
ctIter_next:
        push rbp
        mov rbp,rsp
        push rbx
        push r12
        push r13
        push r14
        push r15

        xor rbx,rbx
        xor r12,r12
        xor r14,r14
        xor r15,r15
        
        mov rbx,rdi                                   ;guardo la dir del iterador para no perderlo
        mov r12b,[rbx+ITER_OFFSET_CURR]             ;guardo en r12 el valor de current
        mov r13,[rbx+ITER_OFFSET_NODE]                ;guardo en r13 la dir del nodo al que apunta
        add byte [rbx+ITER_OFFSET_CURR],1          ;actualizo el current del iterador
        inc r12b                                       ;incremento 1 el current
        add dword [rbx+ITER_OFFSET_COUNT],1           ;incremento 1 el contador porque el iterador se movio
        mov ax,r12w
        imul ax,8
        mov r15w,ax                                   ;Para moverme entre el arreglo de childs tengo que moverme en current*8(tam de un puntero)
        cmp qword [r13+NODE_OFFSET_CHILD_0+r15],NULL    ;if(ctIt->node->child[ctIt->current] == 0)
        jne .haymashijos
        mov r14b,[r13+NODE_OFFSET_LEN]
        dec r14b
        
        cmp r12b,r14b            ;if(ctIt->current > ctIt->node->len -1)
        jle .fin
        mov rdi,rbx
        call ctIter_aux_up
        jmp .fin

        .haymashijos:
        mov r13,[r13+NODE_OFFSET_CHILD_0+r15]      ; ctIt->node = ctIt->node->child[ctIt->current]
        mov rdi,rbx                               ;muevo a rdi la direccion del puntero al iterador pasado como parametro
        mov [rdi+ITER_OFFSET_NODE],r13            ;actualizo el puntero a nodo del iterador
        call ctIter_aux_down
        .fin:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
  push rbp
  mov rbp, rsp

    xor rcx, rcx
    mov rdx, [rdi + ITER_OFFSET_NODE]     ;levanto el nodo actual
    mov cl, [rdi + ITER_OFFSET_CURR]      ;levanto el curr 
    lea rdx, [rdx + NODE_OFFSET_VALUE_0]  ;posiciono rdx donde arranca el arreglo de values 
    mov eax, [rdx + rcx*tam_int]          ;levanto el value

  pop rbp
  ret
; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
  push rbp
  mov rbp, rsp

    mov eax, 0
    cmp qword [rdi + ITER_OFFSET_NODE], NULL
    je .fin
    inc eax

  .fin:
  pop rbp
  ret



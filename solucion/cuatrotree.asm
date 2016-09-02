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

; =====================================
; void ctIter_aux_up(ctIter* ctIt);
ctIter_aux_up:
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 8
    mov rbx, rdi
    
    
    
    
  add rsp, 8
  pop rbx
  pop rbp
  ret
; =====================================

; =====================================
; void ctIter_aux_down(ctIter* ctIt);
ctIter_aux_down:
  push rbp
  mov rbp, rsp

  .ciclo:
    cmp qword [rax + NODE_OFFSET_CHILD_0], NULL
    je .fin
    mov rax, [rax + NODE_OFFSET_CHILD_0]
    jmp .ciclo

  .fin:
  mov [rdi + ITER_OFFSET_NODE], rax
  mov byte [rax + ITER_OFFSET_CURR], 0

  pop rbp
  ret
; =====================================


; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 8

    mov rbx, rdi
    inc dword [rbx + ITER_OFFSET_COUNT]
    inc byte [rbx + ITER_OFFSET_CURR]

    mov rax, [rbx + ITER_OFFSET_NODE]
    lea rax, [rax + NODE_OFFSET_CHILD_0]
    cmp qword [rax + ITER_OFFSET_CURR * tam_pointer], NULL
    jne .hayHijos
      mov r8, [rbx + ITER_OFFSET_NODE]
      mov r8, [r8 + NODE_OFFSET_LEN]
      dec r8
      cmp [rbx + ITER_OFFSET_CURR], r8
      jle .fin 
      call ctIter_aux_up
      jmp .fin

  .hayHijos:
    mov rax, [rax + ITER_OFFSET_CURR * tam_pointer]   
    mov [rbx + ITER_OFFSET_NODE], rax
    call ctIter_aux_down

  .fin:
   
  add rsp, 8
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



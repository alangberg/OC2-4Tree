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
  %define TREE_OFFSET_SIZE             8
  %define TREE_SIZE                    12

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
  %define ITER_TREE                    0
  %define ITER_NODE                    8
  %define ITER_CURR                    16
  %define ITER_COUNT                   17
  ;-----ETC-----
  %define NULL                        0
  %define tam_int                     8  

 
section .text

; =====================================
; void ct_new(ctTree** pct);
ct_new:
  push rbp
  mov rbp, rsp
  push r12
  sub rsp, 8

  mov r12, rdi
  mov rdi, TREE_SIZE                        ;seteo el parametro que va a entrar en malloc()
  call malloc                               ;pido memoria para tdt (empieza en rax)
  mov qword [rax+TREE_OFFSET_ROOT], NULL    ;seteo la raiz del nuevo arbol.
  mov dword [rax+TREE_OFFSET_SIZE], 0       ;seteo la cantidad de nodos en 0 (este campo es una dword -> 4 bytes)
  mov [r12], rax

  add rsp, 8
  pop r12
  pop rbp
  ret


; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
        ret

; ; =====================================
; ; void ct_aux_print(ctNode* node);
ct_aux_print:
        ret

; ; =====================================
; ; void ct_print(ctTree* ct);
ct_print:
        ret

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
        ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
        ret




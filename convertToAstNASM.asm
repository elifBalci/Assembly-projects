SECTION .data
msg     db      'Test STRING', 0Ah
 
SECTION .text
global  _start
 
_start:
 
    mov     eax, msg        ; move the address of our message string into EAX
    call    strlen          ; call our function to calculate the length of the string
    mov     eax, msg  
    call    str_remove
 
    mov     edx, eax        ; our function leaves the result in EAX
    mov     ecx, msg        ; this is all the same as before
    mov     ebx, 1
    mov     eax, 4
    int     80h
 
    mov     ebx, 0
    mov     eax, 1
    int     80h
 
;__________________________________________________________________________________________________________________________________

strlen:                     ; this is our first function declaration
    ;push    ebx             ; push the value in EBX onto the stack to preserve it while we use EBX in this function
    mov     ebx, eax        ; move the address in EAX into EBX (Both point to the same segment in memory)
 
nextchar:                   ; this is the same as lesson3
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar
 
finished:
    sub     eax, ebx
    ;pop     ebx             ; pop the value on the stack back into EBX
    ret                     ; return to where the function was called

;__________________________________________________________________________________________________________________________________

str_remove:                     ; this is our first function declaration
    push    ebp
    mov     ebp, esp
    mov     ecx, eax        ; move the address in EAX into EBX (Both point to the same segment in memory)
 
str_loop:                   ; this is the same as lesson3
    cmp     byte [eax], 0
    jz      rmv_finished
    inc     eax
    cmp     byte [eax], 65     ;Compare to 'A'
    jge     greater_than_A    ;jump when eax greater than or equal to ebx
    jmp     str_loop

greater_than_A:
    cmp     byte [eax], 90  ;Compareto 'Z'
    jle     str_remove_char ;(jump when less than or equal to) 
    jmp     str_loop

str_remove_char:
    ;;;;;;;;;;;;;;;;;;;
    mov BYTE [eax], '*'
    jmp     str_loop

 
rmv_finished:
    sub     eax, ecx
    pop     ebp
    ret                     ; return to where the function was called
;__________________________________________________________________________________________________________________________________



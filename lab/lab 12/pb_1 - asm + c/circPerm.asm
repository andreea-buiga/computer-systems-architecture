bits 32 
global _perm
extern _printf
segment data use32 class=data public
    hex_format db 'hexa representation: %lX', 10, 0
segment code use32 class=code public
_perm:
    push EBP                                ; create stack frame
    mov EBP, ESP
    
    mov ECX, 8                              ; 8 hex digits (loop it 8 times)
    mov EAX, 0                              ; putting 0 in EAX because we have unsigned representation
    mov EAX, [EBP + 8]                      ; getting the number
    
    .perm_loop:
        ror EAX, 4                          ; rotating by 4 (4 bits = 1 hex digit)
        pusha                               ; saving ECX and EAX before calling printf
        push EAX                            ; printing the permutation
        push hex_format
        call _printf                        ; printing the number in base 16
        add ESP, 4*2
        popa                                ; getting the values of ECX and EAX back
    loop .perm_loop
    
    mov ESP, EBP                            ; destroy stack frame
    pop EBP
    
    ret
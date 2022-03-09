bits 32

global _nrMax

segment data public data use32
segment code public code use32


_nrMax:
    ; create a stack frame
    push ebp
    mov ebp, esp
    
    
    mov eax,dword [ebp + 8]        ; eax = a
    cmp eax,dword [ebp + 12]  ; compare a with b
    
    jle here1
    mov eax, dword [ebp + 8] 
    jmp here2
    
    here1:
        mov eax, dword [ebp + 12]
    here2:
    
    ; restore the stack frame
    mov esp, ebp
    pop ebp

    ret
    
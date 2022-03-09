bits 32

global start        

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db '+', 'r', '0', '8', '8', '1', 'i', '5', 'a'
    len equ $ - s
    ; digits db '012345789'
    d resb len
segment code use32 class=code
    start:
        ; mov ecx, len
        
        ; mov esi, 0
        ; mov ebx, 0
        
        ; jecxz end_prog
        
        ; repeat_this:
            ; push ecx
            ; mov al, [s + esi]
            ; mov ecx, 10
            ; mov edi, digits
            ; find:
                ; scasb
                ; jz found
            ; loop find
            
            ; jmp next
            
            ; found:
                ; mov edi, ebx
                ; inc ebx
                ; mov [d + edi], al
            
            ; next:   
                ; inc esi
                ; pop ecx
        ; loop repeat_this
        
        ; end_prog:
        
        mov ecx, len
        
        jecxz end_prog
        
        xor esi, esi ; forces the content of esi to 0
        xor edi, edi  ; forces the content of edi to 0
        
        repeat_this:
            mov   al, [s + esi]
            ;inc esi
            
            cmp   al, '0'  ; comparing with 0
            jb    next  ; moving if on if it's not a digit
            
            cmp   al, '9'  ; comparing with 9
            ja    next  ; moving if on if it's not a digit
            
            mov   [d + edi], al  ; add the digit to d
            inc   edi  ; increasing the size of d
            next:   
                inc esi
                
        loop  repeat_this
        
        end_prog:
        
        push    dword 0
        call    [exit]

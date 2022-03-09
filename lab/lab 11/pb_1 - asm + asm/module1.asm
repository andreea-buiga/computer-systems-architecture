bits 32
segment use32 public code
    rez dd 0                ; intermediate variable for the result
    ten dd 10               ; variable that is simply 10
global circ_perm
    circ_perm:
        mov EBX, [ESP + 4]          ; the parameter on the stack is our number
        mov ECX, [ESP + 8]          ; take the first parameter on the stack, to get the closest 10 power smaller than our number
        mov [rez], EBX              ; in rez we put our number
        mov EDX, 0                  ; in the high part of EDX:EAX have 0
        mov EAX, [rez]              ; putting in EAX the variable rez
        div ECX                     ; dividing by ECX, such that in EDX we have the n-1 digits of the number, in EAX the digit on the first position
        mov EBX, EDX                ; putting in EBX the n - 1 digits
        mov ECX, EAX                ; putting in ECX the first digit
        mov EAX, EBX                ; putting in EAX the n - 1 digits
        mov EDX, 0                  ; putting 0 in edx
        mul DWORD [ten]
        add EAX, ECX                ; in eax we will have the result
        ret
        
bits 32
segment use32 public code
    zece dd 10                          ; variable that is simply 10
global nr_cif
    nr_cif:                             ; returns in CL, the number of the nigits for a given number
        mov ECX, 0
        mov CL, 1                       ; in CL we'll store the number of digits
        mov EAX, 1                      ; in EAX we'll store the 10 powers
        .repeta:                    
            mul  DWORD [zece]           ; multiplying by 10, such that in EDX:EAX, we'll have 10 * EAX
            mov EDX, [ESP + 4]          ; in EDX we store the parameter
            cmp EAX, EDX                ; if 10^(CL + 1) > EDX, that means the number of the digits of the parameter is CL
            jg .stop                    ; thes stop label
            inc CL                      ; if we don't stop, we increment the 10 power
            jmp .repeta                 ; jumping to the nr_cif label to repeat the process
        .stop:
            ret 
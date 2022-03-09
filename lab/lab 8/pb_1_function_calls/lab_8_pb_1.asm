; 1 | read two numbers a and b (in base 10) from the keyboard and calculate their product. This value will be stored in a variable called "result" (defined in the data segment).

bits 32

global start        

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    a dw 0
    b dw 0
    message_a db "a = ", 0
    message_b db "b = ", 0
    format_scan db "%d", 0
    format_print db "The product of a and b is %d.", 0
    result resd 1

segment code use32 class=code
    start:
        push dword message_a
        call [printf]
        add esp, 4*1  ; free parameters on the stack
        
        push dword a
        push dword format_scan
        call [scanf]
        add esp, 4*2  ; free parameters on the stack
        
        push dword message_b
        call [printf]
        add esp, 4*1  ; free parameters on the stack
        
        push dword b
        push dword format_scan
        call [scanf]
        add esp, 4*2  ; free parameters on the stack
        
        mov ax, [a]  ; ax = a
        imul word [b]  ; dx:ax = a * b
        
        push dx  ; push dx on the stack
        push ax  ; push ax on the stack
        pop eax  ; eax = dx:ax
        
        mov [result], eax  ; we put the product in the result variable
        
        push dword [result]
        push dword format_print
        call [printf]
        add esp, 4*2  ; free parameters on the stack
        
        push    dword 0
        call    [exit]

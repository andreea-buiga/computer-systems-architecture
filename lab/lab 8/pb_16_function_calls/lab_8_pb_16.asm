; 16 | read two numbers a and b (in base 10) from the keyboard. Calculate and print their arithmetic average in base 16

bits 32

global start        

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    a dd 0
    b dd 0
    message_a db "a = ", 0
    message_b db "b = ", 0
    format_scan db "%d", 0
    format_print db "The arithmetic average in base 16 of a and b is %x.", 0
    result resw 1

segment code use32 class=code
    start:
        ; ...
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
        
        mov eax, [a]  ; eax = a
        add eax, dword [b]  ; eax = a + b
        sar eax, 1  ; eax = (a + b)/ 2
        
        push eax
        push format_print
        call [printf]
        add esp, 4*2
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

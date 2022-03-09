; Read a string of numbers, given in the base 10 as signed numbers. Determine the maximum value of the string and write it in the file max.txt (it will be created) in 16 base.
bits 32 
global  start 

extern exit, fopen, fclose, fprintf, readNumber
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll


import exit msvcrt.dll; 
segment data use32 class=data
    name_f db 'input.txt', 0
    file_des1 dd  -1  
    file_des2 dd -1
    modRead db 'r', 0
    modWrite db 'w', 0
    max dd 0
    max_file db 'max.txt', 0
    max_text db 'the largest number is: %x.', 0
    
segment code use32 class=code
start: 
    
    push dword modRead                   ; opening file
    push dword name_f
    call [fopen]
    add esp, 4 * 2
    
    mov [file_des1], eax 
    cmp eax, 0 
    je end_all                           ; ending in case of error
    
    mov esi, 0
    repeat_read:
        push dword [file_des1]
        call readNumber                  ; reading the number
        inc esi                          ; increasing esi becase we called the function
        cmp eax, [max]                   ; compare with max, if it is greater then we will memorise it
        jb next                          ; if not go to the next one
        mov [max], eax                   ; replace max if greater
        next:
            cmp ebx, 0
            jne repeat_read 
        
    push dword [file_des1]
    call [fclose]
    add esp, 4*1
    
    push dword modWrite     
    push dword max_file
    call [fopen]
    add esp, 4*2 
    
    mov [file_des2], eax
    
    push dword [max]
    push dword max_text
    push dword [file_des2]
    call [fprintf]
    add esp, 4*2
        
    end_all:
    push dword 0
    call [exit]

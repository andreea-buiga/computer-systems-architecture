; read a number
bits 32 
global  start 

extern exit, fread
import exit msvcrt.dll    
import fread msvcrt.dll

import exit msvcrt.dll; 
segment data public data use32 class=data
    buffer      resb    5
	format_f    db      '%s', 0
    file_des    dd      -1
    digits      dw      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    found_num   dd      0
    number      dd      0
    sign        dw      1
    ten         dw      10
    count       dd      0
    
segment code public code use32
global readNumber

readNumber: 
    mov eax, [esp + 4]                     ; getting file description from function params
    mov [file_des], eax
    mov [number], dword 0
    mov [sign], word 1
    mov [found_num], dword 0

    repeat_read:                           ; reading the characters from the file and trying to find a number
        push dword [file_des]
        push dword 1
        push dword 1
        push dword buffer
        call [fread]
        add esp, 4 * 4
        cmp eax, 0
        je process_end
        
        mov [count], eax                   ; storing the number of read character
        cld
        mov ax, [buffer]
        mov ebx, dword 9

        cmp ax, '-'                        ; check for sign so that means the number is negative
        jne iterate_digits
        mov [sign], word -1                ; make the sign '-' so we know we have a negative number
        
        iterate_digits:
            cmp ax, [digits + ebx * 2]
            je found_digit                 ; it is a digit so go compute it (because we read numbers in base 10, so no letters or other
                                           ; symbols should be present)
            dec ebx
            cmp ebx, 0
            jge iterate_digits

        mov eax, [found_num]               ; character read was not a digit
        cmp eax, 1
        jne go_next                        ; it is not a digit so try read next char
        jmp process_end                    ; it is a digit so we finish reading the number
        
        found_digit:
            mov [found_num], dword 1       ; remember that we found a digit
            mov eax, [number]
            mul word [ten]
            mov edx, [buffer]
            sub edx, '0'
            add eax, edx
            mov [number], eax
          
        go_next:
        cmp [count], dword 1
        je repeat_read 
    
    process_end:

    mov eax, [number]                     ;
    imul word [sign]                      ; multiply with according sign
    mov ebx, [found_num]
    ret 4
    
    push dword 0
    call [exit]
; A text file is given. Read the content of the file, count the number of letters 'y' and 'z' and display the values on the screen. The file name is defined in the data segment.

bits 32

global start    

extern exit,fopen,fclose,fread  ,printf          
import exit msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll 
import printf msvcrt.dll 

segment data use32 class=data
    file_name db "input.txt", 0  ; the name of the file that's gonna be read
    mod_acces db "r", 0
    descriptor dd -1
    len equ 100  ; the maximum length that can be read in the current stage
    buffer times len db 0
    nr_of_chars_read dd 0
    format_print db "The number of 'y' is %d and 'z' is %d.", 0

segment code use32 class=code
    start:
        push dword mod_acces
        push dword file_name
        call [fopen]
        add esp, 4*2  ; free parameters on the stack
        
        cmp eax, 0
        je final
        
        mov [descriptor], eax
        
        mov ebx, 0  ; in ebx we'll store the number of y's
        mov ebp, 0  ; in edx we'll store the number of z's
        
        loop_:
            push dword [descriptor]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4  ; free parameters on the stack
            
            cmp eax, 0  ; if eax is 0, then we finished reading the file
            je cleanup

            mov [nr_of_chars_read], eax  ; saving the number of characters read
            
            mov ecx, [nr_of_chars_read]
            cld
            cmp ecx, 0
            je cleanup
            
            mov esi, 0
            
            check_character:
                push ecx
                mov al, byte [buffer + esi]
                
                cmp al, 'y'  ; check if it is y
                je found_y
                
                cmp al, 'z'  ; check if it is z
                je found_z
                
                jmp next
                
                found_y:
                    inc ebx  ; incrementing the counter for y
                    jmp next

                found_z:
                    inc ebp  ; incrementing the counter for z
                    jmp next
                    
                next:
                    pop ecx
                    inc esi  ; go to the next character from buffer
                loop check_character
            
            jmp loop_
            
        cleanup:
       
        ; printing the number of y's and z's
        
        push ebp
        push ebx
        push dword format_print
        call [printf]
        add esp, 4*2
        
        ; closing the file
        
        push dword [descriptor]
        call [fclose]
        add esp, 4
        
        final:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

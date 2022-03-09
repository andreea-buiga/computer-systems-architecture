; A text file is given. Read the content of the file, count the number of vowels and display the result on the screen. The name of text file is defined in the data segment.

bits 32

global start    

extern exit,fopen,fclose,fread  ,printf, fscanf    
import exit msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll 
import printf msvcrt.dll 
import fscanf msvcrt.dll 

segment data use32 class=data
    file_name db "input.txt", 0  ; the name of the file that's gonna be read
    mod_acces db "r", 0
    descriptor dd -1
    len equ 100  ; the maximum length that can be read in the current stage
    buffer times len db 0
    nr_of_chars_read dd 0
    vowels db "AEIOUaeiou", 0
    format db "%s"
    format_print db "The number of vowels in the text file is %d.", 0
    text dd 0

segment code use32 class=code
    start:
        push dword mod_acces
        push dword file_name
        call [fopen]
        add esp, 4*2  ; free parameters on the stack
        
        mov [descriptor], eax
        
        cmp eax, 0
        je final
        
        mov ecx, 2
        
        loop_:
            push dword text
            push dword format
            push dword [descriptor]
            call [fscanf]
            add esp, 4*3  ; free parameters on the stack
            
            push dword text 
            push dword format
            call [printf]
            add esp, 4 * 2
            
            jmp cleanup
            
        cleanup:
       
        ; printing the number of vowels in the text file 
        
        push ebx
        push dword format_print
        call [printf]
        add esp, 4*2
        
        ; closing the file
        
        push dword [descriptor]
        call [fclose]
        add esp, 4
        
        final:
            push    dword 0    
            call    [exit]     
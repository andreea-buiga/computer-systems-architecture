; Being given two alphabetical ordered strings of characters, s1 and s2, build using merge sort the ordered string of bytes that 
; contain all characters from s1 and s2.

bits 32

global start        

extern exit         
import exit msvcrt.dll
segment data use32 class=data
    ; ...
    s1 db 'dfz' ; first string in alphabetical order
    len_s1 equ ($ - s1) ; length of first string
    s2 db 'bcdfj' ; second string in alphabetical order
    len_s2 equ ($ - s2) ; length of second string
    rez times len_s1 + len_s2 db 0
    str_reminder dd 0

segment code use32 class=code
    start:
        cld ; set direction flag to 0 to go from left to right
        
        mov ESI, s1 ; s1 in source
        mov EDI, s2 ; s2 in destination
       
        mov ECX, len_s1 + len_s2 ; the max length (len_s1 + len_s2)
        
        mov EBX, 0 ; for s2, how many elements we went through
        mov EAX, 0 ; for s1, how many elements we went through
        mov EDX, 0 ; for indexing in the result string
        
        repeat_this:
            cmpsb ; comparing the elements of the two strings
            
            jb smaller_s1 ; s1[pos] < s2[pos]
            jg larger_s1 ; s1[pos] > s2[pos]
            je equals; s1[pos] = s2[pos]
            
            smaller_s1:
                dec ESI ; decrementing s1
                dec EDI ; decrementing s2
                
                mov [str_reminder], EAX ; save the value of the index where we are in s1
                
                lodsb ; put in AL the current value of ESI
                
                mov [rez + EDX], AL ; put in the result on the position EDX the value from AL
                mov EAX, [str_reminder] ; reset the value from EAX
                
                inc EDX ; incrementing length of the result
                inc EAX ; incrementing the index where we are in s1
                
                cmp EAX, len_s1 ; if we are done with the elements in s1
                
                jge sf_prg ; jump to sf_prog
                loop repeat_this ; repeating the loop
                jecxz sf_prg ; if ecx = 00000000, we jump to sf_prog
            
            larger_s1:
                dec EDI ; decrementing EDI
                dec ESI ; decrementing ESI
                
                mov [str_reminder], EAX ; save the value of EAX
                mov AL, [EDI]
                
                mov [rez + EDX], AL
                mov EAX, [str_reminder]
                
                inc EDI ; incrementing the index where we were in s1
                inc EDX ; incrementing the index where we were in rez
                inc EBX ; incrementing the index where we were in s2
                
                cmp EBX, len_s2
                
                jge sf_prg ; jump to sf_prog
                loop repeat_this ; repeating the loop
                jecxz sf_prg ; if ebx = 00000000, we jump to sf_prog
            
            equals:
                dec ESI
                
                mov [str_reminder], EAX ; save the value of the index where we were in s1
                
                lodsb
                mov [rez + EDX], AL
                mov EAX, [str_reminder]
                
                inc EDX ; incrementing length of the result
                inc EBX ; incrementing EBX
                
                cmp EBX, len_s2 ; if we are done with the elements in s2
                
                jge sf_prg
                
                inc EAX ; incrementing EAX (the index where we were in s1)
                
                cmp EAX, len_s1 ; if we are done with the elements in s2
                
                jge sf_prg ; jump to sf_prog
                loop repeat_this ; repeating the loop
                jecxz sf_prg ; if eax = 00000000, we jump to sf_prog
        sf_prg:
        
        cmp EAX, len_s1 ; comparing EAX with the length of s1, if EAX = len_s1 then we are done with the terms of s1 
        je ebx_bigger; if we have to add terms from s2
        jne ebx_smaller ; if EAX is not equal to len_s1 we are done with the terms of s2
        
        ebx_bigger: ; the remaining terms of s1
            mov ECX, len_s2
            sbb ECX, EBX
            repeat_:
                mov AL, [EDI]
                mov [rez + EDX], AL
                inc EDX
                inc EDI
            loop repeat_
            jmp end_prg
        
        ebx_smaller:
            mov ECX, len_s1
            sub ECX, EAX
            repeat__:
                lodsb
                mov [rez + EDX], AL
                inc EDX
            loop repeat__
        
        
        end_prg:
        push    dword 0      
        call    [exit]
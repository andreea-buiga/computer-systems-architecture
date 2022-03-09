bits 32

global start        

extern exit
import exit msvcrt.dll  

segment data use32 class=data
    s db 1, 2, 3, 4 ; declaring the string of bytes s
    l equ $ - s - 1 ; compute the length of the string l - 1
    d times l dw 0 ; reserve l bytes for the destination string and initialize it
segment code use32 class=code
    start:
        ; Given a byte string S of length l, obtain the string D of length l-1 as D(i) = S(i) * S(i+1) (each element of D is the product of two consecutive elements of S).

        mov ecx, l
        
        mov esi, 0
        
        jecxz end_prog
        repeat_this:
            mov ax, [s + esi]
            imul ah ; multiplying consecutive terms
            
            mov [d + esi + esi], ax; put the result in d
            
            inc esi ; incrementing esi to go to the next position
        loop repeat_this  
    
        end_prog:
        
        push dword 0
        call [exit]

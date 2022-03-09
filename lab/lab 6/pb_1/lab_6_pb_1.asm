bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 
    s1 dd 23h, 127F5678h, 0ABCDABCDh  ; the string of doublewords
    len_s1 equ ($ - s1)/4  ; the length of the string (in doublewords)
    dest times len_s1 dd 0  ; here'll store the result

; our code starts here
segment code use32 class=code
    start:
        ; 1 |  An array with doublewords containing packed data (4 bytes written as a single doubleword) is given. 
        ; Write an asm program in order to obtain a new array of doublewords, where each doubleword will be composed 
        ; by the rule: the sum of the bytes from an odd position (1 & 3) will be written on the word from the odd position and 
        ; the sum of the bytes from an even (0 & 2) position will be written on the word from the even position. The bytes are 
        ; considered to represent signed numbers, thus the extension of the sum on a word will be performed according 
        ; to the signed arithmetic.
        
        mov esi, s1  ; in esi we'll have the string s1
        mov edi, dest  ; edi will be in charge
        mov ecx, len_s1  ; ecx will have the length of the string
        
        cld  ; set direction flag to 0 to go from left to right
        
        repeat_summing:
            lodsb  ; in AL we'll have the low-byte of the low-word of the dword
            cbw  ; signed conversion | AX = AL
            mov bx, ax  ; BX = AX
            
            lodsb  ; in AL we'll have the high-byte of the low-word of the dword
            cbw  ; signed conversion AX = AL
            mov dx, ax  ; DX = AX
            
            lodsb  ; in AL we'll have the low-byte of the high-word of the dword
            cbw  ; signed conversion AX = AL
            
            add bx, ax  ; bx - the sum of the bytes on odd positions
            
            lodsb  ; in AL we'll have the high-byte of the high-word of the dword
            cbw
            
            add dx, ax  ; dx - the sum of the bytes on even positions
            
            push dx
            push bx
            pop eax  ; eax = dx:bx
            
            stosd  ; store the dword
            
        loop repeat_summing
            
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

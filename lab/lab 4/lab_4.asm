bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 3 | Given the words A and B, compute the doubleword C as follows:
        ; the bits 0-2 of C are the same as the bits 12-14 of A
        ; the bits 3-8 of C are the same as the bits 0-5 of B
        ; the bits 9-15 of C are the same as the bits 3-9 of A
        ; the bits 16-31 of C are the same as the bits of A
    ; 18 | Given the word A, compute the doubleword B as follows:
        ; the bits 0-3 of B have the value 0;
        ; the bits 4-7 of B are the same as the bits 8-11 of A
        ; the bits 8-9 and 10-11 of B are the invert of the bits 0-1 of A (so 2 times)
        ; the bits 12-15 of B have the value 1
        ; the bits 16-31 of B are the same as the bits 0-15 of B
    a  dw  0111_0111_0101_0111b
    b  dw  1001_1011_1011_1110b
    c  dd  0
; our code starts here
segment code use32 class=code
    start:
        ; 3
    
        ; the bits 0-2 of C are the same as the bits 12-14 of A
        ; mov ecx, 0
        ; mov ax, [a] ; isolate bites 12-14
        ; and ax, 0111_0000_0000_0000b
        ; ror ax, 12 ; we rotate 12 positions to the right
        ; or cx, ax
        
        ; the bits 3-8 of C are the same as the bits 0-5 of B
        ; mov ax, [b]
        ; and ax, 0000_0000_0001_1111b
        ; rol ax, 3 ; we rotate 3 positions to the left
        ; or cx, ax
        
        ; the bits 9-15 of C are the same as the bits 3-9 of A
        ; mov ax, [a]
        ; and ax, 0000_0011_1111_1000b
        ; rol ax, 6 ; we rotate 6 positions to the left
        ; or cx, ax
        
        ; the bits 16-31 of C are the same as the bits of A
        ; mov ebx, [a]
        ; rol ebx, 16
        ; and ebx, 1111_1111_1111_1111_0000_0000_0000_0000b
        ; mov eax, ecx
        ; or eax, ebx
        ; mov [c], eax ; 0111_0111_0101_0111_1101_0100_1111_0111
        
        ; 18
        ; the bits 0-3 of B have the value 0
        mov ecx, 0 
        
        ; the bits 4-7 of B are the same as the bits 8-11 of A | 0111
        mov ax, [a]
        and ax, 0000_0111_0000_0000b 
        ror ax, 4
        or cx, ax ; 0000_0000_0000_0000_0000_0000_0111_0000
        
        ; the bits 8-9 and 10-11 of B are the invert of the bits 0-1 of A (so 2 times) | 11 -> 00 inverted
        mov ax, [a]
        ; neg ax ; we invert the value of A | ax = 0110_0100_0100_0010
        ; and ax, 0000_0000_0000_0010b ; isolate the 0-1 bits of A
        not ax
        and ax, 0000_0000_0000_0011b
        rol ax, 8
        or cx, ax ; 0000_0000_0000_0000_0000_xx00_0111_0000
        
        rol ax, 2
        or cx, ax ; 0000_0000_0000_0000_0000_0000_0111_0000   
        
        ; the bits 12-15 of B have the value 1
        or cx, 1111_0000_0000_0000b ; 0000_0000_0000_0000_1111_0000_0111_0000 
        
        ; the bits 16-31 of B are the same as the bits 0-15 of B | 1001_1011_1011_1110
        mov ebx, [b]
        rol ebx, 16
        and ebx, 1111_1111_1111_1111_0000_0000_0000_0000b
        mov eax, ecx
        or eax, ebx
        
        ; save the result
        mov [c], ebx ; 1001_1011_1011_1110_1111_0000_0111_0000b = 9BBEF070h
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

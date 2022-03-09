bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ; a db 2
    ; b db 12
    ; c db 5
    ; d db 7
    
    ; a dw 20
    ; b dw 7
    ; c dw 3
    ; d dw 55
    
    ; a db 4
    ; b db 12
    ; c db 10
    ; d dw 17
    
    a db 5
    b db 10
    c db 11
    d db 7
    e dw 2
    f dw 17
    g dw 23
    h dw 12
; our code starts here
segment code use32 class=code
    start:
        ;; lab 2 | simple exercises | 1 : 1 + 9
        
        mov al, 1
        mov bl, 9
        add al, bl
        mov eax, 1
        add eax, 9
        
        ;; lab 2 | simple exercises | 16 : 4 * 4 
        
        mov al, 4
        mov bl, 4
        mul bl
        
        ;; lab 2 | additions, subtractions | a, b, c, d - byte | 1 : c - (a + d) + (b + d)
        
        mov al, [a]
        mov cl, [c]
        sub cx, ax
        mov dl, [d]
        sub cx, dx
        mov bl, [b]
        add cx, bx
        add cx, dx
        
        ;; lab 2 | additions, subtractions | a, b, c, d - byte | 16 : a + 13 - c + d - 7 + b
        
        mov al, [a]
        add ax, 13
        mov cl, [c]
        sub ax, cx
        mov dl, [d]
        add ax, dx
        sub ax, 7
        mov bl, [b]
        add ax, bx
        
        ;; lab 2 | additions, subtractions | a, b, c, d - word | 1 : (c + b + a) - (d + d)
        
        mov cx, [c]
        mov bx, [b]
        add cx, bx
        mov ax, [a]
        add cx, ax
        mov dx, [d]
        sub cx, dx
        sub cx, dx
        
        ;; lab 2 | additions, subtractions | a, b, c, d - word | 16 : (a + b + b) + (c - d)
        
        mov ax, [a]
        mov bx, [b]
        add ax, bx
        add ax, bx
        mov cx, [c]
        add ax, cx
        mov dx, [d]
        sub ax, dx
        
        ;; lab 2 | multiplications, divisions | a, b, c - byte, d - word | 1 : ((a + b - c) * 2 + d - 5 ) * d
        
        mov al, [a]
        mov bl, [b]
        add al, bl
        mov cl, [c]
        sub al, cl
        mov dh, 2
        mul dh
        add ax, [d]
        sub ax, 5
        mov dx, [d]
        mul dx
        
        ;; lab 2 | multiplications, divisions | a, b, c - byte, d - word | 16 : (a + b) / 2 + (10 - a / c) + b / 4
        
        mov bl, [a]
        add bl, [b]
        mov al, bl
        mov ah, 0
        mov cl, 2
        div cl
        mov bl, al
        add bl, 10
        mov al, [a]
        mov ah, 0
        mov cl, [c]
        div cl
        sub bl, al
        mov al, [b]
        mov ah, 0
        mov cl, 4
        div cl
        add bl, al
                
        ;; lab 2 | multiplications, divisions | a, b, c, d - byte, e, f, g, h - word | 1 : ((a - b) * 4) / c 
        
        mov al, [a]
        sub al, [b]
        mov dh, 4
        mul dh
        mov cl, [c]
        div cl
        
        ;; lab 2 | multiplications, divisions | a, b, c, d - byte, e, f, g, h - word | 16 : a * a - (e + f)
        
        mov al, [a] ; al = 5
        mov dh, [a] ; dh = 5
        mul dh      ; ax = al * dh = 25
        mov bx, [e] ; bx = 2
        add bx, [f] ; bx = 2 + 17 = 19
        sub ax, bx  ; ax = 25 - 19 = 6
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 1 - 16 (first 4 ex)
    a db 3
    b dw 10
    c dd 2
    d dq 23
    
    ; 1 | c + (a * a - b + 7) / (2 + a) | a - byte, b - doubleword, c - qword
    a db 4
    b dd 12
    c dq 33
    
    ; 16 | x / 2 + 100 * (a + b) - 3 / (c + d) + e * e | a, c - word, b, d - byte, e - doubleword, x - qword
    a dw 12
    b db 2
    c dw 1
    d db 2
    e dd -32
    x dq -55
    
    result resq 1
; our code starts here
segment code use32 class=code
    start:
        ; 1 | c - (a + d) + (b + d) | a - byte, b - word, c - double word, d - qword - unsigned representation
        
        mov eax, 0
        mov al, [a]
        mov edx, 0 ; edx:eax = a
        add eax, dword [d]
        adc edx, dword [d + 4] ; edx:eax = a + d
        mov ebx, [c]
        mov ecx, 0 ; ecx:ebx = c
        sub eax, ebx
        sbb edx, ecx ; edx:eax = c - (a + d)
        mov ebx, 0
        mov bx, [b]
        mov ecx, 0 ; ecx:ebx = b
        add ebx, [d]
        adc ecx, [d + 4] ; ecx:ebx = b + d
        sub eax, ebx
        sbb edx, ecx ; edx:eax = c - (a + d) + (b + d)
        mov dword [result+0], eax 
        mov dword [result+4], edx 
        
        ; 16 | c - a - (b + a) + c
        
        mov eax, [c] ; eax = c
        mov ebx, 0
        mov bl, [a]
        sub eax, ebx ; eax = c - a
        mov dx, 0
        mov dl, [a]
        add dx, [b] ; dx = b + a
        mov ebx, 0
        mov bx, dx
        sub eax, ebx ; eax = c - a - (b + a)
        add eax, [c] ; eax = c - a - (b + a) + c
        
        ; 1 | (c + b + a) - (d + d)
        
        mov al, [a] ; al = a
        cbw ; signed conversion al to ax
        mov bx, [b]
        add ax, bx ; ax = b + a
        cwd ; signed coversion ax to the doubleword dx:ax = b + a
        push dx
        push ax
        pop eax ; eax = b + a
        add eax, [c] ; eax = c + b + a
        cdq ; signed coversion eax to the quadword edx:eax = c + b + a
        mov ebx, dword [d]
        mov ecx, dword [d + 4] ; ecx:ebx = d
        add ebx, dword [d]
        adc ecx, dword [d + 4] ; ecx:ebx = d + d
        sub eax, ebx
        sbb edx, ecx ; edx:eax = (c + b + a) - (d + d)
        mov dword [result + 0], eax 
        mov dword [result + 4], edx
        
        ; 16 | (d - a) - (a - c) - d
        
        mov ebx, dword [d]
        mov ecx, dword [d + 4] ; ecx:ebx = d
        mov al, [a] ; al = a
        cbw ; word ax = a
        cwd ; doubleword dx:ax = a
        push dx
        push ax
        pop eax ; eax = dx:ax = a
        cdq ; quadword edx:eax = a
        clc
        sub ebx, eax
        sbb ecx, edx ; ecx:ebx = d - a
        mov al, [a] ; al = a
        cbw ; word ax = a
        cwd ; doubleword dx:ax = a
        push dx
        push ax
        pop eax ; eax = dx:ax = a
        sub eax, [c] ; eax = a - c
        cdq ; edx:eax = a - c
        clc
        sub ebx, eax
        sbb ecx, edx ; ecx:ebx = (d - a) - (a - c)
        clc
        sub ebx, [d]
        sbb ecx, [d + 4] ; ecx:ebx = (d - a) - (a - c) - d
        mov dword [result + 0], ebx 
        mov dword [result + 4], ecx
        
        ; 1 | unsigned | c + (a * a - b + 7) / (2 + a) | a - byte, b - doubleword, c - qword 
        
        mov al, [a]
        mov dh, [a]
        mul dh ; ax = al * dh = a * a
        mov dx, 0 ; dx:ax = a * a
        clc
        sub ax, word [b]
        sbb dx, word [b + 2] ; dx:ax = a * a - b
        push dx
        push ax
        pop eax ; eax = a * a - b
        mov ebx, 0
        mov bl, 7
        add eax, ebx
        mov bl, [a]
        add bl, 2 ; ebx = 2 + a
        mov edx, 0
        div ebx ; eax = edx:eax / ebx = (a * a - b + 7) / (2 + a)
        mov edx, 0
        clc
        add eax, dword [c]
        adc edx, dword [c + 4] ; edx:eax = c + (a * a - b + 7) / (2 + a)
        mov dword [result + 0], eax 
        mov dword [result + 4], edx
        
        ; 16 | signed | x / 2 + 100 * (a + b) - 3 / (c + d) + e * e | a, c - word, b, d - byte, e - doubleword, x - qword
        
        mov ebx, dword [x]
        mov ebp, dword [x + 4]  ; ebp:ebx = x
        sar ebp, 1  ; divinding by 2 -> shift to the right
        rcr ebx, 1  ; ebp:ebx = x / 2
         
        mov   eax, dword [e]
        imul  eax  ; edx:eax = e * e
        add   ebx, eax
        adc   ebp, edx  ; ebp:ebx = x / 2 + e * e

        movsx eax, word [a]
        movsx edx, byte [b]
        add eax, edx  ; eax = a + b
        mov edx, 100
        imul edx  ; edx:eax = 100 * (a + b)
        add ebx, eax
        adc ebp, edx  ; ebp:ebx = x / 2 + 100 * (a + b) + e * e
        
        mov al, byte [d]  ; al = d
        cbw  ; ax = d
        add ax, word [c]  ; ax = c + d
        mov cx, ax  ; cx = c + d
        mov ax, 3
        cwd
        idiv cx  ; ax = dx:ax / cx = 3 / (c + d)
        cwd
        push dx
        push ax
        pop eax  ; eax = 3 / (c + d)
        cdq  ; edx:eax = 3 / (c + d)
        
        sub ebx, eax
        sbb ebp, edx  ; ebp:ebx = x / 2 + 100 * (a + b) - 3 / (c + d) + e * e = 2395d = 95bh
        mov dword [result + 0], ebx 
        mov dword [result + 4], ebp
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

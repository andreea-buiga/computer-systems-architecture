; 1 | An unsigned number a on 32 bits is given. Print the hexadecimal representation of a, but also the results of the circular permutations of its digits.

; 1234                                |
; 2341                                | => circular permutations
; 3412                                |
; 4123                                |

bits 32 

global start        

extern exit, printf, circ_perm, nr_cif
import exit msvcrt.dll    
import printf msvcrt.dll

segment data use32
    ; ...
    a dd 987654321
    format_print db "The number in base 16 is: %x",13, 10, 0            ; displaying the number in base 16
    format_print1 db "The permutation is: %d", 13, 10, 0                ; displaying the number in base 10
    zece dd 10
    nr_cifre dd 0
    power dd 0
segment code use32 public code
    start:
       push DWORD [a]                       ; putting the variable value on the stack
       push DWORD format_print              ; the format for displaying in base 16
       call [printf]                        ; calling printf function
       add ESP, 4*2                         ; free the parameters on the stack 
      
       push DWORD [a]                       ; putting the variable value on the stack
       call nr_cif                          ; calling nr_cif we know the number of the digits we have
       add ESP, 4*1                         ; free the parameters on the stack
       
       mov [nr_cifre], ECX                  ; saving the number of digits in a variable

       mov EDX, 0                           ; putting 0 in the high part of EDX:EAX, to avoid integer overflow
       idiv DWORD [zece]                    ; dividing by 10, to get the closest power smaller than number
       
       mov [power], EAX
       
       repeta:
           push DWORD EAX                   ; the closest power smaller than our number, on the stack           
           push DWORD [a]                   ; put the number on the stack as a parameter
           call circ_perm                   ; calling the permutation
           add ESP, 4*2                     ; free the parameters on the stack 
           
           mov [a], EAX
           push DWORD EAX                   ; putting the permutation on the stack
           push DWORD format_print1         ; the format for displaying in base 10
           call [printf]                    ; calling printf function
           add ESP, 4*2                     ; free the parameters on the stack
           
           mov CL, [nr_cifre]               ; in CL we have the number of the remaining permutations 
           dec CL                           ; decrementing this number
           cmp CL, 0                        ; if we get to 0, the we have no further circular permutations to do
           jng final                        ; jump to the end of the program
           mov [nr_cifre], CL
           mov EAX, [power]                 ; putting the 10 power smaller than our initial number
           jmp repeta                       ; jump to the label repeta
           
        
        final:                              ; label for the end of the program
        push    dword 0      
        call    [exit]       

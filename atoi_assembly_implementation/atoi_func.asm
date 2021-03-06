%define LOW_LIMIT 48
%define UP_LIMIT 57
%define CONVERSION 48

section .data
    string_buffer: db "32768", 0
    dec_message_buffer: db "Decimal value of string_buffer is : %d",10 , 0
    hexa_message_buffer: db "Hexadecimal value of string_buffer is : %x",10 , 0

section .bss

section .text

extern printf
extern puts
global main

main:
    enter 0, 0
    push string_buffer  ; I keep the buffer containing the string on the stack
    call puts           ; call the external function puts
    call atoi_f         ; I'm calling the external function call 
    leave
    ret

atoi_f: 
    enter 0, 0
    xor ecx, ecx        ; initializing the registers to the value 0 
    xor edx, edx        ;
    xor esi, esi        ;
    mov edx, [ebp + 8]  ; put in edx the string stored at the address ebp + 8
    
conversion:             ; the function checks a character and converts it 
    xor eax, eax        ; initializing the eax register to the value 0
    mov al, byte [edx + ecx]    ; I put in al the first character in the string
    cmp eax, LOW_LIMIT  ; I check if the character fits as a digit 
    jl done             ; if he can't, jump at done label
    cmp eax, UP_LIMIT   ; check if the character exceeds 57 = ('9' in ASCII) 
    jg done             ; if it exceeds, it jumps at done label 
    sub eax, CONVERSION ; I perform the conversion from ASCII to decimal 
    imul esi, 10        ; in esi I keep the number created by repeated multiplications by 10 
    add esi, eax        ; I add to the number I get, the digit converted to decimal 
    add ecx, 1          ; increase the counter by 1 
    jmp conversion      ; resume the process of creating the number in decimal from begining

done:                   
    mov eax, esi        ; I keep the value obtained in the eax register 
    push eax            ; I place the final value on the stack representing
                        ; the second parameter of the call function 
    push dec_message_buffer ; I place the format on the stack. Will print number as an integer
    call printf         ; call the external function printf
    add esp, 4          ; return the top of the stack to the second parameter of the function 
    push hexa_message_buffer ; I place the format on the stack. Will print number as an hexadecimal
    call printf         ; call the external function printf
    leave
    ret
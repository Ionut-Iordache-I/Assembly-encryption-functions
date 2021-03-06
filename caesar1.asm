%include "io.mac"

%define WRAP_AROUND 26

section .text
    global caesar
    extern printf

caesar:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    ; Implement the caesar cipher

    xor eax, eax                ; initializing the register to the value 0
    xor ebx, ebx                ; initializing the register to the value 0

test_character:                 ; check what kind of character I hava
    mov ebx, edi                ; I put the key from the edi registry in ebx
    mov al, [esi + ecx - 1]     ; I put the value from [esi + ecx - 1] in al
    cmp al, 'A'                 ; compare register al with A = 65 (ASCII)
    jl is_not_letter            ; if the al register value is smaller it jumps
                                ; to test a non-letter character 
    cmp al, 'Z'                 ; compare register al with Z = 90(ASCII)
    jle is_upper_letter         ; if the al register is less than or equal to,
                                ; it jumps to test a capital letter
    cmp al, 'z'                 ; compare register al with z = 122(ASCII)
    jg is_not_letter            ; if the al register value is bigger it jumps
                                ; to test a non-letter character
    cmp al, 'a'                 ; compare register al with a = 97(ASCII)
    jge is_lower_letter         ;if al is greater than or equal to,
                                ; jump to the test for lowercase letter 

is_not_letter:                  ; check a character that is not the letter
    mov [edx + ecx - 1], al     ; I put in ciphertext the value from subregister al
    cmp ecx, 0                  ; check if the ecx accumulation register has reached 0
    dec ecx                     ; decrement the ecx counter
    jz exit                     ; if I reached 0, jump to the end
    jmp test_character          ; if not, repeat the test in test_character

is_upper_letter:                ; I check a character that is uppercase
    add al, bl                  ; I add in the register al, the key retained in bl
    cmp al, 'Z'                 ; check al in relation to Z = 90(ASCII)
    jg wrap_around_process_0    ; if it exceeds Z then it jumps to wrap_around_process_0
    mov [edx + ecx - 1], al     ; otherwise put in ciphertext at the indicated address, the value from al
    cmp ecx, 0                  ; check if the ecx accumulation register has reached 0
    dec ecx                     ; decrement the ecx counter
    jz exit                     ; if I reached 0, jump to the end
    jmp test_character          ; if not, repeat the test in test_character

wrap_around_process_0:          ; modify the key using the macro called WRAP_AROUND => 26
    sub al, bl                  ; substract from the register al, the key
    sub bl, WRAP_AROUND         ; subtract from key 26 in order to obtain a circular displacement 
                                ; when we gather the key to our character 
    jmp is_upper_letter         ; perform the verification with the modified key again 

is_lower_letter:                ; I check a character that is lowercase in the same way 
    add al, bl                  ; described when checking a capital letter 
    cmp ax, 'z'
    jg wrap_around_process_1
    mov [edx + ecx - 1], al
    cmp ecx, 0
    dec ecx
    jz exit
    jmp test_character

wrap_around_process_1:          ; modify the key using a macro called WRAP_AROUND => 26 
    sub al, bl                  ; in the same way as in wrap_around_process_0 
    sub bl, WRAP_AROUND
    jmp is_lower_letter

exit:
    popa
    leave
    ret
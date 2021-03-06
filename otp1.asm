%include "io.mac"

section .text
    global otp
    extern printf

otp:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    ; One Time Pad cipher

    xor eax, eax            ; initializing the register to the value 0 

one_time_pad:
    mov al, [esi + ecx - 1] ; al receives the value from the address
                            ; indicated by [esi + ecx - 1]
    xor al, [edi + ecx - 1] ; xor operation to obtain the cipher
    mov [edx + ecx - 1], al ; set the value from al to the address
                            ; indicated by [edx + ecx - 1]
    loop one_time_pad       ; repeating the instruction until ecx becomes 0

    popa
    leave
    ret
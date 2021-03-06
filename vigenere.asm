%include "io.mac"

%define WRAP_AROUND 26

section .text
    global vigenere
    extern printf

vigenere:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len

    ; Implement the Vigenere cipher

    xor eax, eax                ; initializarea registrului la valoarea 0

test_character:                 ; verifica daca un caracter este litera sau nu
                                ; si daca este litera aplica o cheie asupra lui
    cmp byte [esi], 'A'         ; compar litera din plaintext cu A = 65(ASCII)        
    jl is_not_letter            ; daca byte [esi] este mai mic sare la testarea unei non-litere
    cmp byte [esi], 'Z'         ; compar litera din plaintext cu Z = 90(ASCII)        
    jle test_key                ; daca byte [esi] este mai mic sau egal sare la test pt. cheie
    cmp byte [esi], 'z'         ; compar litera din plaintext cu z = 122(ASCII)        
    jg is_not_letter            ; daca byte [esi] este mai mare sare la testarea unei non-litere
    cmp byte [esi], 'a'         ; compar litera din plaintext cu a = 97(ASCII)        
    jge test_key                ; daca byte [esi] este mai mare sau egal sare la test pt. cheie

is_not_letter:                  ; verificarea cazului cand un caracter nu este litera
    mov al, [esi]               ; pun in al val. de la adresa indicata de [esi]   
    mov [edx], al               ; pun in ciphertext caracterul nemodificat
    add edx, 1                  ; muta la pozitia urmatoare din ciphertext
    add esi, 1                  ; muta la pozitia urmatoare din plaintext
    cmp ecx, 0                  ; verific daca plaintext_len a ajuns la 0
    dec ecx                     ; decrementez registrul ecx 
    jz exit                     ; daca a ajuns la 0 sare la exit
    jmp test_character          ; daca nu efectueaza testarea unui nou caracter

test_key:                       ; verificare pentru cheia de criptare
    cmp ebx, 0                  ; verific daca key_len a ajuns la 0
    je mod_key                  ; daca da sare la mod_key pentru modificarea cheii
    sub ebx, 1                  ; daca nu scade din val. retinuta in cheie 1
    mov al, [edi]               ; pun in al litera curenta din cheie
    sub al, 'A'                 ; scad din al val. 65 = 'A' si obtin cheia pentru vigenere
    push ecx                    ; pun pe stiva val. din ecx pt. al putea utiliza 
    mov cl, [esi]               ; pun in octetul din cl, litera din plaintext
    cmp cx, 'a'                 ; verific litera din cx
    jge is_lower_letter         ; sare la is_lower_letter daca este mai mare sau egal decat 'a'
    jmp is_upper_letter         ; sare la is_upper_letter altfel


is_upper_letter:                ; verificare pentru un caracter litera mare
    add cl, al                  ; adaug la plaintext, cheia
    cmp cx, 'Z'                 ; compar subregistrul cx, cu 'Z' = 90(ASCII)
    jg wrap_around_process_0    ; daca depaseste 'Z' efectueaza deplasarea circulara in wrap_around_p..
    mov [edx], cl               ; pune in adresa din [edx] litera criptata
    pop ecx                     ; extrage ecx de pe stiva 
    add edx, 1                  ; muta la pozitia urmatoare din ciphertext
    add esi, 1                  ; muta la pozitia urmatoare din plaintext
    add edi, 1                  ; muta la pozitia urmatoare din key
    cmp ecx, 0                  ; verifica daca plaintext_len este 0
    sub ecx, 1                  ; scade din plaintext_len valoarea 1
    jz exit                     ; sare la exit daca ecx ajunge la 0
    jmp test_character          ; sare la testarea unui nou caracter in caz contrar

wrap_around_process_0:          ; modifica cheia folosind macro numit WRAP_AROUND => 26
    xor ah, ah                  ; initializarea subregistrului la valoarea 0
    sub cx, ax                  ; extrage din plaintext, cheia
    sub al, WRAP_AROUND         ; extrage din cheia val. 26 pt. a efectua deplasarea circulara
    jmp is_upper_letter         ; sare inapoi la is_upper_letter

is_lower_letter:                ; verificare pentru un caracter litera mica intr-un mod similar cu
                                ; is_upper_letter
    add cl, al                  
    cmp cx, 'z'
    jg wrap_around_process_1
    mov [edx], cl
    pop ecx
    add edx, 1                  ; ciphertext
    add esi, 1                  ; plaintext
    add edi, 1                  ; key
    cmp ecx, 0
    sub ecx, 1
    jz exit
    jmp test_character

wrap_around_process_1:          ; modifica cheia folosind macro numit WRAP_AROUND => 26
    xor ah, ah
    sub cx, ax                  ; ... la fel ca wrap_around_process_1
    sub al, WRAP_AROUND
    jmp is_lower_letter         ; sare inapoi la is_lower_letter

mod_key:                        ; efectuez modificarea cheii
    mov ebx, [ebp + 24]         ; repun in ebx lungimea cheii
    mov edi, [ebp + 20]         ; repun in edi zona de unde incepe cheia 
    jmp test_key                ; efectuez saltul pentru retestare cu noua cheie

exit:                           
    popa
    leave
    ret
%include "io.mac"

section .text
    global my_strstr
    extern printf

my_strstr:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len

    ; Implement my_strstr
    
    xor eax, eax            ; initializarea registrului la valoarea 0
    mov eax, esi            ; pastrez in eax haystack

test_sir:                   ; verificarea in paralel a sirului si a subsirului
    push ecx                ; pun pe stiva haystack_len retinuta in ecx
    push edx                ; pun pe stiva needle_len retinuta in edx
    xor edx, edx            ; initializarea registrului la valoarea 0
    xor ecx, ecx            ; initializarea registrului la valoarea 0
    mov cl, byte [eax]      ; pun in subregistrul cl litera din haystack
    mov dl, byte [ebx]      ; pun in subregistrul dl litera din needle
    cmp cl, dl              ; compar cele doua litere din subregistre
    pop edx                 ; extrag din stiva in registrul edx pt. a nu il pierde
    pop ecx                 ; extrag din stiva in registrul ecx pt. a nu il pierde
    jne reset_needle        ; daca nu sunt egale sare la reset_needle
    sub edx, 1              ; scad din needle_len val. 1
    sub ecx, 1              ; scad din haystack_len val. 1
    cmp edx, 0              ; compar needle_len cu val. 0
    je found                ; daca sunt egale, am parcurs tot subsirul si avem in
                            ; sir un subsir, adica o potrivire
    cmp ecx, 0              ; compar haystack_len cu val. 0
    je not_found            ; daca sunt egale, am parcurs tot sirul si nu avem o
                            ; potrivire a subsirului regasita in sir

next_ch:                    ; efectuez trecerea la urmatorul caracter
    add eax, 1              ; trec la urmatoarea litera din haystack
    add ebx, 1              ; trec la urmatoarea litera din needle
    jmp test_sir            ; sar la eticheta test_sir pentru a relua procesul

reset_needle:               ; refac registrele ebx si edx care au legatura cu needle
    sub ecx, 1              ; scad din haystack_len val. 1
    add eax, 1              ; trec la urmatoarea litera din haystack
    mov ebx, [ebp + 16]     ; repun in ebx needle de pe stiva
    mov edx, [ebp + 24]     ; repun in edx needle_len de pe stiva
    cmp ecx, 0              ; compar haystack_len curenta cu val. 0
    je not_found            ; daca sunt egale, am parcurs tot sirul si nu avem o
                            ; potrivire a subsirului regasita in sir
    jmp test_sir            ; sar la eticheta test_sir pentru a relua procesul

found:                      ; cazul in care s-a gasit potrivirea
    xor eax, eax            ; initializarea registrului la valoarea 0
    mov eax, [ebp + 20]     ; pun in eax haystack_len initial
    sub eax, ecx            ; scad din haystack_len initial, haystack_len curent  
    sub eax, [ebp + 24]     ; scad din ce a ramas needle_len
    mov [edi], eax          ; pun in [edi] valoarea obtinuta in eax
    jmp exit                ; efectuez jump la exit

not_found:                  ; cazul in care nu s-a gasit potrivirea
    xor ecx, ecx            ; initializarea registrului la valoarea 0
    mov ecx, [ebp + 20]     ; repun in ecx haystack_len de pe stiva
    add ecx, 1              ; adaug la valoarea lungimii sirului 1
    mov [edi], ecx          ; pun in [edi] valoarea obtinuta

exit: 
    popa
    leave
    ret

.data
; Definicje sta≥ych
PRIME_P equ 61
PRIME_Q equ 73

.code
; Funkcja: generateRSAKeys
; Opis: Generuje klucze RSA na podstawie liczb pierwszych p i q
generateRSAKeys PROC
    ; Rezerwacja miejsca na zmienne lokalne
    sub rsp, 16

    ; Sta≥e
    mov DWORD PTR [rsp+4], PRIME_P  ; p
    mov DWORD PTR [rsp], PRIME_Q    ; q

    ; Obliczenia
    mov eax, DWORD PTR [rsp+4]      ; eax = p
    imul eax, DWORD PTR [rsp]       ; eax = p * q
    mov DWORD PTR [rsi], eax        ; n = p * q

    mov eax, DWORD PTR [rsp+4]      ; eax = p
    dec eax                         ; eax = p - 1
    mov ebx, DWORD PTR [rsp]       ; ebx = q
    dec ebx                         ; ebx = q - 1
    imul eax, ebx                   ; eax = (p - 1) * (q - 1)
    mov DWORD PTR [rsp+8], eax     ; phi = (p - 1) * (q - 1)

    ; Wybierz e tak, aby 1 < e < phi(n) i gcd(e, phi(n)) = 1
    mov eax, 2                      ; i = 2
loop_e:
    cmp eax, DWORD PTR [rsp+8]     ; sprawdü czy i < phi
    jge end_e                      ; jeúli nie, zakoÒcz pÍtlÍ
    mov ecx, eax                   ; zapisz i do ecx
    mov edx, DWORD PTR [rsp+8]     ; phi
    call gcd                       ; wywo≥aj funkcjÍ gcd
    cmp eax, 1                     ; sprawdü czy gcd(e, phi) == 1
    jne not_coprime_e              ; jeúli nie, przejdü do not_coprime_e
    mov DWORD PTR [rsi], ecx       ; e = i
    jmp end_e                      ; zakoÒcz pÍtlÍ
not_coprime_e:
    inc eax                        ; i++
    jmp loop_e                     ; przejdü do nastÍpnej iteracji
end_e:

    ; Wybierz d tak, aby (d * e) % phi(n) = 1
    mov eax, 2                      ; i = 2
loop_d:
    cmp eax, DWORD PTR [rsp+8]     ; sprawdü czy i < phi
    jge end_d                      ; jeúli nie, zakoÒcz pÍtlÍ
    mov ecx, eax                   ; zapisz i do ecx
    mov edx, DWORD PTR [rsi]       ; edx = e
    imul edx, eax                  ; edx = e * i
    mov ebx, DWORD PTR [rsp+8]     ; ebx = phi
    xor edx, edx                   ; wyzeruj edx
    div ebx                        ; edx:eax = edx(ostatni reszta), eax(iloraz)
    cmp edx, 1                     ; sprawdü czy (d * e) % phi == 1
    jne not_inverse_d              ; jeúli nie, przejdü do not_inverse_d
    mov DWORD PTR [rsi+4], ecx    ; d = i
    jmp end_d                      ; zakoÒcz pÍtlÍ
not_inverse_d:
    inc eax                        ; i++
    jmp loop_d                     ; przejdü do nastÍpnej iteracji
end_d:

    ; ZakoÒczenie funkcji
    add rsp, 16
    ret
generateRSAKeys ENDP

gcd PROC
    ; Argumenty funkcji:
    ; [rsp+8] - a
    ; [rsp+12] - b

    ; Inicjalizacja zmiennych
    mov eax, DWORD PTR [rsp+8]  ; a
    mov ebx, DWORD PTR [rsp+12] ; b

gcd_loop:
    ; Sprawdzenie warunku koÒczπcego pÍtlÍ
    cmp ebx, 0
    je end_gcd

    ; Obliczenie reszty z dzielenia
    xor edx, edx
    div ebx

    ; Aktualizacja wartoúci
    mov eax, ebx
    mov ebx, edx

    ; PowtÛrzenie pÍtli
    jmp gcd_loop

end_gcd:
    ret
gcd ENDP


powermod PROC
    ; Argumenty funkcji:
    ; [rsp+8] - base
    ; [rsp+12] - exp
    ; [rsp+16] - modulus

    ; Inicjalizacja zmiennych
    mov eax, DWORD PTR [rsp+8]  ; base
    mov ebx, DWORD PTR [rsp+12] ; exp
    mov ecx, DWORD PTR [rsp+16] ; modulus
    xor edx, edx                 ; result = 1

    ; PÍtla potÍgowania modulo
loop_powermod:
    test ebx, 1                  ; sprawdü czy exp jest nieparzyste
    jz not_odd                   ; jeúli nie, przejdü do not_odd
    imul edx, eax                ; result *= base
    mov eax, edx                 ; zachowaj wynik w eax
    xor edx, edx                 ; wyzeruj edx
    div ecx                      ; result %= modulus
not_odd:
    imul eax, eax                ; base *= base
    xor edx, edx                 ; wyzeruj edx
    div ecx                      ; base %= modulus
    shr ebx, 1                   ; exp >>= 1
    jnz loop_powermod            ; jeúli exp > 0, powtÛrz pÍtlÍ

    ; ZakoÒczenie funkcji
    ret
powermod ENDP

RSAEncrypt PROC
    
    ; Argumenty funkcji:
    ; RSI - wskaünik na input
    ; R14 - inputLength
    ; RDI - wskaünik na output
    ; R15 - wskaünik na outputLength

    ; Kopiowanie wskaünikÛw do odpowiednich rejestrÛw
    mov rsi, RSI   ; wskaünik na input
    mov r14, RBX   ; inputLength
    mov rdi, RDI   ; wskaünik na output
    mov r15, R15   ; wskaünik na outputLength

    ; Generuj klucze RSA
    call generateRSAKeys

    ; Obliczanie RSA
    mov rcx, rsi          ; rcx = wskaünik na input
    mov rdx, rdi          ; rdx = wskaünik na output
    mov r8, r14           ; r8 = inputLength
    call RSAEncryptInner ; Wywo≥anie funkcji wewnÍtrznej

    ; ZakoÒczenie funkcji
    ret
RSAEncrypt ENDP

RSAEncryptInner PROC
    ; Argumenty funkcji:
    ; RCX - wskaünik na input
    ; RDX - wskaünik na output
    ; R8 - inputLength

    ; Inicjalizacja lokalnych zmiennych
    xor r9, r9               ; r9 = i = 0

loop_rsa_encrypt:
    cmp r9, r8               ; sprawdü czy i < inputLength
    jge end_rsa_encrypt     ; jeúli nie, zakoÒcz pÍtlÍ

    ; Obliczenie szyfrowania RSA
    movzx r10, BYTE PTR [rcx]  ; wczytaj bajt z input
    add r10, rdi               ; dodaj wynik do output
    mov al, r10b               ; wczytaj 8-bitowy bajt z r10
    mov BYTE PTR [rdx], al     ; zapisz wynik do output


    inc rcx                    ; przesuÒ wskaünik na nastÍpny bajt input
    inc rdx                    ; przesuÒ wskaünik na nastÍpny bajt output
    inc r9                     ; i++
    jmp loop_rsa_encrypt       ; przejdü do nastÍpnej iteracji

end_rsa_encrypt:
    ret
RSAEncryptInner ENDP

END

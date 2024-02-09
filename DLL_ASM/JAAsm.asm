.data
; Definicje sta�ych
PRIME_P equ 61
PRIME_Q equ 73

.code
; Funkcja: generateRSAKeys
; Opis: Generuje klucze RSA na podstawie liczb pierwszych p i q
generateRSAKeys PROC
    ; Rezerwacja miejsca na zmienne lokalne
    sub rsp, 16

    ; Sta�e
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
    cmp eax, DWORD PTR [rsp+8]     ; sprawd� czy i < phi
    jge end_e                      ; je�li nie, zako�cz p�tl�
    mov ecx, eax                   ; zapisz i do ecx
    mov edx, DWORD PTR [rsp+8]     ; phi
    call gcd                       ; wywo�aj funkcj� gcd
    cmp eax, 1                     ; sprawd� czy gcd(e, phi) == 1
    jne not_coprime_e              ; je�li nie, przejd� do not_coprime_e
    mov DWORD PTR [rsi], ecx       ; e = i
    jmp end_e                      ; zako�cz p�tl�
not_coprime_e:
    inc eax                        ; i++
    jmp loop_e                     ; przejd� do nast�pnej iteracji
end_e:

    ; Wybierz d tak, aby (d * e) % phi(n) = 1
    mov eax, 2                      ; i = 2
loop_d:
    cmp eax, DWORD PTR [rsp+8]     ; sprawd� czy i < phi
    jge end_d                      ; je�li nie, zako�cz p�tl�
    mov ecx, eax                   ; zapisz i do ecx
    mov edx, DWORD PTR [rsi]       ; edx = e
    imul edx, eax                  ; edx = e * i
    mov ebx, DWORD PTR [rsp+8]     ; ebx = phi
    xor edx, edx                   ; wyzeruj edx
    div ebx                        ; edx:eax = edx(ostatni reszta), eax(iloraz)
    cmp edx, 1                     ; sprawd� czy (d * e) % phi == 1
    jne not_inverse_d              ; je�li nie, przejd� do not_inverse_d
    mov DWORD PTR [rsi+4], ecx    ; d = i
    jmp end_d                      ; zako�cz p�tl�
not_inverse_d:
    inc eax                        ; i++
    jmp loop_d                     ; przejd� do nast�pnej iteracji
end_d:

    ; Zako�czenie funkcji
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
    ; Sprawdzenie warunku ko�cz�cego p�tl�
    cmp ebx, 0
    je end_gcd

    ; Obliczenie reszty z dzielenia
    xor edx, edx
    div ebx

    ; Aktualizacja warto�ci
    mov eax, ebx
    mov ebx, edx

    ; Powt�rzenie p�tli
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

    ; P�tla pot�gowania modulo
loop_powermod:
    test ebx, 1                  ; sprawd� czy exp jest nieparzyste
    jz not_odd                   ; je�li nie, przejd� do not_odd
    imul edx, eax                ; result *= base
    mov eax, edx                 ; zachowaj wynik w eax
    xor edx, edx                 ; wyzeruj edx
    div ecx                      ; result %= modulus
not_odd:
    imul eax, eax                ; base *= base
    xor edx, edx                 ; wyzeruj edx
    div ecx                      ; base %= modulus
    shr ebx, 1                   ; exp >>= 1
    jnz loop_powermod            ; je�li exp > 0, powt�rz p�tl�

    ; Zako�czenie funkcji
    ret
powermod ENDP

RSAEncrypt PROC
    
    ; Argumenty funkcji:
    ; RSI - wska�nik na input
    ; R14 - inputLength
    ; RDI - wska�nik na output
    ; R15 - wska�nik na outputLength

    ; Kopiowanie wska�nik�w do odpowiednich rejestr�w
    mov rsi, RSI   ; wska�nik na input
    mov r14, RBX   ; inputLength
    mov rdi, RDI   ; wska�nik na output
    mov r15, R15   ; wska�nik na outputLength

    ; Generuj klucze RSA
    call generateRSAKeys

    ; Obliczanie RSA
    mov rcx, rsi          ; rcx = wska�nik na input
    mov rdx, rdi          ; rdx = wska�nik na output
    mov r8, r14           ; r8 = inputLength
    call RSAEncryptInner ; Wywo�anie funkcji wewn�trznej

    ; Zako�czenie funkcji
    ret
RSAEncrypt ENDP

RSAEncryptInner PROC
    ; Argumenty funkcji:
    ; RCX - wska�nik na input
    ; RDX - wska�nik na output
    ; R8 - inputLength

    ; Inicjalizacja lokalnych zmiennych
    xor r9, r9               ; r9 = i = 0

loop_rsa_encrypt:
    cmp r9, r8               ; sprawd� czy i < inputLength
    jge end_rsa_encrypt     ; je�li nie, zako�cz p�tl�

    ; Obliczenie szyfrowania RSA
    movzx r10, BYTE PTR [rcx]  ; wczytaj bajt z input
    add r10, rdi               ; dodaj wynik do output
    mov al, r10b               ; wczytaj 8-bitowy bajt z r10
    mov BYTE PTR [rdx], al     ; zapisz wynik do output


    inc rcx                    ; przesu� wska�nik na nast�pny bajt input
    inc rdx                    ; przesu� wska�nik na nast�pny bajt output
    inc r9                     ; i++
    jmp loop_rsa_encrypt       ; przejd� do nast�pnej iteracji

end_rsa_encrypt:
    ret
RSAEncryptInner ENDP

END

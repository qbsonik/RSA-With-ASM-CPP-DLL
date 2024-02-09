.CODE

; Deklaracja procedury RSAEncrypt
RSAEncrypt PROC
    ; Argumenty funkcji:
    ; RCX - wskaŸnik do danych wejœciowych
    ; RDX - d³ugoœæ danych wejœciowych
    ; R8 - wskaŸnik do bufora na dane wyjœciowe
    ; R9 - wskaŸnik do zmiennej przechowuj¹cej d³ugoœæ danych wyjœciowych (przekazanej przez referencjê)
    ; R10 - wskaŸnik na wartoœæ n

    ; Wywo³anie procedury generuj¹cej klucze RSA
    call generateRSAKeys

    ; Sprawdzenie, czy d³ugoœæ danych jest podzielna przez 16 bajtów
    mov rax, rdx                ; Skopiowanie d³ugoœci danych do rax
    and rax, 15                 ; RDX modulo 16 (16 bajtów)

    ; Zainicjalizowanie i przygotowanie do pêtli
    mov r11, 0                  ; Inicjalizacja indeksu startowego
    mov r10, rcx                ; Przypisanie wskaŸnika na wartoœæ n do r10
    mov rdx, [r10]              ; Przypisanie d³ugoœci danych wejœciowych do rdx
    add r10, 8                  ; Przesuniêcie wskaŸnika na wartoœæ n

    ; Wczytanie danych wejœciowych do xmm0
    movdqu xmm0, [rcx]          ; Wczytanie danych wejœciowych do xmm0

    ; Obliczenie d³ugoœci przetwarzanego zakresu
    shr rdx, 4                  ; Podzielenie d³ugoœci danych przez 16 (rozm. bloku w bajtach)
    mov rdi, rdx                ; Przeniesienie d³ugoœci danych do rdi

    ; Inicjalizacja licznika bloków
    xor r12, r12                ; Zerowanie r12 (licznik bloków)

RSAEncrypt_Loop:
    ; Sprawdzenie warunku zakoñczenia pêtli
    test rdi, rdi               ; Sprawdzenie czy rdi jest zerowe
    jz RSAEncrypt_EndLoop       ; Jeœli tak, zakoñcz pêtlê

    ; Tutaj bêdzie kod szyfrowania RSA z wykorzystaniem instrukcji SSE

    ; Szyfrowanie danych
    call encryptData            ; Wywo³anie funkcji szyfruj¹cej dane

    ; Zapis przetworzonych danych do bufora wyjœciowego
    movdqu [r8], xmm0           ; Zapis danych do bufora
    add r8, 16                  ; Przesuniêcie wskaŸnika bufora
    inc r11                     ; Inkrementacja indeksu
    dec rdi                     ; Dekrementacja licznika pêtli
    jmp RSAEncrypt_Loop         ; Powrót do pocz¹tku pêtli

RSAEncrypt_EndLoop:
    ; Zapisanie d³ugoœci danych wyjœciowych przez referencjê
    mov qword ptr [r9], r11     ; Zapisanie d³ugoœci danych do zmiennej przez referencjê

    ret                         ; Zakoñczenie procedury

RSAEncrypt ENDP

; Funkcja generuj¹ca klucze RSA
generateRSAKeys PROC
    ; Generowanie kluczy RSA

    ; W prawdziwym kodzie RSA, te wartoœci by³yby wygenerowane losowo
    mov eax, 61                 ; p = 61
    mov ebx, 73                 ; q = 73
    mul ebx                     ; n = p * q
    mov ecx, eax                ; zapisanie wyniku do ecx (n)
    sub eax, 1                  ; p - 1
    sub ebx, 1                  ; q - 1
    imul eax, ebx               ; phi = (p - 1) * (q - 1)

    ; Wybierz e tak, aby 1 < e < phi(n) i gcd(e, phi(n)) = 1
    mov edx, 2                  ; e = 2
gcd_loop:
    xor eax, eax                ; Wyzeruj resztê
    div ecx                     ; edx:eax / ecx = eax (reszta w edx)
    test edx, edx               ; Czy reszta = 0?
    jz gcd_loop_end             ; Jeœli tak, przejdŸ do koñca pêtli
    inc eax                     ; Inkrementuj e
    cmp eax, ecx                ; Czy e >= phi(n)?
    jge gcd_loop_end            ; Jeœli tak, zakoñcz pêtlê
    mov eax, 1                  ; Zresetuj eax dla kolejnego dzielenia
    jmp gcd_loop                ; Powrót do pêtli
gcd_loop_end:
    mov [RSA_p], dword ptr eax  ; zapisz p do RSA_p
    mov [RSA_q], dword ptr ebx  ; zapisz q do RSA_q
    mov [RSA_n], dword ptr ecx  ; zapisz n do RSA_n
    mov [RSA_e], dword ptr eax  ; zapisz e do RSA_e

    ; Wybierz d tak, aby (d * e) % phi(n) = 1
    mov eax, 2                  ; d = 2
mod_loop:
    imul eax, dword ptr edx    ; eax = eax * e
    xor ebx, ebx                ; Wyzeruj resztê
    div ecx                     ; edx:eax / ecx = eax (reszta w edx)
    cmp edx, 1                  ; Czy reszta = 1?
    jne mod_loop                ; Jeœli nie, kontynuuj pêtlê
    mov [RSA_d], dword ptr eax  ; zapisz d do RSA_d

    ret                         ; Zakoñczenie procedury

generateRSAKeys ENDP

; Funkcja szyfruj¹ca dane
encryptData PROC
    ; Szyfrowanie danych

    ; Ustaw wskaŸnik na pocz¹tek danych wejœciowych
    mov rdi, rcx                 ; Przypisanie wskaŸnika na dane wejœciowe do rdi

    movzx ecx, byte ptr [rdi]   ; Wczytaj pojedynczy bajt danych wejœciowych do ecx

    mov eax, [RSA_e]            ; e
    mov ebx, [RSA_n]            ; n
    call powermod               ; wywo³aj funkcjê powermod
    movd xmm1, eax              ; zapisz wynik do xmm1

    ; Dodaj wynik szyfrowania do danych wejœciowych
    movdqu xmm2, [rdi]          ; wczytaj dane wejœciowe do xmm2
    paddd xmm2, xmm1            ; dodaj wynik szyfrowania do danych wejœciowych

    ; Zapisz zaszyfrowane dane w innym buforze
    movdqu [r8], xmm2           ; zapisz zaszyfrowane dane w innym buforze

    ret                          ; Zakoñczenie procedury

encryptData ENDP


; Funkcja obliczaj¹ca potêgê modulo
powermod PROC
    ; Obliczanie potêgi modulo

    mov edi, ecx                ; Przypisanie podstawy do edi
    mov ecx, eax                ; Przypisanie wyk³adnika do ecx
    mov eax, 1                  ; Ustawienie wyniku na 1

powermod_loop:
    test ecx, 1                 ; Sprawdzenie czy wyk³adnik jest nieparzysty
    jz powermod_skip            ; Jeœli nie, przejdŸ do powermod_skip

    imul eax, edi               ; Mno¿enie wyniku przez podstawê
    mov ecx, 1                  ; Ustawienie ecx na 1 (¿eby wyjœæ z pêtli)

powermod_skip:
    imul edi, edi               ; Podniesienie podstawy do kwadratu
    shr ecx, 1                  ; Przesuniêcie wyk³adnika w prawo (dzielenie przez 2)
    jnz powermod_loop           ; Jeœli wyk³adnik nie jest równy 0, kontynuuj pêtlê

    ret                         ; Zakoñczenie procedury

powermod ENDP

.DATA
RSA_p DD ?
RSA_q DD ?
RSA_n DD ?
RSA_e DD ?
RSA_d DD ?

END

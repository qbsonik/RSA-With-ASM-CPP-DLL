.CODE

; Deklaracja procedury RSAEncrypt
RSAEncrypt PROC
    ; Argumenty funkcji:
    ; RCX - wska�nik do danych wej�ciowych
    ; RDX - d�ugo�� danych wej�ciowych
    ; R8 - wska�nik do bufora na dane wyj�ciowe
    ; R9 - wska�nik do zmiennej przechowuj�cej d�ugo�� danych wyj�ciowych (przekazanej przez referencj�)
    ; R10 - wska�nik na warto�� n

    ; Wywo�anie procedury generuj�cej klucze RSA
    call generateRSAKeys

    ; Sprawdzenie, czy d�ugo�� danych jest podzielna przez 16 bajt�w
    mov rax, rdx                ; Skopiowanie d�ugo�ci danych do rax
    and rax, 15                 ; RDX modulo 16 (16 bajt�w)

    ; Zainicjalizowanie i przygotowanie do p�tli
    mov r11, 0                  ; Inicjalizacja indeksu startowego
    mov r10, rcx                ; Przypisanie wska�nika na warto�� n do r10
    mov rdx, [r10]              ; Przypisanie d�ugo�ci danych wej�ciowych do rdx
    add r10, 8                  ; Przesuni�cie wska�nika na warto�� n

    ; Wczytanie danych wej�ciowych do xmm0
    movdqu xmm0, [rcx]          ; Wczytanie danych wej�ciowych do xmm0

    ; Obliczenie d�ugo�ci przetwarzanego zakresu
    shr rdx, 4                  ; Podzielenie d�ugo�ci danych przez 16 (rozm. bloku w bajtach)
    mov rdi, rdx                ; Przeniesienie d�ugo�ci danych do rdi

    ; Inicjalizacja licznika blok�w
    xor r12, r12                ; Zerowanie r12 (licznik blok�w)

RSAEncrypt_Loop:
    ; Sprawdzenie warunku zako�czenia p�tli
    test rdi, rdi               ; Sprawdzenie czy rdi jest zerowe
    jz RSAEncrypt_EndLoop       ; Je�li tak, zako�cz p�tl�

    ; Tutaj b�dzie kod szyfrowania RSA z wykorzystaniem instrukcji SSE

    ; Szyfrowanie danych
    call encryptData            ; Wywo�anie funkcji szyfruj�cej dane

    ; Zapis przetworzonych danych do bufora wyj�ciowego
    movdqu [r8], xmm0           ; Zapis danych do bufora
    add r8, 16                  ; Przesuni�cie wska�nika bufora
    inc r11                     ; Inkrementacja indeksu
    dec rdi                     ; Dekrementacja licznika p�tli
    jmp RSAEncrypt_Loop         ; Powr�t do pocz�tku p�tli

RSAEncrypt_EndLoop:
    ; Zapisanie d�ugo�ci danych wyj�ciowych przez referencj�
    mov qword ptr [r9], r11     ; Zapisanie d�ugo�ci danych do zmiennej przez referencj�

    ret                         ; Zako�czenie procedury

RSAEncrypt ENDP

; Funkcja generuj�ca klucze RSA
generateRSAKeys PROC
    ; Generowanie kluczy RSA

    ; W prawdziwym kodzie RSA, te warto�ci by�yby wygenerowane losowo
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
    xor eax, eax                ; Wyzeruj reszt�
    div ecx                     ; edx:eax / ecx = eax (reszta w edx)
    test edx, edx               ; Czy reszta = 0?
    jz gcd_loop_end             ; Je�li tak, przejd� do ko�ca p�tli
    inc eax                     ; Inkrementuj e
    cmp eax, ecx                ; Czy e >= phi(n)?
    jge gcd_loop_end            ; Je�li tak, zako�cz p�tl�
    mov eax, 1                  ; Zresetuj eax dla kolejnego dzielenia
    jmp gcd_loop                ; Powr�t do p�tli
gcd_loop_end:
    mov [RSA_p], dword ptr eax  ; zapisz p do RSA_p
    mov [RSA_q], dword ptr ebx  ; zapisz q do RSA_q
    mov [RSA_n], dword ptr ecx  ; zapisz n do RSA_n
    mov [RSA_e], dword ptr eax  ; zapisz e do RSA_e

    ; Wybierz d tak, aby (d * e) % phi(n) = 1
    mov eax, 2                  ; d = 2
mod_loop:
    imul eax, dword ptr edx    ; eax = eax * e
    xor ebx, ebx                ; Wyzeruj reszt�
    div ecx                     ; edx:eax / ecx = eax (reszta w edx)
    cmp edx, 1                  ; Czy reszta = 1?
    jne mod_loop                ; Je�li nie, kontynuuj p�tl�
    mov [RSA_d], dword ptr eax  ; zapisz d do RSA_d

    ret                         ; Zako�czenie procedury

generateRSAKeys ENDP

; Funkcja szyfruj�ca dane
encryptData PROC
    ; Szyfrowanie danych

    ; Ustaw wska�nik na pocz�tek danych wej�ciowych
    mov rdi, rcx                 ; Przypisanie wska�nika na dane wej�ciowe do rdi

    movzx ecx, byte ptr [rdi]   ; Wczytaj pojedynczy bajt danych wej�ciowych do ecx

    mov eax, [RSA_e]            ; e
    mov ebx, [RSA_n]            ; n
    call powermod               ; wywo�aj funkcj� powermod
    movd xmm1, eax              ; zapisz wynik do xmm1

    ; Dodaj wynik szyfrowania do danych wej�ciowych
    movdqu xmm2, [rdi]          ; wczytaj dane wej�ciowe do xmm2
    paddd xmm2, xmm1            ; dodaj wynik szyfrowania do danych wej�ciowych

    ; Zapisz zaszyfrowane dane w innym buforze
    movdqu [r8], xmm2           ; zapisz zaszyfrowane dane w innym buforze

    ret                          ; Zako�czenie procedury

encryptData ENDP


; Funkcja obliczaj�ca pot�g� modulo
powermod PROC
    ; Obliczanie pot�gi modulo

    mov edi, ecx                ; Przypisanie podstawy do edi
    mov ecx, eax                ; Przypisanie wyk�adnika do ecx
    mov eax, 1                  ; Ustawienie wyniku na 1

powermod_loop:
    test ecx, 1                 ; Sprawdzenie czy wyk�adnik jest nieparzysty
    jz powermod_skip            ; Je�li nie, przejd� do powermod_skip

    imul eax, edi               ; Mno�enie wyniku przez podstaw�
    mov ecx, 1                  ; Ustawienie ecx na 1 (�eby wyj�� z p�tli)

powermod_skip:
    imul edi, edi               ; Podniesienie podstawy do kwadratu
    shr ecx, 1                  ; Przesuni�cie wyk�adnika w prawo (dzielenie przez 2)
    jnz powermod_loop           ; Je�li wyk�adnik nie jest r�wny 0, kontynuuj p�tl�

    ret                         ; Zako�czenie procedury

powermod ENDP

.DATA
RSA_p DD ?
RSA_q DD ?
RSA_n DD ?
RSA_e DD ?
RSA_d DD ?

END

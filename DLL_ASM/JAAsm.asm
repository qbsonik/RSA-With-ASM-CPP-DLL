option casemap:none

.data
p           real4   3.0
q           real4   7.0
e           real4   2.0
n           real4   ?
totient     real4   ?
d           real4   ?
k           real4   2.0
msg         real4   12.0

.data?
count       real4   ?
c           real4   ?
m           real4   ?
i           dd      ?

.code
RSAEncrypt proc input:DWORD, inputLength:DWORD, output:DWORD, outputLength:DWORD

    ; Calculate n and totient
    fld p
    fld q
    fmul
    fstp n
    fld1
    fld p
    fsub
    fld1
    fld q
    fsub
    fmul
    fstp totient
    
    ; Find suitable e
    fldz
    fstp e
FindE:
    fld e
    fld totient
    call gcd
    fstp count
    fcomp
    fstsw ax
    sahf
    jz FoundE
    fld e
    fadd
    fstp e
    jmp FindE
FoundE:

    ; Calculate d
    fld1
    fld k
    fld totient
    fmul
    fadd
    fld e
    fdiv
    fstp d

    ; Encrypt message
    fld msg
    fld e
    fyl2x
    f2xm1
    fld1
    fadd
    fstp c
    fld c
    fld d
    fyl2x
    f2xm1
    fld1
    fadd
    fstp m
    fld n
    fprem
    fstp c
    fld n
    fprem
    fstp m

    ; Encrypt input
    mov ecx, inputLength
    mov esi, input
    mov edi, output
EncryptLoop:
    cmp ecx, 0                 ; Sprawd�, czy sko�czyli�my przetwarza� wszystkie bajty
    je Done                    ; Je�li tak, zako�cz
    movzx eax, byte ptr [esi]  ; Wczytaj bajt z wej�cia
    mov byte ptr [edi], al     ; Zapisz go do bufora wyj�ciowego
    inc esi                    ; Przejd� do nast�pnego bajtu wej�cia
    inc edi                    ; Przejd� do nast�pnego bajtu wyj�cia
    loop EncryptLoop           ; Powt�rz, je�li jeszcze nie przetworzyli�my wszystkich bajt�w
Done:
    mov eax, inputLength       ; Przenie� warto�� inputLength do rejestru EAX
    mov edi, outputLength      ; Za�aduj adres outputLength do rejestru EDI
    mov [edi], eax             ; Przypisz warto�� rejestru EAX do outputLength

    ret
RSAEncrypt endp

power proc a:DWORD, b:DWORD, P:DWORD

    mov eax, 1                 ; pocz�tkowa warto�� pot�gi
    mov ecx, b                 ; liczba powt�rze�
    mov edx, P                 ; modulo

PowerLoop:
    test ecx, 1                ; czy b jest nieparzyste?
    jz PowerLoopEnd            ; je�li nie, przejd� do ko�ca p�tli
    mul a                      ; je�li tak, pomn� a przez wynik
    div edx                    ; wykonaj dzielenie modulo
PowerLoopEnd:
    mov eax, edx               ; wynik przechowywany w EAX
    ret

power endp

gcd proc a:DWORD, b:DWORD

    cmp a, 0
    jnz NotZeroA
    mov eax, b
    ret
NotZeroA:
    cmp b, 0
    jnz NotZeroB
    mov eax, a
    ret
NotZeroB:
    mov edx, a
    xor eax, eax
GcdLoop:
    xor edx, edx
    div b
    test edx, edx
    jz FoundGcd
    xchg eax, b
    jmp GcdLoop
FoundGcd:
    ret

gcd endp

end

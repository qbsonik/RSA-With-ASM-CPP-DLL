.data

.const
n DWORD 4453
p DWORD 61
q DWORD 73
e DWORD 2137
d DWORD 1033

.code
; Funkcja powermod do obliczania potêgi modulo
powermod PROC input:DWORD

powermod ENDP

; Funkcja szyfruj¹ca
RSAEncrypt PROC input:PTR BYTE, inputLength:DWORD, output:PTR BYTE, outputLength:PTR DWORD



RSAEncrypt ENDP


end

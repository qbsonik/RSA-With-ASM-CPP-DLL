#include <windows.h>

// Funkcja do obliczania najwiêkszego wspólnego dzielnika (NWD)
int gcd(int a, int b) {
    if (b == 0)
        return a;
    return gcd(b, a % b);
}

// Funkcja do generowania kluczy RSA
void generateRSAKeys(int& e, int& d, int& n) {
    // W prawdziwym kodzie RSA, te wartoœci by³yby wygenerowane losowo
    int p = 61;
    int q = 73;
    n = p * q;
    int phi = (p - 1) * (q - 1);

    // Wybierz e tak, aby 1 < e < phi(n) i gcd(e, phi(n)) = 1
    for (int i = 2; i < phi; i++) {
        if (gcd(i, phi) == 1) {
            e = i;
            break;
        }
    }

    // Wybierz d tak, aby (d * e) % phi(n) = 1
    for (int i = 2; i < phi; i++) {
        if ((e * i) % phi == 1) {
            d = i;
            break;
        }
    }
}

// Funkcja do obliczania potêgi modulo
int powermod(int base, int exp, int modulus) {
    int result = 1;
    while (exp > 0) {
        if (exp & 1) result = (result * base) % modulus;
        base = (base * base) % modulus;
        exp >>= 1;
    }
    return result;
}

extern "C" __declspec(dllexport) void RSAEncrypt(byte * input, int inputLength, byte * output, int* outputLength)
{
    // Generuj klucze RSA
    int e, d, n;
    generateRSAKeys(e, d, n);

    // Szyfruj dane
    for (int i = 0; i < inputLength; i++)
    {
        output[i] += powermod(input[i], e, n);
    }

    *outputLength = inputLength;
}

extern "C" __declspec(dllexport) void RSADecrypt(byte * input, int inputLength, byte * output, int* outputLength)
{
    // Generuj klucze RSA
    int e, d, n;
    generateRSAKeys(e, d, n);

    // Odszyfruj dane
    for (int i = 0; i < inputLength; i++)
    {
        output[i] = powermod(input[i], d, n);
    }

    *outputLength = inputLength;
}

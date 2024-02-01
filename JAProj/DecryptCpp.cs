using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace JAProj
{
    internal class DecryptCpp
    {
        // Importuj funkcję z biblioteki DLL
        [DllImport(@"C:\Users\kuban\OneDrive\Pulpit\StudiaSEM5\JA\JAProj\JAProj\x64\Debug\DLL_CPP.dll")]
        private static extern void RSADecrypt(byte[] input, int inputLength, byte[] output, ref int outputLength);

        public void Decrypt(TextBox textToChange, TextBox textAfterChange)
        {
            try
            {
                // Pobierz dane do odszyfrowania z TextBoxa
                string encryptedText = textToChange.Text;
                byte[] inputBytes = Convert.FromBase64String(encryptedText); // Konwertuj zaszyfrowany tekst z formatu Base64 na bajty

                // Bufor na odszyfrowane dane
                byte[] decryptedBytes = new byte[inputBytes.Length];

                // Wywołaj funkcję z biblioteki DLL
                int decryptedLength = 0;
                RSADecrypt(inputBytes, inputBytes.Length, decryptedBytes, ref decryptedLength);

                // Przetwórz odszyfrowane dane (np. wyświetl lub zapisz)
                string decryptedText = Encoding.UTF32.GetString(decryptedBytes, 0, decryptedLength); // Konwertuj odszyfrowane bajty na tekst !!!!!! BŁĄD !!!!!!!

                // Wprowadź odszyfrowany tekst do TextBoxa o nazwie textAfterChange
                textAfterChange.Text = decryptedText;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Błąd podczas odszyfrowywania: " + ex.ToString());
            }
        }
    }
}

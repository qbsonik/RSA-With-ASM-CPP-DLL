using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;




namespace JAProj
{
    internal class EncryptAsm
    {
        // Importuj funkcję z biblioteki DLL
        [DllImport(@"C:\Users\kuban\OneDrive\Pulpit\StudiaSEM5\JA\JAProj\JAProj\x64\Debug\DLL_ASM.dll")]
        private static extern void RSAEncrypt(byte[] input, int inputLength, byte[] output, ref int outputLength);

        public void Encrypt(TextBox textToChange, TextBox textAfterChange, Label measuredTime)
        {
            try
            {
                // Rozpocznij mierzenie czasu wykonania
                Stopwatch stopwatch = new Stopwatch();
                stopwatch.Start();

                // Pobierz dane do zaszyfrowania z TextBoxa
                string plaintext = textToChange.Text;
                byte[] inputBytes = Encoding.ASCII.GetBytes(plaintext); 

                // Bufor na zaszyfrowane dane
                byte[] encryptedBytes = new byte[inputBytes.Length * 2]; // Zakładam, że zaszyfrowane dane nie będą większe niż oryginalne

                // Wywołaj funkcję z biblioteki DLL
                int encryptedLength = encryptedBytes.Length;
                RSAEncrypt(inputBytes, inputBytes.Length, encryptedBytes, ref encryptedLength);

                // Przetwórz zaszyfrowane dane (np. wyświetl lub zapisz)
                string encryptedText = Convert.ToBase64String(encryptedBytes, 0, encryptedLength);

                // Wprowadź zaszyfrowany tekst do TextBoxa o nazwie textAfterChange
                textAfterChange.Text = encryptedText;

                // Wyświetl zmierzony czas
                stopwatch.Stop();
                measuredTime.Text = stopwatch.Elapsed.TotalMilliseconds.ToString("F4") + " ms";

            }
            catch (Exception ex)
            {
                MessageBox.Show("Błąd podczas szyfrowania: " + ex.ToString());
            }
        }
    }
}

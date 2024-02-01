using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace JAProj
{
    public partial class RsaEncryptDecrypt : Form
    {
        private Stopwatch stopwatch;


        public RsaEncryptDecrypt()
        {
            InitializeComponent();
            stopwatch = new Stopwatch();
            // Ustawienie domyślnej liczby wątków.
            threadPick.Value = System.Environment.ProcessorCount;
            pickedThreads.Text = (threadPick.Value).ToString();
        }

        private void threadPick_Scroll(object sender, EventArgs e)
        {
            // Pobierz aktualną wartość z TrackBar
            int currentValue = threadPick.Value;

            // Aktualizuj Text etykiety na podstawie wartości TrackBar
            pickedThreads.Text = currentValue.ToString();
        }

        private void encryptText_Click(object sender, EventArgs e)
        {
            if (AppInCpp.Checked)
            {
                // Wywołaj metodę z klasy EncryptCpp
                EncryptCpp encryptCpp = new EncryptCpp();
                encryptCpp.Encrypt(textToChange, textAfterChange);
            }
            else if (AppInAsm.Checked)
            {
                // Wywołaj metodę z klasy EncryptAsm
                //EncryptAsm encryptAsm = new EncryptAsm();
                //encryptAsm.Encrypt();
            }
            else
            {
                // Obsłuż sytuację, gdy żaden RadioButton nie jest zaznaczony
                MessageBox.Show("Wybierz opcję języka: Cpp lub Asm.");
            }
        }

        private void decryptText_Click(object sender, EventArgs e)
        {
            if (AppInCpp.Checked)
            {
                // Wywołaj metodę z klasy EncryptCpp
                DecryptCpp decryptCpp = new DecryptCpp();
                decryptCpp.Decrypt(textToChange, textAfterChange);
            }
            else if (AppInAsm.Checked)
            {
                // Wywołaj metodę z klasy EncryptAsm
                //EncryptAsm encryptAsm = new EncryptAsm();
                //encryptAsm.Encrypt();
            }
            else
            {
                // Obsłuż sytuację, gdy żaden RadioButton nie jest zaznaczony
                MessageBox.Show("Wybierz opcję języka: Cpp lub Asm.");
            }
        }
    }
}

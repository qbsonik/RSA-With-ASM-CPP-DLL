using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace JAProj
{
    internal static class Program
    {
        /// <summary>
        /// Główny punkt wejścia dla aplikacji.
        /// </summary>
        [STAThread]

        //  [DllImport(@"C:\Users\kuban\OneDrive\Pulpit\StudiaSEM5\JA\JAProj\JAProj\x64\Debug\DLL_CPP.dll")]
        //  [DllImport(@"C:\Users\kuban\OneDrive\Pulpit\StudiaSEM5\JA\JAProj\JAProj\x64\Debug\DLL_ASM.dll")]
        

        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new RsaEncryptDecrypt());
        }
    }
}

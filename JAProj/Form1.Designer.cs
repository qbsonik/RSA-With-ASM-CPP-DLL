namespace JAProj
{
    partial class RsaEncryptDecrypt
    {
        /// <summary>
        /// Wymagana zmienna projektanta.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Wyczyść wszystkie używane zasoby.
        /// </summary>
        /// <param name="disposing">prawda, jeżeli zarządzane zasoby powinny zostać zlikwidowane; Fałsz w przeciwnym wypadku.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Kod generowany przez Projektanta formularzy systemu Windows

        /// <summary>
        /// Metoda wymagana do obsługi projektanta — nie należy modyfikować
        /// jej zawartości w edytorze kodu.
        /// </summary>
        private void InitializeComponent()
        {
            this.textToChange = new System.Windows.Forms.TextBox();
            this.textAfterChange = new System.Windows.Forms.TextBox();
            this.AppInCpp = new System.Windows.Forms.RadioButton();
            this.AppInAsm = new System.Windows.Forms.RadioButton();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.measuredTime = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.threadPick = new System.Windows.Forms.TrackBar();
            this.label4 = new System.Windows.Forms.Label();
            this.pickedThreads = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.encryptText = new System.Windows.Forms.Button();
            this.decryptText = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.threadPick)).BeginInit();
            this.SuspendLayout();
            // 
            // textToChange
            // 
            this.textToChange.HideSelection = false;
            this.textToChange.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.textToChange.Location = new System.Drawing.Point(100, 50);
            this.textToChange.Multiline = true;
            this.textToChange.Name = "textToChange";
            this.textToChange.Size = new System.Drawing.Size(432, 290);
            this.textToChange.TabIndex = 0;
            // 
            // textAfterChange
            // 
            this.textAfterChange.BackColor = System.Drawing.SystemColors.Window;
            this.textAfterChange.Location = new System.Drawing.Point(661, 50);
            this.textAfterChange.Multiline = true;
            this.textAfterChange.Name = "textAfterChange";
            this.textAfterChange.ReadOnly = true;
            this.textAfterChange.Size = new System.Drawing.Size(432, 290);
            this.textAfterChange.TabIndex = 1;
            // 
            // AppInCpp
            // 
            this.AppInCpp.AutoSize = true;
            this.AppInCpp.Location = new System.Drawing.Point(767, 472);
            this.AppInCpp.Name = "AppInCpp";
            this.AppInCpp.Size = new System.Drawing.Size(44, 17);
            this.AppInCpp.TabIndex = 2;
            this.AppInCpp.TabStop = true;
            this.AppInCpp.Text = "C++";
            this.AppInCpp.UseVisualStyleBackColor = true;
            // 
            // AppInAsm
            // 
            this.AppInAsm.AutoSize = true;
            this.AppInAsm.Location = new System.Drawing.Point(767, 515);
            this.AppInAsm.Name = "AppInAsm";
            this.AppInAsm.Size = new System.Drawing.Size(48, 17);
            this.AppInAsm.TabIndex = 3;
            this.AppInAsm.TabStop = true;
            this.AppInAsm.Text = "ASM";
            this.AppInAsm.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label1.Location = new System.Drawing.Point(711, 421);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(161, 29);
            this.label1.TabIndex = 4;
            this.label1.Text = "Wybór języka:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label2.Location = new System.Drawing.Point(864, 487);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(191, 29);
            this.label2.TabIndex = 5;
            this.label2.Text = "Czas wykonania:";
            // 
            // measuredTime
            // 
            this.measuredTime.AutoSize = true;
            this.measuredTime.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.measuredTime.Location = new System.Drawing.Point(1061, 487);
            this.measuredTime.Name = "measuredTime";
            this.measuredTime.Size = new System.Drawing.Size(31, 29);
            this.measuredTime.TabIndex = 6;
            this.measuredTime.Text = "...";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label3.Location = new System.Drawing.Point(1098, 487);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(45, 29);
            this.label3.TabIndex = 7;
            this.label3.Text = "ms";
            // 
            // threadPick
            // 
            this.threadPick.LargeChange = 1;
            this.threadPick.Location = new System.Drawing.Point(100, 487);
            this.threadPick.Maximum = 64;
            this.threadPick.Minimum = 1;
            this.threadPick.Name = "threadPick";
            this.threadPick.Size = new System.Drawing.Size(470, 45);
            this.threadPick.TabIndex = 8;
            this.threadPick.Value = 1;
            this.threadPick.Scroll += new System.EventHandler(this.threadPick_Scroll);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label4.Location = new System.Drawing.Point(95, 446);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(78, 29);
            this.label4.TabIndex = 9;
            this.label4.Text = "Wątki:";
            // 
            // pickedThreads
            // 
            this.pickedThreads.AutoSize = true;
            this.pickedThreads.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.pickedThreads.Location = new System.Drawing.Point(179, 446);
            this.pickedThreads.Name = "pickedThreads";
            this.pickedThreads.Size = new System.Drawing.Size(31, 29);
            this.pickedThreads.TabIndex = 10;
            this.pickedThreads.Text = "...";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label6.Location = new System.Drawing.Point(201, 23);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(209, 24);
            this.label6.TabIndex = 11;
            this.label6.Text = "Tekst do wprowadzenia";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.label7.Location = new System.Drawing.Point(801, 23);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(152, 24);
            this.label7.TabIndex = 12;
            this.label7.Text = "Tekst po zmianie";
            // 
            // encryptText
            // 
            this.encryptText.Location = new System.Drawing.Point(419, 363);
            this.encryptText.Name = "encryptText";
            this.encryptText.Size = new System.Drawing.Size(113, 34);
            this.encryptText.TabIndex = 13;
            this.encryptText.Text = "Szyfruj";
            this.encryptText.UseVisualStyleBackColor = true;
            this.encryptText.Click += new System.EventHandler(this.encryptText_Click);
            // 
            // decryptText
            // 
            this.decryptText.Location = new System.Drawing.Point(661, 363);
            this.decryptText.Name = "decryptText";
            this.decryptText.Size = new System.Drawing.Size(113, 34);
            this.decryptText.TabIndex = 14;
            this.decryptText.Text = "Odszyfruj";
            this.decryptText.UseVisualStyleBackColor = true;
            this.decryptText.Click += new System.EventHandler(this.decryptText_Click);
            // 
            // RsaEncryptDecrypt
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1197, 596);
            this.Controls.Add(this.decryptText);
            this.Controls.Add(this.encryptText);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.pickedThreads);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.threadPick);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.measuredTime);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.AppInAsm);
            this.Controls.Add(this.AppInCpp);
            this.Controls.Add(this.textAfterChange);
            this.Controls.Add(this.textToChange);
            this.Name = "RsaEncryptDecrypt";
            this.Text = "RsaEncryptDecrypt";
            ((System.ComponentModel.ISupportInitialize)(this.threadPick)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textToChange;
        private System.Windows.Forms.TextBox textAfterChange;
        private System.Windows.Forms.RadioButton AppInCpp;
        private System.Windows.Forms.RadioButton AppInAsm;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label measuredTime;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TrackBar threadPick;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label pickedThreads;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button encryptText;
        private System.Windows.Forms.Button decryptText;
    }
}


// GraphControl Server
// - Program.cs
// Author: 
//   Jeff Hansen <jeff@jeffijoe.com>
// Copyright (C) 2015. All rights reserved.

using System;
using System.Windows.Forms;

namespace GraphControl.Windows
{
    /// <summary>
    /// The program.
    /// </summary>
    internal static class Program
    {
        #region Methods

        /// <summary>
        ///     The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new FrmMain());
        }

        #endregion
    }
}
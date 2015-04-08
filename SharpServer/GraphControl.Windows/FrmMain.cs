// GraphControl Server
// - FrmMain.cs
// Author: 
//   Jeff Hansen <jeff@jeffijoe.com>
// Copyright (C) 2015. All rights reserved.

using System;
using System.Windows.Forms;

using GraphControl.Server;

namespace GraphControl.Windows
{
    /// <summary>
    ///     The frm main.
    /// </summary>
    public partial class FrmMain : Form
    {
        #region Fields

        /// <summary>
        ///     The server.
        /// </summary>
        private GraphServer server;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        ///     Initializes a new instance of the <see cref="FrmMain" /> class.
        /// </summary>
        public FrmMain()
        {
            this.InitializeComponent();

            this.server = new GraphServer();
            this.server.Start();
        }

        #endregion

        #region Methods

        /// <summary>
        /// Handles the FormClosing event of the FrmMain control.
        /// </summary>
        /// <param name="sender">
        /// The source of the event.
        /// </param>
        /// <param name="e">
        /// The <see cref="FormClosingEventArgs"/> instance containing the event data.
        /// </param>
        private void FrmMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.server.Stop();
        }

        /// <summary>
        /// The tb value_ value changed.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void tbValue_ValueChanged(object sender, EventArgs e)
        {
            var value = (float)this.tbValue.Value / 10;
            this.server.Value = value;
        }

        #endregion
    }
}
// GraphControl Server
// - Program.cs
// Author: 
//   Jeff Hansen <jeff@jeffijoe.com>
// Copyright (C) 2015. All rights reserved.

using System;

using GraphControl.Server;

namespace GraphControl.CLI
{
    /// <summary>
    ///     The program.
    /// </summary>
    internal class Program
    {
        #region Methods

        /// <summary>
        /// The main.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        private static void Main(string[] args)
        {
            var server = new GraphServer();
            server.Start();
            Console.WriteLine("Listening... Press the Any Key to exit.");
            Console.ReadLine();
            server.Stop();
        }

        #endregion
    }
}
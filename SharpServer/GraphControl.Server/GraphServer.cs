// GraphControl Server
// - GraphServer.cs
// Author: 
//   Jeff Hansen <jeff@jeffijoe.com>
// Copyright (C) 2015. All rights reserved.

using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;

namespace GraphControl.Server
{
    /// <summary>
    ///     The graph server.
    /// </summary>
    public class GraphServer
    {
        #region Fields

        /// <summary>
        ///     The tcp.
        /// </summary>
        private readonly TcpListener tcp;

        /// <summary>
        ///     The last value, used to make sure we dont send the same value again and again.
        /// </summary>
        private float lastValue;

        /// <summary>
        ///     The token.
        /// </summary>
        private CancellationTokenSource token;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        ///     Initializes a new instance of the <see cref="GraphServer" /> class.
        /// </summary>
        public GraphServer()
        {
            var addr = IPAddress.Any;
            this.tcp = new TcpListener(new IPEndPoint(addr, 5005));
        }

        #endregion

        #region Public Properties

        /// <summary>
        ///     Gets or sets the value.
        /// </summary>
        /// <value>
        ///     The value.
        /// </value>
        public float Value { get; set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>
        ///     Starts this instance.
        /// </summary>
        public void Start()
        {
            this.tcp.Start();
            this.token = new CancellationTokenSource();
            Task.Run(() => this.Receive(), this.token.Token);
        }

        /// <summary>
        ///     Stops this instance.
        /// </summary>
        public void Stop()
        {
            this.token.Cancel(false);
            this.tcp.Stop();
        }

        #endregion

        #region Methods

        /// <summary>
        ///     Receives data.
        /// </summary>
        private void Receive()
        {
            try
            {
                while (!this.token.IsCancellationRequested)
                {
                    var client = this.tcp.AcceptTcpClient();
                    while (client.Connected)
                    {
                        if (Math.Abs(this.lastValue - this.Value) < 1)
                        {
                            Thread.Sleep(5);
                            continue;
                        }

                        this.lastValue = this.Value;
                        var buf = BitConverter.GetBytes(this.Value);
                        var stream = client.GetStream();

                        if (!client.Connected)
                        {
                            break;
                        }

                        stream.Write(buf, 0, buf.Length);
                        Thread.Sleep(10);
                    }
                }
            }
            catch (SocketException)
            {
            }
            finally
            {
                if (!this.token.IsCancellationRequested)
                {
                    this.Receive();
                }
            }
        }

        #endregion
    }
}
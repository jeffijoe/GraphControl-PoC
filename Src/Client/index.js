/**
 * Graph TCP Client, and webserver.
 */
var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var graphClient = require('./client.js');
var ip = process.argv[2] || '127.0.0.1';

// Serve static files
app.use(express.static("public"));

// Index route, show the index.html file.
app.get('/', function(req, res){
  res.sendFile(__dirname  + '/index.html');
});

// Start the webserver.
http.listen(3000, function(){
  console.log('listening on *:3000');
});

// Start the Graph client. Values are pushed from the server to this instance,
// and we're sending it down the wire to the webbrowser.
graphClient.start(ip, function (value) {
  io.emit('data', {
    value: value
  });
});
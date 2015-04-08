var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var graphClient = require('./client.js');

app.use(express.static("public"));

app.get('/', function(req, res){
  res.sendFile(__dirname  + '/index.html');
});

io.on('connection', function(socket){
  console.log('a user connected');
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});

graphClient.start(function (value) {
  io.emit('data', {
    value: value
  });
});

// // Simulation
// var number = 0;
// var direction = 0;
// var INCREASING = 1;
// var DECREASING = 2;
// var GROWTH = 2.5;
// setInterval(function () {
//   if(number <= 0)
//     direction = INCREASING;
//   else if(number >= 255)
//     direction = DECREASING;
  
//   if(direction == INCREASING) {
//     number += GROWTH;
//   } else if(direction == DECREASING) {
//     number -= GROWTH;
//   }

//   io.emit('data', {
//     value: number
//   });
// }, 30);
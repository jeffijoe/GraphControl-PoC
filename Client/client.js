var net = require('net');
var PORT = 5005;
var IP = '127.0.0.1';

module.exports = {
  start: function(cb) {
    var client = new net.Socket();

    client.on('data', function(data) {
      var value = data.readFloatLE();
      console.log('Received from GraphServer: ' + value);
      cb(value);
    });

    client.on('close', function() {
      console.log('Connection with GraphServer closed');
    });
    client.connect(PORT, IP, function() {
      console.log('Connected to GraphServer.');
    });
  }
}

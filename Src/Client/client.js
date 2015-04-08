var net = require('net');
var PORT = 5005;

/**
 * Graph Client
 */
module.exports = {
  /**
   * Starts the client and connects. The cb is invoked when a value is received.
   */
  start: function(ip, cb) {
    var client = new net.Socket();

    client.on('data', function(data) {
      var value = data.readFloatLE();
      console.log('Received from GraphServer: ' + value);
      cb(value);
    });

    client.on('close', function() {
      console.log('Connection with GraphServer closed');
    });
    
    console.log('Connecting to GraphServer @ ', ip, ':', PORT);

    client.connect(PORT, ip, function() {
      console.log('Connected to GraphServer.');
    });
  }
}

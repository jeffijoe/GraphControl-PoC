# Graph Control Client

The Client consists of a Node.js TCP client, that also acts as a webserver
pushing the data from the PIC client to the webbrowser.

Webserver running on port 3000. TCP client connecting to port 5005 on localhost.

## Usage

```
node index [ip]
```

Where `ip` is an IP address. Default is `127.0.0.1`.

## Authors

* *Jeff Hansen
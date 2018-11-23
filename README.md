# NWChat
A highly incomplete chat app written in Swift using Network.framework (client) and Swift NIO (server-side)
No 3-rd party libs used, this is a prototype of how chat funtionality is implemented using TCP sockets.

Disclaimer: might contain severe bugs (and the UI sucks) ;]

## Run this thing:

1. clone/download repo

2. Fetch dependencies and generate project:kidding
cd <…/NIOServer>
swift package generate-xcodeproj

3. Run server
$ cd <…/NIOServer/Sources>
$ open TCPServer.xcodeproj
build and run ('command + R' or from terminal: ‘$ swift run TCPServer’)

Note: in case you want to kill the process blocking your port:
$ lsof -t -i tcp:<port> | xargs kill (or '$ sudo lsof -t -i tcp: <port> | xargs kill')

4. Run client:
$ cd <…/Client>
$ open NetworkFrameworkResearch.xcodeproj

Command + R, fill host/port of the server

Run multiple simulators (ex. 7, 7Plus, 8)

Profit!

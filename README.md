# NWChat

A highly incomplete chat app written in Swift using Network.framework & Streams (client-side) and Swift NIO (server-side) <br/>
No 3-rd party libs used, this is a prototype of how chat funtionality is implemented using stream sockets. <br/>

![alt text](https://github.com/oleh-zayats/NWChat/blob/master/Screenshots/chat_screenshot.png)

## Run this thing:

1. Clone/download repo

2. Fetch dependencies and generate project: <br/>
cd .../{project directory}/NIOServer <br/>
$ swift package generate-xcodeproj <br/>

3. Run server <br/>
$ cd .../{project directory}/NIOServer/Sources <br/>
$ open TCPServer.xcodeproj <br/>
build and run ('command + R' or from terminal: ‘$ swift run TCPServer’) <br/>

Note: in case you want to kill the process blocking your port: <br/>
$ lsof -t -i tcp:<port> | xargs kill (or '$ sudo lsof -t -i tcp: <port> | xargs kill')

4. Run client: <br/>
$ cd .../{project directory}/Client <br/>
$ open NetworkFrameworkResearch.xcodeproj <br/>
command + R, fill host/port of the server <br/>

Run multiple simulators (ex. 7, 7Plus, 8)

Profit!

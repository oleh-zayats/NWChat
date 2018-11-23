//
//  main.swift
//  TCPServer
//
//  Created by Oleh Zayats on 11/20/18.
//

import Foundation
import NIO

let chatPeerHandler = ChatPeerHandler()

// https://apple.github.io/swift-nio/docs/current/NIO/Classes/ServerBootstrap.html
let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

let serverBootstrap = ServerBootstrap(group: group)
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelInitializer { channel in
        channel.pipeline.add(handler: BackPressureHandler()).then { v in
            channel.pipeline.add(handler: chatPeerHandler)
        }
    }
    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1) // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
    .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

defer {
    try! group.syncShutdownGracefully()
}

let socket = try! { () -> Socket in
    return try serverBootstrap.bind(host: Configuration.host, port: Configuration.port).wait()
}()

guard let localAddress = socket.localAddress else { fatalError() }
print("Server started and listening on \(localAddress)")

try! socket.closeFuture.wait()
print("ChatServer closed")

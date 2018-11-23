//
//  ChatPeerHandler.swift
//  TCPServer
//
//  Created by Oleh Zayats on 11/20/18.
//

import Foundation
import NIO

/** A Channel is easiest thought of as a network socket.
 * But it can be anything that is capable of I/O operations such as read, write, connect, and bind.
 */
typealias Socket = Channel

final class ChatPeerHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let socketQueue = DispatchQueue(label: "com.SocketQueue")
    private var sockets: [ObjectIdentifier: Socket] = [:]
}

// MARK: - Channel Activity
extension ChatPeerHandler {
    func channelActive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        socketQueue.async {
            self.sockets[ObjectIdentifier(channel)] = channel
        }
        var buffer = channel.allocator.buffer(capacity: 64)
        buffer.write(string: "Welcome to the chat!")
        ctx.writeAndFlush(wrapOutboundOut(buffer), promise: nil)
    }
    
    func channelInactive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        socketQueue.async {
            if self.sockets.removeValue(forKey: ObjectIdentifier(channel)) != nil {
                let message = "User with address \(channel.remoteAddress?.description ?? "undefined") left chat"
                self.writeToAll(channels: self.sockets, allocator: channel.allocator, message: message)
            }
        }
    }
}

// MARK: - Channel Read & Write
extension ChatPeerHandler {
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let id = ObjectIdentifier(ctx.channel)
        var socketRead = unwrapInboundIn(data)
        var buffer = ctx.channel.allocator.buffer(capacity: socketRead.readableBytes + 64)
        buffer.write(buffer: &socketRead)
        handlePeerCommandIfPossible(&buffer)
        socketQueue.async {
            print("Did end reading, now broadcasting!")
            self.writeToAll(channels: self.sockets.filter { id != $0.key }, buffer: buffer)
        }
    }
    
    func handlePeerCommandIfPossible(_ buffer: inout ByteBuffer) {
        if let data = buffer.toData() {
            do {
                try decodeAndProcessCommandIfPossible(from: data, &buffer)
                try decodeAndBroadcastMessageIfPossible(from: data, &buffer)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription, "codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription, "codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription, "codingPath:", context.codingPath)
            } catch {
                print("Could not decode.\nData: \(data)\nError: \(error.localizedDescription)")
            }
        }
    }
    
    func decodeAndProcessCommandIfPossible(from data: Data, _ buffer: inout ByteBuffer) throws {
        let command = try self.decoder.decode(ChatCommand.self, from: data)
        switch command.name {
        case "join":
            let message = "\(command.params?["username"] ?? "Unknown dude") joined the chat"
            buffer.write(string: message)
        case "active":
            break
        default:
            break
        }
    }
    
    func decodeAndBroadcastMessageIfPossible(from data: Data, _ buffer: inout ByteBuffer) throws {
        let message = try self.decoder.decode(ChatMessage.self, from: data)
        // ...
        if let data = try? encoder.encode(message), let encoded = String(data: data, encoding: .utf8) {
            buffer.write(string: encoded)
        }
    }
    
    func writeToAll(channels: [ObjectIdentifier: Socket], allocator: ByteBufferAllocator, message: String) {
        var buffer = allocator.buffer(capacity: message.utf8.count)
        buffer.write(string: message)
        writeToAll(channels: channels, buffer: buffer)
    }
    
    func writeToAll(channels: [ObjectIdentifier: Socket], buffer: ByteBuffer) {
        channels.forEach { channel in
            channel.value.writeAndFlush(buffer, promise: nil)
        }
    }
}

// MARK: - Errors
extension ChatPeerHandler {
    func errorCaught(ctx: ChannelHandlerContext, error: Error) {
        print("Error: ", error)
        ctx.close(promise: nil)
    }
}

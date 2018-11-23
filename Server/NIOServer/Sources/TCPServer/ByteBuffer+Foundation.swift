//
//  ByteBuffer+Data.swift
//  TCPServer
//
//  Created by Oleh Zayats on 11/20/18.
//

import Foundation
import NIO

extension ByteBuffer {
    mutating func toData() -> Data? {
        guard let receivedBytes: [UInt8] = readBytes(length: readableBytes) else {
            return nil
        }
        let data = Data(bytes: receivedBytes, count: receivedBytes.count)
        return data
    }
}

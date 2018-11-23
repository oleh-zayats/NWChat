//
//  StreamClient.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation


/* Client implelmented using Foundation input/output streams */
final class StreamClient: NSObject, TransportClientProtocol, OSLogProviding {

    var didReceiveData: CallbackWith<Data> = noop
    var didEmitError: CallbackWith<Error> = noop
    
    // Using a pair on Stream classes allows to create a socket based
    // connection between your client app and the TCP server
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    private (set) var isConnected = false
    
    init(host: String, port: UInt) {
        // uninitialized socket streams, no ARC
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        // bind socket streams and connect them to the server's listening socket
        // host's IP + port
        CFStreamCreatePairWithSocketToHost(
            kCFAllocatorDefault,
            host as CFString,
            UInt32(port),
            &readStream,
            &writeStream
        )
        // simultaneously grab a retained reference
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        super.init()
        // add streams to run loop
        inputStream?.schedule(in: .main, forMode: .common)
        outputStream?.schedule(in: .main, forMode: .common)
        inputStream?.delegate = self
        outputStream?.delegate = self
    }
    
    deinit {
        assert(isConnected == false)
    }
    
    // MARK: - Public API
    func start(_ then: Callback) {
        guard isConnected == false else { return }
        inputStream?.open()
        outputStream?.open()
        isConnected = true
        then()
    }
    
    func stop() {
        inputStream?.close()
        outputStream?.close()
        isConnected = false
    }
    
    func send(data: Data) {
        _ = data.withUnsafeBytes { bytePointer in
            outputStream?.write(bytePointer, maxLength: data.count)
        }
    }
}

// MARK: - StreamDelegate
extension StreamClient: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            Log.shared.debug(log, value: .string("Stream.Event.openCompleted"))
        case Stream.Event.hasSpaceAvailable:
            Log.shared.debug(log, value: .string("Stream.Event.hasSpaceAvailable"))
        case Stream.Event.hasBytesAvailable:
            Log.shared.debug(log, value: .string("Stream.Event.hasBytesAvailable"))
            readBytesFrom(stream: aStream)
        case Stream.Event.endEncountered:
            Log.shared.warn(log, value: .string("Stream.Event.endEncountered"))
            stop()
        case Stream.Event.errorOccurred:
            Log.shared.error(log, value: .string("Stream.Event.errorOccurred"))
        default:
            break
        }
    }
}

// MARK: - Private API
private extension StreamClient {
    private func readBytesFrom(stream: Stream) {
        guard let stream = stream as? InputStream else {
            return
        }
        // allocate a buffer into which you we read incoming bytes
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Default.bufferSize)
        while stream.hasBytesAvailable {
            // read bytes from stream and put them into the buffer
            let receivedBytesCount = inputStream?.read(buffer, maxLength: Default.bufferSize) ?? 0
            if receivedBytesCount < 0 {
                if let _ = inputStream?.streamError {
                    break
                }
            }
            let data = Data(bytes: buffer, count: receivedBytesCount)
            didReceiveData(data)
        }
    }
}

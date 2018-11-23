//
//  NWConnectionClient.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Network
import Foundation

/* Client implelmented using Network.framework */
final class NWConnectionClient: TransportClientProtocol, OSLogProviding {

    var didReceiveData: CallbackWith<Data> = noop
    var didEmitError: CallbackWith<Error> = noop

    private let queue = DispatchQueue(label: "com.queue.TCPNWConnectionClient")
    private var connection: NWConnection?
    
    private (set) var isConnected = false
    
    init(host: String, port: UInt) {
        let parameters = NWParameters(tls: nil, tcp: NWProtocolTCP.Options())
        connection = NWConnection(
            to: .hostPort(host: NWEndpoint.Host(host), port: NWEndpoint.Port(rawValue: UInt16(port))!),
            using: parameters
        )
    }
    
    deinit {
        assert(isConnected == false)
    }
    
    func start(_ then: @escaping Callback) {
        guard isConnected == false else { return }
        connection?.start(queue: queue)
        connection?.stateUpdateHandler = { [weak self] state in
            self?.handleConnectionStateUpdate(state, onReadyCallback: then)
        }
        isConnected = true
        runReceiveLoop()
    }
    
    func stop() {
        connection?.cancel()
        isConnected = false
    }
    
    func send(data: Data) {
        connection?.send(content: data, completion: handleSendCompletedWithError)
    }
}

// MARK: - Private
private extension NWConnectionClient {
    func runReceiveLoop() {
        connection?.receive(
            minimumIncompleteLength: 1,
            maximumLength: Default.bufferSize,
            completion: { [weak self] data, context, isComplete, error in
                guard let self = self, let data = data else { return }
                if let error = error {
                    let debugDescription = (error as NWError).debugDescription
                    Log.shared.error(self.log, value: .string(debugDescription))
                    self.didEmitError(error)
                    return
                }
                if context == nil, error == nil, isComplete {
                    self.didEmitError(AnyError.unknown)
                    self.stop()
                    return
                }
                self.didReceiveData(data)
                self.runReceiveLoop()
        })
    }

    /** Handles connection state updates
     *  var stateUpdateHandler: ((NWConnection.State) -> Void)? { get set }
     */
    private func handleConnectionStateUpdate(_ state: NWConnection.State, onReadyCallback: Callback) {
        switch state {
        case .setup:
            Log.shared.debug(self.log, value: .string("Connection setup...(initial state)"))
        case .waiting(let error):
            Log.shared.warn(self.log, value: .string("Waiting...\(error.debugDescription)"))
        case .preparing:
            Log.shared.debug(self.log, value: .string("Preparing connections are actively establishing the connection..."))
        case .failed(let error):
            Log.shared.error(self.log, value: .string("Connection failed, \(error.debugDescription). Can no longer send or receive data"))
            isConnected = false
        case .cancelled:
            Log.shared.debug(self.log, value: .string("Connection cancelled, will send no more events"))
            isConnected = false
        case .ready:
            Log.shared.debug(self.log, value: .string("Ready to send and receive data"))
            onReadyCallback()
        }
    }
    
    /** Handles connection data transfer errors
     *  NWConnection.SendCompletion
     */
    private var handleSendCompletedWithError: NWConnection.SendCompletion {
        return .contentProcessed { error in
            if let error = error {
                Log.shared.error(self.log, verbose: true, value: .string(error.debugDescription))
            }
        }
    }
}

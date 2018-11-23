//
//  TransportClientFactory.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum TransportClientFactory {
    static func client(host: String, port: UInt) -> TransportClientProtocol {
        var client: TransportClientProtocol
        switch Configuration.clientType {
        case .streams:
            client = StreamClient(host: host, port: port)
        case .nwConnection:
            client = NWConnectionClient(host: host, port: port)
        }
        return client
    }
}

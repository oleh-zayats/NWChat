//
//  Configuration.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum Default {
    /* how much data can be sent in any single message */
    static let bufferSize: Int = 4096
}

enum Configuration {
    /* Server default configurations */
    static let host = "::1"
    static let port: UInt = 9898
    /* Transport implementation */
    enum TransportClientType {
        case streams
        case nwConnection
    }
    static let clientType: Configuration.TransportClientType = .nwConnection
}

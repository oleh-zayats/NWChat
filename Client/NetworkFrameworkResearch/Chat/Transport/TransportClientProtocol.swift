//
//  TransportClientProtocol.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

/* This interface describes what concrete client should implement in order to manage a TCP connection */
protocol TransportClientProtocol {
    init (host: String, port: UInt)
    /* Inputs */
    func start(_ then: @escaping Callback)
    func stop()
    func send(data: Data)
    /* Outputs */
    var isConnected: Bool { get }
    var didReceiveData: CallbackWith<Data> { get set }
    var didEmitError: CallbackWith<Error> { get set }
}

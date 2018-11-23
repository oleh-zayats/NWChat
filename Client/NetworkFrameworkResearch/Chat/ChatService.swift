//
//  ChatService.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

final class ChatService: OSLogProviding {

    // MARK: - Callbacks
    
    var didReceiveChatMessage: CallbackWith<ChatMessage> = noop
    var didReceivePlainText: CallbackWith<String> = noop
    var didEmitError: CallbackWith<Error> = noop
    
    // MARK: - Private Props
    
    private var transportClient: TransportClientProtocol
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var username: String?
    
    // MARK: - init
    
    init(transportClient: TransportClientProtocol) {
        self.transportClient = transportClient
        self.encoder.outputFormatting = .prettyPrinted
        self.setupCallbacks()
    }
    
    // MARK: - Public API
    
    func enterChat(withUsername username: String) {
        assert(!username.isEmpty)
        self.username = username
        transportClient.start { [weak self] in
            if let self = self {
                let joinCommand = ChatCommand.ofType(.join, ["username": username])
                if let data = self.encode(content: joinCommand) {
                    self.transportClient.send(data: data)
                }
            }
        }
    }
    
    func leaveChat() {
        transportClient.stop()
    }

    func sendText(_ text: String) {
        if let username = username {
            let message = ChatMessage(text: text, author: username, date: Date())
            if let data = encode(content: message) {
                transportClient.send(data: data)
            }
        }
    }
    
    // MARK: - Private API
    
    private func setupCallbacks() {
        transportClient.didReceiveData = { [weak self] data in
            guard let self = self else {
                return
            }
            if let chatMessage = try? self.decoder.decode(ChatMessage.self, from: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.didReceiveChatMessage(chatMessage)
                }
            } else if let text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async { [weak self] in
                    self?.didReceivePlainText(text)
                }
            } else {
                Log.shared.error(self.log, value: .string("Could not decode incoming data"))
            }
        }
        transportClient.didEmitError = { [weak self] error in
            self?.didEmitError(error)
        }
    }
    
    private func decode<T: Codable>(data: Data) throws -> T {
        let structure = try self.decoder.decode(T.self, from: data)
        return structure
    }
    
    private func encode<T: Encodable>(content: T) -> Data? {
        do {
            let data = try encoder.encode(content)
            return data
        } catch let error {
            didEmitError(error)
            return nil
        }
    }
}

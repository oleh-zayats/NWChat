//
//  ChatCommand.swift
//
//
//  Created by Oleh Zayats on 11/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

struct ChatCommand: Codable {
    let name: String?
    let params: [String: String]?
}

extension ChatCommand {
    enum `Type`: String {
        case active, join
    }
    static func ofType(_ type: ChatCommand.`Type`, _ params: [String: String]?) -> ChatCommand {
        return ChatCommand(name: type.rawValue, params: params)
    }
}

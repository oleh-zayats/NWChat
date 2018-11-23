//
//  ChatData.swift
//
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

struct ChatMessage: Codable {
    let text: String
    let author: String
    let date: Date?
}

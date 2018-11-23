//
//  ChatMessageTableViewCell+Components.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/23/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension ChatMessageTableViewCell {
    
    final class ChatMessageBodyLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: .init(top: 5, left: 15, bottom: 5, right: 15)))
        }
    }
    
    static func makeMessageBodyLabel() -> ChatMessageBodyLabel {
        let messageLabel = ChatMessageBodyLabel()
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        return messageLabel
    }
    
    static func makeMessageSenderLabel() -> UILabel {
        let senderNameLabel = UILabel()
        senderNameLabel.font = .systemFont(ofSize: ChatMessageTableViewCell.FontSize.author)
        senderNameLabel.textColor = .lightGray
        senderNameLabel.numberOfLines = 1
        return senderNameLabel
    }
}

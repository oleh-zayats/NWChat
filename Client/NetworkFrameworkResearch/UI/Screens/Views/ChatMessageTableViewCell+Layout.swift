//
//  ChatMessageTableViewCell+Layout.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension ChatMessageTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        switch layoutType {
        case .info:
            layoutInfoMessage()
        case .incoming:
            layoutUserMessage(incoming: true)
        case .outgoing:
            layoutUserMessage(incoming: false)
        }
        messageLabel.layer.cornerRadius = min(messageLabel.halfHeight, 20)
    }
    
    private func layoutInfoMessage() {
        let bestSize = messageLabel.sizeThatFits(ChatMessageTableViewCell.maxSize)
        messageLabel.frame = CGRect(x: 0, y: 0, width: bestSize.width + 32, height: bestSize.height + 16)
        messageLabel.center = centerPoint
        messageLabel.backgroundColor = MessageColor.informal
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: TextSize.author)
    }
    
    private func layoutUserMessage(incoming: Bool) {
        let bestSize = messageLabel.sizeThatFits(ChatMessageTableViewCell.maxSize)
        
        messageLabel.frame = CGRect(x: 0, y: 0, width: bestSize.width + 32, height: bestSize.height + 16)
        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: TextSize.message)
        
        if incoming {
            nameLabel.sizeToFit()
            nameLabel.isHidden = false
            nameLabel.center = CGPoint(x: nameLabel.halfWidth + 20, y: nameLabel.halfHeight + 4)
            
            messageLabel.backgroundColor = MessageColor.incoming
            messageLabel.textAlignment = .right
            messageLabel.center = CGPoint(x: messageLabel.halfWidth + 16, y: messageLabel.halfHeight + nameLabel.height + 8)
            
        } else {
            messageLabel.textAlignment = .left
            messageLabel.backgroundColor = MessageColor.outgoing
            messageLabel.center = CGPoint(x: width - messageLabel.halfWidth - 16, y: halfHeight)
            nameLabel.isHidden = true
        }
    }
}

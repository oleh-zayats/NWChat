//
//  ChatMessageTableViewCell.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class ChatMessageTableViewCell: UITableViewCell {
    
    private lazy var senderLabel = ChatMessageTableViewCell.makeMessageSenderLabel()
    private lazy var messageLabel = ChatMessageTableViewCell.makeMessageBodyLabel()
    private(set) var layout: ChatMessageTableViewCell.Layout = .outgoing

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        selectionStyle = .none
        addSubview(messageLabel)
        addSubview(senderLabel)
    }
    
    @discardableResult
    func configured(with chatMessage: ChatMessage, username: String) -> ChatMessageTableViewCell {
        layout = layout(fromMessage: chatMessage, username: username)
        senderLabel.text = chatMessage.author
        messageLabel.text = chatMessage.text
        layoutSubviews()
        return self
    }
    
    private func layout(fromMessage message: ChatMessage, username: String) -> ChatMessageTableViewCell.Layout {
        if message.author.isEmpty {
            return .info
        } else if message.author == username {
            return .outgoing
        } else {
            return .incoming
        }
    }
}

// MARK: - Layout
extension ChatMessageTableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch layout {
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
        messageLabel.frame = CGRect(x: 0, y: 0, width: bestSize.width + 30, height: bestSize.height + 15)
        messageLabel.center = centerPoint
        messageLabel.backgroundColor = BubbleColor.informal
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: FontSize.author)
    }
    
    private func layoutUserMessage(incoming: Bool) {
        let bestSize = messageLabel.sizeThatFits(ChatMessageTableViewCell.maxSize)
        
        messageLabel.frame = CGRect(x: 0, y: 0, width: bestSize.width + 30, height: bestSize.height + 15)
        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: FontSize.message)
        
        if incoming {
            senderLabel.sizeToFit()
            senderLabel.isHidden = false
            senderLabel.center = CGPoint(x: senderLabel.halfWidth + 20, y: senderLabel.halfHeight + 4)
            
            messageLabel.backgroundColor = BubbleColor.incoming
            messageLabel.textAlignment = .right
            messageLabel.center = CGPoint(x: messageLabel.halfWidth + 15, y: messageLabel.halfHeight + senderLabel.height + 6)
            
        } else {
            messageLabel.textAlignment = .left
            messageLabel.backgroundColor = BubbleColor.outgoing
            messageLabel.center = CGPoint(x: width - messageLabel.halfWidth - 15, y: halfHeight)
            senderLabel.isHidden = true
        }
    }
}

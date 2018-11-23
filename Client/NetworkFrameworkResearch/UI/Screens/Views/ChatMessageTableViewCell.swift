//
//  ChatMessageTableViewCell.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class ChatMessageTableViewCell: UITableViewCell {
    
    enum LayoutType {
        case info, incoming, outgoing
    }
    
    private (set) var layoutType: LayoutType = .outgoing

    enum TextSize {
        static let author: CGFloat = 10
        static let message: CGFloat = 17
    }
    
    enum MessageColor {
        static let outgoing = UIColor.iMessageBlue
        static let incoming = UIColor.lightGray
        static let informal = UIColor.darkGray
    }
    
    final class MessageLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: .init(top: 5, left: 15, bottom: 5, right: 15)))
        }
    }
    
    lazy var messageLabel: MessageLabel = {
        let label = MessageLabel()
        label.clipsToBounds = true
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: TextSize.author)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        selectionStyle = .none
        addSubview(messageLabel)
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func configured(with chatMessage: ChatMessage, username: String) -> ChatMessageTableViewCell {
        layoutType = layout(fromMessage: chatMessage, username: username)
        nameLabel.text = chatMessage.author
        messageLabel.text = chatMessage.text
        setNeedsLayout()
        return self
    }
    
    private func layout(fromMessage message: ChatMessage, username: String) -> ChatMessageTableViewCell.LayoutType {
        if message.author.isEmpty {
            return .info
        } else if message.author == username {
            return .outgoing
        } else {
            return .incoming
        }
    }
}

//
//  ChatMessageTableViewCell+Height.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension ChatMessageTableViewCell {
    static var maxSize: CGSize {
        let width = UIScreen.main.bounds.size.width * 0.75
        let height = CGFloat.greatestFiniteMagnitude
        return CGSize(width: width, height: height)
    }
    
    class func height(for message: ChatMessage, username: String) -> CGFloat {
        var nameHeight: CGFloat {
            if message.author != username {
                return (height(forText: username, fontSize: TextSize.author, maxSize: ChatMessageTableViewCell.maxSize) + 4)
            }
            return 0
        }
        var messageHeight: CGFloat {
            let text = message.text
            return height(forText: text, fontSize: TextSize.message, maxSize: ChatMessageTableViewCell.maxSize)
        }
        let total = nameHeight + messageHeight + 24
        return total
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                                                         NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
    }
}

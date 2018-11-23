//
//  ChatMessageCellElementsFactory.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/23/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension ChatMessageTableViewCell {
    
    enum Layout {
        case info
        case incoming
        case outgoing
    }
    
    enum FontSize {
        static let author: CGFloat = 10
        static let message: CGFloat = 16
    }
    
    enum BubbleColor {
        static let outgoing = UIColor.iMessageBlue
        static let incoming = UIColor.lightGray
        static let informal = UIColor.darkGray
    }
}

//
//  OSLogProviding.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import os
import Foundation

protocol OSLogProviding {
    var log: OSLog { get }
}

extension OSLogProviding {
    var log: OSLog {
        return OSLog(subsystem: Self.subsystem, category: classType)
    }
    static var subsystem: String {
        return Bundle.main.bundleIdentifier!
    }
    var classType: String {
        return String(describing: type(of: self))
    }
}

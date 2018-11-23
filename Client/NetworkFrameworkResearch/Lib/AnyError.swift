//
//  AnyError.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum AnyError: Swift.Error {
    case unknown
    case generic(String)
}

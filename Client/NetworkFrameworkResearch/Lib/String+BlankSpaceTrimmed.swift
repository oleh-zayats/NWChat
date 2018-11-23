//
//  String+BlankSpaceTrimmed.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

extension String {
    var blankSpaceTrimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

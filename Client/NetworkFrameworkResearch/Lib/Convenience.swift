//
//  Convenience.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

typealias Callback = () -> Void
var noop: Callback = {}

typealias CallbackWith<P> = (P) -> Void
func noop<P>(_ parameter: P) {}

typealias CallbackWithResult<P, R> = (P) -> R
func noop<P, R>(_ parameter: P) -> R? { return nil }

//
//  Log.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import os
import Foundation
import func Dispatch.__dispatch_queue_get_label

final class Log {
    static let shared = Log()
    
    private init() {}
    
    private lazy var isLoggingEnabled: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
    
    enum InfoValue {
        case none, string(String)
        var info: String? {
            switch self {
            case .none:
                return nil
            case .string(let string):
                return string
            }
        }
    }
    
    private enum VisualLogTypeLabel {
        static let debug   = "⚪️"
        static let success = "✅"
        static let warning = "⚠️"
        static let error   = "❌"
    }
    
    
    // MARK: - Log
    
    func debug(_ category: OSLog, verbose: Bool = false, file: String = #file, function: String = #function, line: Int32 = #line, value: InfoValue) {
        if isLoggingEnabled {
            if verbose {
                log_verbose(VisualLogTypeLabel.debug, category: category, file: file, function: function, line: line, passedInfo: value.info)
            } else {
                log_compact(VisualLogTypeLabel.debug, category: category, function: function, passedInfo: value.info)
            }
        }
    }
    
    func success(_ category: OSLog, verbose: Bool = false, file: String = #file, function: String = #function, line: Int32 = #line, value: InfoValue) {
        if isLoggingEnabled {
            if verbose {
                log_verbose(VisualLogTypeLabel.success, category: category, file: file, function: function, line: line, passedInfo: value.info)
            } else {
                log_compact(VisualLogTypeLabel.success, category: category, function: function, passedInfo: value.info)
            }
        }
    }
    
    func warn(_ category: OSLog, verbose: Bool = false, file: String = #file, function: String = #function, line: Int32 = #line, value: InfoValue) {
        if isLoggingEnabled {
            if verbose {
                log_verbose(VisualLogTypeLabel.warning, category: category, file: file, function: function, line: line, passedInfo: value.info)
            } else {
                log_compact(VisualLogTypeLabel.warning, category: category, function: function, passedInfo: value.info)
            }
        }
    }
    
    func error(_ category: OSLog, verbose: Bool = false, file: String = #file, function: String = #function, line: Int32 = #line, value: InfoValue) {
        if isLoggingEnabled {
            if verbose {
                log_verbose(VisualLogTypeLabel.error, category: category, file: file, function: function, line: line, callStackSymEnabled: false, passedInfo: value.info)
            } else {
                log_compact(VisualLogTypeLabel.error, category: category, function: function, passedInfo: value.info)
            }
        }
    }
    
    private func log_compact(_ typeLabel: String, category: OSLog, function: String, passedInfo: String?) {
        os_log(
            "%s",
            log: category,
            type: .debug,
            compactInfo(
                logTypeLabel: typeLabel,
                function: function,
                passedInfo: passedInfo
            )
        )
    }
    
    private func log_verbose(_ typeLabel: String, category: OSLog, file: String, function: String, line: Int32, callStackSymEnabled: Bool = false, passedInfo: String?) {
        os_log(
            "\n%s",
            log: category,
            type: .debug,
            verboseInfo(
                logTypeLabel: typeLabel,
                file: file,
                function: function,
                line: String(line),
                threadInfoEnabled: true,
                callStackSymEnabled: callStackSymEnabled,
                passedInfo: passedInfo
            )
        )
    }
    
    // MARK: - Formatting
    
    private func compactInfo(logTypeLabel: String, function: String, passedInfo: String?) -> String {
        var logInfo: String {
            if let value = passedInfo, !value.isEmpty {
                return "-> \(value)"
            }
            return ""
        }
        return """
        \(logTypeLabel) \(function) \(logInfo)
        """
    }
    
    private func verboseInfo(logTypeLabel: String, file: String, function: String, line: String, threadInfoEnabled: Bool, callStackSymEnabled: Bool, passedInfo: String?) -> String {
        var fileName: String {
            return URL(fileURLWithPath: file).lastPathComponent
        }
        var lineValue: String {
            if line.isEmpty {
                return ""
            }
            return ":\(line)"
        }
        var logInfo: String {
            if let value = passedInfo, !value.isEmpty {
                return "\n\n" + "-> \(value)"
            }
            return ""
        }
        var callStack: String {
            if callStackSymEnabled {
                return "\n" + Thread.callStackSymbols.joined(separator: "\n")
            }
            return ""
        }
        
        return """
        \(logTypeLabel)
        
        Function:       \(function)
        Location:       \(fileName)\(lineValue)
        Thread\\Queue:   \(executionThread)\(logInfo)\(callStack)
        ---------------------------------------------------------------------------
        """
    }
}

// MARK: - Utility

private var executionThread: String {
    if Thread.isMainThread {
        return "MainThread"
    } else {
        if let threadName = Thread.current.name, threadName.isEmpty == false {
            return"\(threadName)"
        } else if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), queueName.isEmpty == false {
            return"\(queueName)"
        } else {
            return String(format: "%p", Thread.current)
        }
    }
}

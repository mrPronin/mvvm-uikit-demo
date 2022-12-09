//
//  Logger.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

/// Wrapping Swift.print() within DEBUG flag
func print(_ object: Any) {
  // Only allowing in DEBUG mode
  #if DEBUG
      Swift.print(object)
  #endif
}

func LOG(_ object: Any? = nil, type: LogEventType = .debug, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    let logger = LoggerImplementation()
    logger.log(object, type: type, filename: filename, line: line, column: column, funcName: funcName)
}

// swiftlint:disable function_parameter_count
protocol Logger {
    func log(_ object: Any?, type: LogEventType, filename: String, line: Int, column: Int, funcName: String)
}

enum LogEventType: String {
    case debug = "[debug]" // debug
    case warning = "[warning]" // warning
    case error = "[error]" // error
}

struct LoggerImplementation: Logger {
    // MARK: - Public
    func log(_ object: Any? = nil, type: LogEventType = .debug, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        var message = "\(Self.stringFromDate(Date())) \(type.rawValue) [\(Self.sourceFileName(filePath: filename))]: \(line) \(column) \(funcName)"
        if let object = object {
            message += " -> \(object)"
        }
        #if DEBUG
            print(message)
        #else
        guard type != .debug else { return }
//            Crashlytics.crashlytics().log(message)
        #endif
    }
    // MARK: - Init
    init() {
        // if !DEBUG -> init crash log (Crashlytics for example)
        /*
        #if !DEBUG
        #endif
        */
    }
    // MARK: - Private
    private static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    private static func stringFromDate(_ date: Date) -> String { dateFormatter.string(from: date) }
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

//
//  UnixTimeInterval.swift
//  innocoin
//
//  Created by Yuri Drigin on 16.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

/// Unix time interval in millisec.
/// iOS timeinterval in sec
struct UnixTimeInterval: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    
    typealias FloatLiteralType = Double
    typealias IntegerLiteralType = Int64
    
    private var value: TimeInterval
    
    var date: Date {
        return Date(timeIntervalSince1970: value)
    }
    
    var unixTimeinterval: Int {
        return Int(value * 1000)
    }
    
    init(floatLiteral value: Double) {
        self.value = value / 1000
    }
    
    init(integerLiteral value: Int64) {
        self.value = Double(value / 1000)
    }
    
    init() {
        value = Date().timeIntervalSince1970
    }
}

extension UnixTimeInterval: Comparable {
    static func <(lhs: UnixTimeInterval, rhs: UnixTimeInterval) -> Bool {
        return lhs.value < rhs.value
    }
    
    static func ==(lhs: UnixTimeInterval, rhs: UnixTimeInterval) -> Bool {
        return lhs.value == rhs.value
    }
}

extension UnixTimeInterval: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Double.self) / 1000
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(unixTimeinterval)
    }
    
}

extension UnixTimeInterval: CustomStringConvertible, CustomDebugStringConvertible {
    
    var description: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self.date)
    }
    
    var humanReadable: String {
        return DateFormatter().timeSince(from: self.date)
    }
    
    var debugDescription: String {
        return "UnixFomatDate: \(description) value: \(self.value)"
    }

}

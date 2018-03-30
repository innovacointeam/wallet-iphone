//
//  CryptoCurrency.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

protocol CryptoCurrency: Codable, Comparable, ExpressibleByFloatLiteral, CustomStringConvertible, CustomDebugStringConvertible {

    static var zero: Self { get }
    var amount: Double { get set }
    var symbol: String { get }
    var bits: Int { get }
    init()
}

extension CryptoCurrency {
    
    init(_ value: Double) {
        self.init()
        amount = value
    }
    
    init(floatLiteral value: Double) {
        self.init()
        amount = value
    }
    
    init(from decoder: Decoder) throws {
        self.init()
        let value = try decoder.singleValueContainer()
        amount = try value.decode(Double.self)
    }
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = bits
        formatter.minimumFractionDigits = bits
        formatter.minimumIntegerDigits = 1
        return formatter
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(amount)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.amount < rhs.amount
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.amount == rhs.amount
    }

    var format: String {
        let str = formatter.string(from: NSNumber(floatLiteral: amount))!
        return "\(str) %@"
    }
    
    var humanDescription: String {
        return String(format: format, symbol)
    }
    
    var debugDescription: String {
        return String(format: format, symbol)
    }
    
    var string: String {
        return formatter.string(from: NSNumber(floatLiteral: amount))!
    }
}

//
//  CryptoCurrency.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

protocol CryptoCurrency: Codable, Comparable, ExpressibleByFloatLiteral, CustomStringConvertible, CustomDebugStringConvertible {
    var amount: Double { get set }
    var symbol: String { get }
    init()
}

extension CryptoCurrency {
    
    init(floatLiteral value: Double) {
        self.init()
        amount = value
    }
    
    init(from decoder: Decoder) throws {
        self.init()
        let value = try decoder.singleValueContainer()
        amount = try value.decode(Double.self)
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

    var debugDescription: String {
        return String(format: "%.8f %@", amount, symbol)
    }
}

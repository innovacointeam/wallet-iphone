//
//  USDCoin.swift
//  innocoin
//
//  Created by Yuri Drigin on 20.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct USDCoin: CryptoCurrency {
    
    static let zero = USDCoin()
    
    var description: String {
        return "Amount in USD"
    }
    
    var amount: Double
    var symbol = "USD"
    var bits = 2

    init() {
        amount = 0
    }
}

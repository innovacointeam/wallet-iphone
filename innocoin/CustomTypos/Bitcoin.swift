//
//  Bitcoin.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct Bitcoin: CryptoCurrency {
    
    var amount: Double
    let symbol = "BTC"
    let description = "Bitcoin"
    
    init() {
        amount = 0
    }
}

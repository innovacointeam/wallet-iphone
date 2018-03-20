//
//  InnovaCoin.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct InnovaCoin: CryptoCurrency {

    var amount: Double
    let symbol = "INN"
    let description = "Innova coin"
    
    init() {
        amount = 0
    }
    
    var usd: Double {
        return amount * MarketPriceController.shared.innovaToUSD
    }
}

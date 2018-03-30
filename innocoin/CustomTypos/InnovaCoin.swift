//
//  InnovaCoin.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct InnovaCoin: CryptoCurrency  {
    
    static let zero = InnovaCoin()
    
    var amount: Double
    let symbol = "INN"
    let description = "Innova coin"
    let bits = 8

    init() {
        amount = 0
    }

}


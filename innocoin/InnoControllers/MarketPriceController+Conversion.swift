//
//  MarketPriceController+Conversion.swift
//  innocoin
//
//  Created by Yuri Drigin on 20.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

extension MarketPriceController {
    
    func convert<To:CryptoCurrency, From:CryptoCurrency>(from coins: From) -> To {
        var newCoins = To()
        switch (To().symbol, coins.symbol) {
        case (InnovaCoin().symbol, USDCoin().symbol):
            newCoins.amount = coins.amount / INNToUSD
        case (USDCoin().symbol, InnovaCoin().symbol):
            newCoins.amount = coins.amount * INNToUSD
        case (InnovaCoin().symbol, Bitcoin().symbol):
            newCoins.amount = coins.amount / INNtoBTC
        case (Bitcoin().symbol, InnovaCoin().symbol):
            newCoins.amount = coins.amount * INNtoBTC
        default:
            break
        }
        return newCoins
    }
    
}

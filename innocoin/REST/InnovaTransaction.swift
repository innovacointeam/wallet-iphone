//
//  InnovaTransaction.swift
//  innocoin
//
//  Created by Yuri Drigin on 16.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct InnovaTransaction: Codable {
    
    var id: String
    var account:String
    var address: String
    var category: String
    var amount: InnovaCoin
    var label: String?
    var comment:String?
    var vout: Int
    var fee: InnovaCoin
    var confirmations: Int
    var blockhash: String
    var blockindex: Int
    var blocktime: UnixTimeInterval
    var time: UnixTimeInterval
    var timereceived: UnixTimeInterval
    var bip125_replaceable: String
    var abandoned: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "txid"
        case account
        case address
        case category
        case amount
        case label
        case comment
        case vout
        case fee
        case confirmations
        case blockhash
        case blockindex
        case blocktime
        case time
        case timereceived
        case bip125_replaceable
        case abandoned
    }
}

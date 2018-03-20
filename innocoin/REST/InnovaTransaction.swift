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
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        account = try container.decode(String.self, forKey: .account)
//        address = try container.decode(String.self, forKey: .address)
//        category = try container.decode(String.self, forKey: .category)
//        amount = try container.decode(Double.self, forKey: .amount)
//        label = try container.decodeIfPresent(String.self, forKey: .label)
//        comment = try container.decodeIfPresent(String.self, forKey: .comment)
//        vout = try container.decode(Double.self, forKey: .vout)
//        fee = try container.decode(Double.self, forKey: .fee)
//        confirmations = try container.decode(Double.self, forKey: .confirmations)
//        blockhash = try container.decode(String.self, forKey: .blockhash)
//        blockindex = try container.decode(Int.self, forKey: .blockindex)
//        blocktime = try container.decode(UnixTimeInterval.self, forKey: .blocktime)
//        time = try container.decode(UnixTimeInterval.self, forKey: .time)
//        timereceived = try container.decode(UnixTimeInterval.self, forKey: .timereceived)
//        bip125_replaceable = try container.decode(String.self, forKey: .bip125_replaceable)
//        abandoned = try container.decode(Bool.self, forKey: .abandoned)
//    }

}

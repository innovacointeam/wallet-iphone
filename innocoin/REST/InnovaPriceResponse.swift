//
//  InnovaPriceResponse.swift
//  innocoin
//
//  Created by Yuri Drigin on 13.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct InnovaPriceResponse: Codable {
    
    var result: InnovaPriceData
    
    var price: InnovaPrice {
        return result.price
    }
}

struct InnovaPriceData: Codable {
    
    var price: InnovaPrice
    enum CodingKeys: String, CodingKey {
        case price = "price_data"
    }
}

struct InnovaPrice: Codable {
    
    var innToBtc: Double
    var btcToUsd: Double
    var innToUsd: Double
    var timestamp: UnixTimeInterval
    
    enum CodingKeys: String, CodingKey {
        case innToBtc = "inn_to_btc"
        case btcToUsd = "btc_to_usd"
        case innToUsd = "inn_to_usd"
        case timestamp = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        innToBtc = try values.decode(Double.self, forKey: .innToBtc)
        btcToUsd = try values.decode(Double.self, forKey: .btcToUsd)
        innToUsd = try values.decode(Double.self, forKey: .innToUsd)
        timestamp = try values.decode(UnixTimeInterval.self, forKey: .timestamp)
    }
}

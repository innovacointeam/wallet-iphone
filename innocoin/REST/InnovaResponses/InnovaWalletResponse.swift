//
//  InnovaWalletResponse.swift
//  innocoin
//
//  Created by Yuri Drigin on 18.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct InnovaWalletResponse: Decodable {
    
    let error: InnovaResponseErrror!
    let wallet: InnovaWallet!
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
    
    enum WalletKey: String, CodingKey {
        case wallet = "wallet_account"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(InnovaResponseErrror.self, forKey: .error)
        if values.contains(.result) {
            let result = try values.nestedContainer(keyedBy: WalletKey.self, forKey: .result)
            wallet = try result.decode(InnovaWallet.self, forKey: .wallet)
        } else {
            wallet = nil
        }
    }
}

struct InnovaWallet: Decodable {
    
    let id: String
    let balance: InnovaCoin
    let addresses: [InnovaWalletAddress]!
    
    enum InnovaWalletCodingKeys: String, CodingKey {
        case id
        case balance
        case addresses = "address_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: InnovaWalletCodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        balance = try values.decode(InnovaCoin.self, forKey: .balance)
        addresses = try values.decode([InnovaWalletAddress].self, forKey: .addresses)
    }
}

struct InnovaWalletAddress: Decodable {
    
    var address: String
    var created: UnixTimeInterval
    
}

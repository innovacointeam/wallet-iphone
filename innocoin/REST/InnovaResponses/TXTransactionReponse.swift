//
//  TXTransactionReponse.swift
//  innocoin
//
//  Created by Yuri Drigin on 29.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation


struct TXTransactionReponse: Decodable {
    
    let error: InnovaResponseErrror?
    let transaction: InnovaTransaction?
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
    
    enum TransactionKey: String, CodingKey {
        case transaction = "trx_request"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(InnovaResponseErrror.self, forKey: .error)
        if values.contains(.result) {
            let result = try values.nestedContainer(keyedBy: TransactionKey.self, forKey: .result)
            transaction = try result.decode(InnovaTransaction.self, forKey: .transaction)
        } else {
            transaction = nil
        }
    }
}



//
//  InnovaTransactionsResponse.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation


struct InnovaTransactionsResponse: Decodable {

    var error: InnovaResponseErrror?
    var transactions: [InnovaTransaction] = [InnovaTransaction]()

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
    
    enum TransactionsKey: String, CodingKey {
        case transactions = "transactions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if values.contains(.result) {
            let result = try values.nestedContainer(keyedBy: TransactionsKey.self, forKey: .result)
            self.transactions = try result.decode([InnovaTransaction].self, forKey: .transactions)
        }
        error = try values.decodeIfPresent(InnovaResponseErrror.self, forKey: .error)
    }
}

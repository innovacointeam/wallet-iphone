//
//  SendResponse.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct PendingTransactionResponse: Decodable {
    
    var error: InnovaResponseErrror?
    var request: PendingTransaction?
    var transactions: [PendingTransaction]?
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
    
    enum TRXRequestKey: String, CodingKey {
        case request = "trx_request"
        case transactions = "transaction_requests"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if values.contains(.result) {
            let result = try values.nestedContainer(keyedBy: TRXRequestKey.self, forKey: .result)
            self.request = try result.decodeIfPresent(PendingTransaction.self, forKey: .request)
            self.transactions = try result.decodeIfPresent([PendingTransaction].self, forKey: .transactions)
        }
        error = try values.decodeIfPresent(InnovaResponseErrror.self, forKey: .error)
    }
}

struct PendingTransaction: Decodable, CustomStringConvertible {
    var id: String
    var user: String
    var amount: InnovaCoin
    var recepient: String
    var comment: String?
    var state: PendingTransactionState
    var created: UnixTimeInterval
    
    var status: PendingTransactionStatus {
        return PendingTransactionStatus(state.status)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case user = "user_id"
        case amount
        case recepient = "to_address"
        case comment
        case state
        case created
    }
    
    var description: String {
        return "PENDING"
    }
}

struct PendingTransactionState: Decodable {
    var status: String
    var result: String?
    var completed_at: UnixTimeInterval?
    var failed_at: UnixTimeInterval?
}

enum PendingTransactionStatus: String {
    case pending = "pending"
    case failed = "failed"
    case completed = "completed"
    case unknown = "unknown"
    
    init(_ value: String) {
        guard let status = PendingTransactionStatus(rawValue: value) else {
            self = .unknown
            return
        }
        self = status
    }
}

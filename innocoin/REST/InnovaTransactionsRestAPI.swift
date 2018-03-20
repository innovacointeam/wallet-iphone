//
//  InnovaTransactionsRestAPI.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

enum InnovaTransactionsRestAPI: RestAPIProtocol {
    
    case sendedTransactionList
    case receivedTransactionList
    
    var method: String {
        return "GET"
    }
    
    var path: String {
        switch self {
        case .receivedTransactionList:
            return "wallet/account/transactions/received"
        case .sendedTransactionList:
            return "wallet/account/transactions/sent"
        }
    }
    
    var param: Parameters {
        return [:]
    }
    
    var description: String {
        switch self {
        case .receivedTransactionList:
            return "Request received transactions"
        case .sendedTransactionList:
            return "Request sended transactions"
        }
    }
}

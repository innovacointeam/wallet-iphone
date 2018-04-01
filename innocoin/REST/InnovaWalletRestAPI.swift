//
//  InnovaWalletRestAPI.swift
//  innocoin
//
//  Created by Yuri Drigin on 18.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

enum InnovaWalletRestAPI: RestAPIProtocol {
  
    case account
    case sendedTransactionList(page: Int, size: Int)
    case receivedTransactionList(page: Int, size: Int)
    case transactions(page: Int, size: Int)
    case sentInnova(to: String, amount: Double, pincode: String, comment: String?)
    case pendingTransactionList(page: Int, size: Int)
    case delete(id: String)
    case transaction(txid: String)
    
    var method: String {
        switch self {
        case .sentInnova:
            return "POST"
        case .delete:
            return "DELETE"
        default:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .transactions(let page, let size),
             .receivedTransactionList(let page, let size),
             .pendingTransactionList(let page, let size),
             .sendedTransactionList(let page, let size):
            let pageItem = URLQueryItem(name: "page", value: page.description)
            let sizeItem = URLQueryItem(name: "size", value: size.description)
            return [pageItem, sizeItem]
        default:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .account:
            return "/wallet/account"
        case .receivedTransactionList:
            return "/wallet/account/transactions/received"
        case .sendedTransactionList:
            return "/wallet/account/transactions/sent"
        case .sentInnova,
             .delete:
            return "/wallet/account/transaction_requests"
        case .pendingTransactionList:
            return "/wallet/account/transaction_requests/pending"
        case .transactions:
            return "/wallet/account/transactions"
        case .transaction(let txid):
            return "/wallet/account/transactions/\(txid)"
        }
    }
    
    var param: Parameters {
        var param = Parameters()
        switch self {
        case .sentInnova(let to, let amount, let pincode, let comment):
            param["to_address"] = to
            param["amount"] = amount
            param["pincode"] = pincode
            if let comment = comment {
                param["comment"] = comment
            }
        case .delete(let id):
            param["id"] = id
        default:
            break
        }
        return param
    }
    
    var description: String {
        switch self {
        case  .account:
            return "Request Innova Wallet addresses"
        case .receivedTransactionList:
            return "Request received transactions"
        case .sendedTransactionList:
            return "Request sended transactions"
        case .sentInnova:
            return "Try sending innova coin"
        case .pendingTransactionList:
            return "Request pending transactions list"
        case .transactions:
            return "Request all transactions list"
        case .transaction(let txid):
            return "Request info fro transaction: \(txid)"
        case .delete(let id):
            return "Try delete transaction with id: \(id)"
        }
    }
}

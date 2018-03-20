//
//  RESTController+Transactions.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

extension RESTController {
    
    func refreshTransactions(completion: (()->())? = nil) {
        // TODO: - to prevent lock concurency make it in serial Queue (may be)
        receivedTransactionList() { [weak self] in
            self?.sendedTransactionList() {
                completion?()
            }
        }
        
    }
    
    func sendedTransactionList(completion: (()->())? = nil ) {
        let rest = InnovaTransactionsRestAPI.sendedTransactionList
        call(rest) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, let code):
                debugPrint("Server answer error: \(code ?? 0): \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    let sended = try JSONDecoder().decode(InnovaTransactionsResponse.self, from: data).transactions
                    DataManager.shared.updateSended(transactions: sended)
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
  
    func receivedTransactionList(completion: (()->())? = nil) {
        let rest = InnovaTransactionsRestAPI.receivedTransactionList
        call(rest) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, let code):
                debugPrint("Server answer error: \(code ?? 0): \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    let received = try JSONDecoder().decode(InnovaTransactionsResponse.self, from: data).transactions
                    DataManager.shared.updateReceived(transactions: received)
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
}

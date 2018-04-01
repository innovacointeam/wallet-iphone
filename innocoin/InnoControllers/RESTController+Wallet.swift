//
//  RESTController+Wallet.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

extension RESTController {
    
    func send(to addres: String, amount: Double, pincode: String, comment: String?, completion: ((ServerResponse)->())?) {
        let rest = InnovaWalletRestAPI.sentInnova(to: addres, amount: amount, pincode: pincode, comment: comment)
        call(rest) { response in
            completion?(response)
        }
    }
    
    func update(txid: String, completion: ((ServerResponse)->())?) {
        let rest = InnovaWalletRestAPI.transaction(txid: txid)
        call(rest) { response in
            completion?(response)
        }
    }
    
    func delete(txid: String, completion: ((ServerResponse)->())?) {
        let rest = InnovaWalletRestAPI.delete(id: txid)
        call(rest) { response in
            completion?(response)
        }
    }
    
    func wallet(completion: (()->())? = nil ) {
        let rest = InnovaWalletRestAPI.account
        call(rest) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, _):
                debugPrint("Server answer error: \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    if let wallet = try JSONDecoder().decode(InnovaWalletResponse.self, from: data).wallet {
                        UserController.shared.wallet = wallet
                        DataManager.shared.lastWallet = data
                    }
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
    
    func refreshTransactions(page: Int = 0, size: Int = 10, completion: (()->())? = nil) {
        wallet() { [weak self] in
            self?.queryTransactionsList(page: page, size: size) {
                self?.queryPendingTransactionsList() {
                    completion?()
                }
            }
        }
    }
    
    func queryPendingTransactionsList(page: Int = 0, size: Int = 10, completion: (()->())? = nil) {
        let query = InnovaWalletRestAPI.pendingTransactionList(page: page, size: size)
        call(query) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, _):
                debugPrint("Server answer error: \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    if let pending = try JSONDecoder().decode(PendingTransactionResponse.self, from: data).transactions {
                       UserController.shared.pending = pending
                        // Save data to using before loaded
                       DataManager.shared.lastPending = data
                    }
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
    
    func queryTransactionsList(page: Int = 0, size: Int = 10, completion: (()->())? = nil ) {
        let rest = InnovaWalletRestAPI.transactions(page: page, size: size)
        call(rest) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, _):
                debugPrint("Server answer error: \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    let sended = try JSONDecoder().decode(InnovaTransactionsResponse.self, from: data).transactions
                    DataManager.shared.update(transactions: sended)
                    // if hase previous transaction - query it
                    if sended.count == 10 {
                        self.startPage += 1
                        DispatchQueue.global(qos: .utility).async {
                            RESTController.shared.queryTransactionsList(page: self.startPage, size: 10, completion: nil)
                        }
                    }
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
    
    func sendedTransactionList(completion: (()->())? = nil ) {
        let rest = InnovaWalletRestAPI.sendedTransactionList(page: 0, size: 10)
        call(rest) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, _):
                debugPrint("Server answer error: \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    let sended = try JSONDecoder().decode(InnovaTransactionsResponse.self, from: data).transactions
                    DataManager.shared.update(transactions: sended)
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
  
    func receivedTransactionList(completion: (()->())? = nil) {
        let rest = InnovaWalletRestAPI.receivedTransactionList(page: 0, size: 10)
        call(rest) { response in
            defer {
                completion?()
            }
            switch response {
            case .error(let reason, _):
                debugPrint("Server answer error: \(reason ?? "Unknow")")
            case .success(let data, _):
                do {
                    let received = try JSONDecoder().decode(InnovaTransactionsResponse.self, from: data).transactions
                    DataManager.shared.update(transactions: received)
                } catch let error as DecodingError {
                    debugPrint(error)
                } catch let error as NSError {
                    debugPrint(error)
                }
            }
        }
    }
}

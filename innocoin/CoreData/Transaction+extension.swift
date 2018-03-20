//
//  Transaction+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

extension Transaction {
    
    var timestamp: UnixTimeInterval {
        return UnixTimeInterval(integerLiteral: timereceived)
    }
    
    var typeDescription: String {
        return isReceived ? "RECEIVED" : "SENT"
    }
    
    var typeDescriptionColor: UIColor {
        return isReceived ? UIColor.greenInnova : UIColor.redInnova
    }
    
    var amountCoins: InnovaCoin {
        return InnovaCoin(floatLiteral: amount)
    }
    
    var statusColor: UIColor {
        switch Int(confirmations) {
        case 0:
            return UIColor.redInnova
        case 1...InnovaConstanst.confirmationCountForTransaction:
            return UIColor.orange
        default:
            return UIColor.greenInnova
        }
    }
    
    var status: String {
        switch Int(confirmations) {
        case 0:
            return "pending"
        case 1...InnovaConstanst.confirmationCountForTransaction:
            return "\(confirmations) confirmations"
        default:
            return "confirmed"
        }
    }
    
    /// Fill send transaction from InnovaTransaction Structure
    ///
    /// - Parameter json: InnoveTransaction
    func send(_ json: InnovaTransaction) {
        from(json)
        isReceived = false
    }
    
    /// Fill received transaction from InnovaTransaction Structure
    ///
    /// - Parameter json: InnoveTransaction
    func received(_ json: InnovaTransaction)  {
        from(json)
        isReceived = true
    }
    
    private func from(_ json: InnovaTransaction) {
        id = json.id
        account = json.account
        address = json.address
        category = json.category
        amount = json.amount.amount
        label = json.label
        comment = json.comment
        vout = Int64(json.vout)
        fee = json.fee.amount
        confirmations =  Int64(json.confirmations)
        blockhash = json.blockhash
        blockindex = Int64(json.blockindex)
        blocktime = Int64(json.blocktime.unixTimeinterval)
        time = Int64(json.time.unixTimeinterval)
        timereceived = Int64(json.timereceived.unixTimeinterval)
        bip125 = json.bip125_replaceable
        abandoned = json.abandoned
    }
    
}

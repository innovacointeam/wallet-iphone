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
    
    var amountCoins: InnovaCoin {
        return InnovaCoin(floatLiteral: amount)
    }
    
    var type: TransactionType {
        return TransactionType(category)
    }
    
    var status: TransactionStatus {
        return TransactionStatus(confirmations)
    }
    
    var mainColor: UIColor {
        return status == .confirmed ? type.color : type.color.withAlphaComponent(0.5)
    }
    
    var statusColor: UIColor {
        return status.color
    }
    
    func populate(_ json: InnovaTransaction) {
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

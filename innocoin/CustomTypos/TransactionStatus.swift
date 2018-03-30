//
//  TransactionStatus.swift
//  innocoin
//
//  Created by Yuri Drigin on 20.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

enum TransactionStatus {
    
    case pending
    case accepted
    case confirmed

    init(_ count: Int64) {
        switch Int(count) {
        case 0:
            self = .pending
        case 1...InnovaConstanst.confirmationCountForConfirmTransaction:
            self = .accepted
        default:
            self = .confirmed
        }
    }
    
    var description: String {
        switch self {
        case .pending:
            return "pending"
        case .accepted:
            return "accepted"
        case .confirmed:
            return "confirmed"
        }
    }
    
    var color: UIColor {
        switch self {
        case .pending:
            return UIColor.placeholderTextColor
        case .accepted:
            return UIColor.yellow
        case .confirmed:
            return UIColor.greenInnova
        }
    }
    
    var backgorundColor: UIColor {
        switch self {
        case .pending:
            return UIColor.lightGray
        default:
            return UIColor.white
        }
    }
}

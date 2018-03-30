//
//  TransactionType.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

enum TransactionType: String, CustomStringConvertible, Equatable {
    
    case send = "send"
    case received = "receive"
    case pending = "pending"
    case unknown = "unknown"
    
    init(_ category: String?) {
        guard let category = category,
            let type = TransactionType(rawValue: category) else {
                self = .unknown
                return
        }
        self = type
    }
    
    var description: String {
        switch self {
        case .send:
            return "Sent"
        case .received:
            return "Received"
        case .pending:
            return "Pending"
        case .unknown:
            return ""
        }
    }
    
    var color: UIColor {
        switch self {
        case .send:
            return UIColor.redInnova
        case .received:
            return UIColor.greenInnova
        default:
            return UIColor.lightGray
        }
    }
}

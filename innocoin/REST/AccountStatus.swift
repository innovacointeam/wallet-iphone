//
//  AccountStatus.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

enum AccountStatus: String {
    
     case pending = "pending"
     case active = "active"
     case locked = "locked"
     case blocked = "blocked"
    
     case unknown = "unknown"
    
    var color: UIColor {
        switch self {
        case .unknown,
            .pending:
            return UIColor.yellow
        case .active:
            return UIColor.green
        case .locked,
             .blocked:
            return UIColor.red
        }
    }
}

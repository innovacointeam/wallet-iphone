//
//  AccountStatus.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

enum AccountStatus: String {
    
     case pending = "pending"
     case active = "active"
     case locked = "locked"
     case blocked = "blocked"
    
     case unknown = "unknown"
}

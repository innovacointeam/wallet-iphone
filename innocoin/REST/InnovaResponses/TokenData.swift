//
//  TokenData.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct TokenData: Decodable {
    
    var user_id: String
    var email: String
    var exp_time: UnixTimeInterval
    
}

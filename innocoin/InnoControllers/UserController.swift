//
//  UserController.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

class UserController {
    
    static let shared = UserController()
    
    var profile: UserProfile!
    var token: String!
    
    var wallet: String? {
        return profile.wallet
    }
    
    var status: AccountStatus {
        return profile.status
    }
    
    var email: String {
        return profile.email
    }
    
    func logout() {
        profile = nil
        token = nil
    }
}

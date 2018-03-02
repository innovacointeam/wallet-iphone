//
//  SignInResult.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct UserToken: Codable {
    var token: String
    var user: UserProfile
}

struct SignInResult: Codable {
    var result: UserToken
}

//
//  UserProfile.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct UserName: Codable {
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct UserProfile: Codable {
    var id: String
    var email: String
    var wallet: String?
    var name: UserName?
    var anonymous: Bool
    private var statusRaw: String
    
    var status: AccountStatus {
        return AccountStatus(rawValue: statusRaw) ?? .unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case wallet = "wallet_account"
        case name = "full_name"
        case anonymous
        case statusRaw = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        wallet = try container.decodeIfPresent(String.self, forKey: .wallet)
        name = try container.decodeIfPresent(UserName.self, forKey: .name)
        statusRaw = try container.decode(String.self, forKey: .statusRaw)
        do {
            anonymous = try container.decode(Bool.self, forKey: .anonymous)
        } catch DecodingError.typeMismatch {
            let anonumousInt = try container.decode(Int.self, forKey: .anonymous)
            anonymous = anonumousInt == 1
        }
    }
}



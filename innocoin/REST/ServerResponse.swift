//
//  ServerResponse.swift
//  innocoin
//
//  Created by Yuri Drigin on 26.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

enum ServerResponse: Equatable {
    
    case error(reason: String?, code: Int?)
    case success(data: Data, code: Int)
    
    var isSuccess: Bool {
        return self == .error(reason: "", code: 0)
    }
    
    static func ==(lhs: ServerResponse, rhs: ServerResponse) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error),
             (.success, .success):
            return true
        default:
            return false
        }
    }
}

struct ErrorResponse: Codable {
    var error: ErrorReason
}

struct ErrorReason: Codable {
    var reason: String
}

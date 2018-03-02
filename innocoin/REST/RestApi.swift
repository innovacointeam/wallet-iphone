//
//  RestApi.swift
//  innocoin
//
//  Created by Yuri Drigin on 26.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

let defaultTimeoutInterval: TimeInterval = 10
let innoHost = URL(string: "http://159.89.109.174/api/v1.0")!

enum RestApi {
    
    case questionsList
    case signin(email: String, password: String)
    case signup(user: SignUpUser)
    case verifyToken(email: String)
    case profile(id: String)
    
    var method: String {
        switch self {
        case .questionsList,
             .profile:
            return "GET"
        case .signin,
             .signup,
             .verifyToken:
            return "POST"
        }
    }
    
    private var path: String {
        switch self {
        case .questionsList:
            return "signup/security_questions"
        case .signup:
            return "signup"
        case .signin:
            return "login"
        case .verifyToken:
            return "signup/verifytoken/send"
        case .profile(let id):
            return "users/\(id)"
        }
    }
    
    private var param: Data? {
        switch self {
        case .signup(let user):
            do {
                return try JSONEncoder().encode(user)
            } catch let error as NSError {
                debugPrint("Failed codable signup: \(error.localizedFailureReason ?? error.localizedDescription)")
                return nil
            }
        case .signin(let email, let password):
            let json = [
                "email": email,
                "password": password
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        case .verifyToken(let email):
            let json = [
                "email": email
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        default:
            return nil
        }
    }
    
    var statusCode: Int {
        switch self {
        case .verifyToken:
            return 202
        default:
            return 200
        }
    }
    
    var url: URL {
        return innoHost.appendingPathComponent(self.path)
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.url)
        request.timeoutInterval = defaultTimeoutInterval
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = self.method
        request.httpBody = self.param
        return request
    }
}

extension RestApi: CustomDebugStringConvertible, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .questionsList:
            return "Request Question List"
        case .signin:
            return "Login to server"
        case .signup:
            return "SignUp new user"
        case .verifyToken:
            return "Verify login token"
        case .profile:
            return "Request user profile"
        }
    }
    
    var debugDescription: String {
        let paramStr = param != nil ? String(data: param!, encoding: .utf8)! : "NULL"
        let text = """
            URL for request: \(self.url.absoluteString)
            Method: \(self.method)
            With param: \(paramStr)")
        """
        return text
    }
    
    
}
